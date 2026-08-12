<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use App\Models\Report;
use App\Models\ReportAssignment;
use App\Models\ReportTimeline;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ReportController extends Controller
{
    // ──────────────────────────────────────────────────────────
    // GET /api/reports
    // List reports with optional filters:
    //   ?status=pending&category=infrastructure&barangay=Aplaya&office=CEO&search=road&page=1
    // ──────────────────────────────────────────────────────────
    public function index(Request $request): JsonResponse
    {
        $user  = $request->user();
        $query = Report::with(['latestAssignment', 'beforePhoto']);

        // ── Role scoping ──────────────────────────────────────
        // CEO and CENRO only see reports assigned to their office
        if ($user->role === 'ceo') {
            $query->where('assigned_to_office', 'CEO');
        } elseif ($user->role === 'cenro') {
            $query->where('assigned_to_office', 'CENRO');
        }

        // ── Filters ───────────────────────────────────────────
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('category')) {
            $query->where('category', $request->category);
        }

        if ($request->filled('barangay')) {
            $query->where('barangay', $request->barangay);
        }

        if ($request->filled('office')) {
            $query->where('assigned_to_office', $request->office);
        }

        if ($request->filled('priority')) {
            $query->where('priority', $request->priority);
        }

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('reference_no',  'like', "%{$search}%")
                  ->orWhere('title',       'like', "%{$search}%")
                  ->orWhere('barangay',    'like', "%{$search}%")
                  ->orWhere('submitted_by','like', "%{$search}%");
            });
        }

        $reports = $query->orderBy('created_at', 'desc')->paginate(20);

        return response()->json([
            'success' => true,
            'data'    => $reports,
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/reports/{id}
    // Full detail view of one report including timeline & photos
    // ──────────────────────────────────────────────────────────
    public function show(Request $request, int $id): JsonResponse
    {
        $user   = $request->user();
        $report = Report::with([
            'timeline.performedBy',
            'photos',
            'assignments.assignedBy',
        ])->findOrFail($id);

        // ── Role access check ─────────────────────────────────
        if ($user->role === 'ceo' && $report->assigned_to_office !== 'CEO') {
            return response()->json(['success' => false, 'message' => 'Access denied.'], 403);
        }

        if ($user->role === 'cenro' && $report->assigned_to_office !== 'CENRO') {
            return response()->json(['success' => false, 'message' => 'Access denied.'], 403);
        }

        return response()->json([
            'success' => true,
            'data'    => $report,
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // POST /api/reports
    // Create a new report (super_admin only — or future citizen API)
    // ──────────────────────────────────────────────────────────
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title'             => 'required|string|max:255',
            'description'       => 'nullable|string',
            'category'          => ['required', Rule::in(['infrastructure','environmental','public_safety','sanitation','other'])],
            'barangay'          => 'nullable|string|max:100',
            'lat'               => 'nullable|numeric',
            'lng'               => 'nullable|numeric',
            'address_text'      => 'nullable|string|max:255',
            'submitted_by'      => 'nullable|string|max:120',
            'submitted_contact' => 'nullable|string|max:100',
            'priority'          => ['nullable', Rule::in(['low','medium','high','critical'])],
        ]);

        $validated['reference_no'] = Report::generateReferenceNo();
        $validated['status']       = 'submitted';
        $validated['priority']     = $validated['priority'] ?? 'medium';

        $report = Report::create($validated);

        // Log the creation on the timeline
        ReportTimeline::log(
            $report->id,
            'report_submitted',
            null,
            'submitted',
            $request->user()?->id,
            'Report submitted.'
        );

        // Notify all super admins
        Notification::sendToRole(
            'super_admin',
            "New report submitted: {$report->reference_no} — {$report->title} in {$report->barangay}.",
            'report_submitted',
            $report->id
        );

        return response()->json([
            'success' => true,
            'message' => 'Report created successfully.',
            'data'    => $report,
        ], 201);
    }

    // ──────────────────────────────────────────────────────────
    // PUT /api/reports/{id}
    // Update basic report fields (super_admin only)
    // ──────────────────────────────────────────────────────────
    public function update(Request $request, int $id): JsonResponse
    {
        $this->requireRole($request, 'super_admin');

        $report = Report::findOrFail($id);

        $validated = $request->validate([
            'title'        => 'sometimes|string|max:255',
            'description'  => 'sometimes|nullable|string',
            'category'     => ['sometimes', Rule::in(['infrastructure','environmental','public_safety','sanitation','other'])],
            'barangay'     => 'sometimes|nullable|string|max:100',
            'lat'          => 'sometimes|nullable|numeric',
            'lng'          => 'sometimes|nullable|numeric',
            'address_text' => 'sometimes|nullable|string|max:255',
            'priority'     => ['sometimes', Rule::in(['low','medium','high','critical'])],
        ]);

        $report->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Report updated.',
            'data'    => $report,
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // DELETE /api/reports/{id}
    // Soft-delete / hard-delete a report (super_admin only)
    // ──────────────────────────────────────────────────────────
    public function destroy(Request $request, int $id): JsonResponse
    {
        $this->requireRole($request, 'super_admin');

        $report = Report::findOrFail($id);
        $report->delete();

        return response()->json([
            'success' => true,
            'message' => "Report {$report->reference_no} deleted.",
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // POST /api/reports/{id}/validate
    // Super admin validates (approves) a submitted report
    // Moves status: submitted → pending
    // ──────────────────────────────────────────────────────────
    public function validateReport(Request $request, int $id): JsonResponse
    {
        $this->requireRole($request, 'super_admin');

        $report = Report::findOrFail($id);

        if ($report->status !== 'submitted') {
            return response()->json([
                'success' => false,
                'message' => 'Only submitted reports can be validated.',
            ], 422);
        }

        $report->update(['status' => 'pending']);

        ReportTimeline::log(
            $report->id,
            'status_change',
            'submitted',
            'pending',
            $request->user()->id,
            'Report validated by super admin.'
        );

        return response()->json([
            'success' => true,
            'message' => 'Report validated. Ready for assignment.',
            'data'    => $report,
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // POST /api/reports/{id}/reject
    // Super admin rejects a submitted report
    // ──────────────────────────────────────────────────────────
    public function rejectReport(Request $request, int $id): JsonResponse
    {
        $this->requireRole($request, 'super_admin');

        $request->validate([
            'reason' => 'nullable|string|max:500',
        ]);

        $report = Report::findOrFail($id);

        if (!in_array($report->status, ['submitted', 'pending'])) {
            return response()->json([
                'success' => false,
                'message' => 'Only submitted or pending reports can be rejected.',
            ], 422);
        }

        $oldStatus = $report->status;
        $report->update(['status' => 'resolved']); // treat rejected as closed

        ReportTimeline::log(
            $report->id,
            'report_rejected',
            $oldStatus,
            'resolved',
            $request->user()->id,
            $request->reason ?? 'Report rejected by super admin.'
        );

        return response()->json([
            'success' => true,
            'message' => 'Report rejected.',
            'data'    => $report,
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // POST /api/reports/{id}/assign
    // Super admin assigns a report to CEO or CENRO
    // Body: { assigned_to: 'CEO'|'CENRO', priority: 'high', notes: '...' }
    // ──────────────────────────────────────────────────────────
    public function assign(Request $request, int $id): JsonResponse
    {
        $this->requireRole($request, 'super_admin');

        $validated = $request->validate([
            'assigned_to' => ['required', Rule::in(['CEO', 'CENRO'])],
            'priority'    => ['required', Rule::in(['low','medium','high','critical'])],
            'notes'       => 'nullable|string|max:1000',
        ]);

        $report = Report::findOrFail($id);

        if (!in_array($report->status, ['pending', 'submitted'])) {
            return response()->json([
                'success' => false,
                'message' => 'Only pending reports can be assigned.',
            ], 422);
        }

        // Create the assignment record
        ReportAssignment::create([
            'report_id'   => $report->id,
            'assigned_to' => $validated['assigned_to'],
            'assigned_by' => $request->user()->id,
            'priority'    => $validated['priority'],
            'notes'       => $validated['notes'] ?? null,
        ]);

        // Update the report itself
        $report->update([
            'status'             => 'assigned',
            'assigned_to_office' => $validated['assigned_to'],
            'priority'           => $validated['priority'],
        ]);

        ReportTimeline::log(
            $report->id,
            'report_assigned',
            'pending',
            'assigned',
            $request->user()->id,
            "Assigned to {$validated['assigned_to']} with {$validated['priority']} priority." .
            ($validated['notes'] ? " Notes: {$validated['notes']}" : '')
        );

        // Notify the assigned office users
        $officeRole = strtolower($validated['assigned_to']); // 'ceo' or 'cenro'
        Notification::sendToRole(
            $officeRole,
            "Report {$report->reference_no} has been assigned to your office: {$report->title}.",
            'report_assigned',
            $report->id
        );

        return response()->json([
            'success' => true,
            'message' => "Report assigned to {$validated['assigned_to']}.",
            'data'    => $report->fresh(['latestAssignment']),
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // POST /api/reports/{id}/status
    // Office users (CEO/CENRO) update their report's progress
    // Body: { status: 'in_progress'|'for_resolution'|'resolved', note: '...' }
    // ──────────────────────────────────────────────────────────
    public function updateStatus(Request $request, int $id): JsonResponse
    {
        $user   = $request->user();
        $report = Report::findOrFail($id);

        // Verify the office user owns this report
        if ($user->role === 'ceo' && $report->assigned_to_office !== 'CEO') {
            return response()->json(['success' => false, 'message' => 'Access denied.'], 403);
        }
        if ($user->role === 'cenro' && $report->assigned_to_office !== 'CENRO') {
            return response()->json(['success' => false, 'message' => 'Access denied.'], 403);
        }

        $validated = $request->validate([
            'status' => ['required', Rule::in(['in_progress','for_resolution','resolved'])],
            'note'   => 'nullable|string|max:1000',
        ]);

        $oldStatus = $report->status;
        $updates   = ['status' => $validated['status']];

        if ($validated['status'] === 'resolved') {
            $updates['resolved_at'] = now();
        }

        $report->update($updates);

        ReportTimeline::log(
            $report->id,
            'status_change',
            $oldStatus,
            $validated['status'],
            $user->id,
            $validated['note'] ?? "Status updated to {$validated['status']}."
        );

        // Notify super admins of the update
        Notification::sendToRole(
            'super_admin',
            "Report {$report->reference_no} status changed to {$validated['status']} by {$user->office}.",
            'status_update',
            $report->id
        );

        return response()->json([
            'success' => true,
            'message' => 'Status updated.',
            'data'    => $report->fresh(),
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/reports/map
    // Returns all reports with GPS coords for map pins
    // ──────────────────────────────────────────────────────────
    public function mapPins(Request $request): JsonResponse
    {
        $user  = $request->user();
        $query = Report::whereNotNull('lat')->whereNotNull('lng')
                       ->select('id','reference_no','title','status','category','barangay','lat','lng','assigned_to_office');

        if ($user->role === 'ceo') {
            $query->where('assigned_to_office', 'CEO');
        } elseif ($user->role === 'cenro') {
            $query->where('assigned_to_office', 'CENRO');
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        return response()->json([
            'success' => true,
            'data'    => $query->get(),
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // Private helper — role guard
    // ──────────────────────────────────────────────────────────
    private function requireRole(Request $request, string $role): void
    {
        if ($request->user()->role !== $role) {
            abort(403, 'Insufficient permissions.');
        }
    }
}
