<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Announcement;
use App\Models\CitizenReport;
use App\Models\GovernmentOffice;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;

class AdminWebController extends Controller
{
    // ─────────────────────────────────────────────────────────────────────
    // Auth
    // ─────────────────────────────────────────────────────────────────────

    public function showLogin(): View
    {
        return view('admin.login');
    }

    public function login(Request $request): RedirectResponse
    {
        $credentials = $request->validate([
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        // Map password → password_hash field via Auth
        if (! Auth::attempt(['email' => $credentials['email'], 'password' => $credentials['password']])) {
            return back()->withErrors(['email' => 'Invalid email or password.'])->withInput();
        }

        if (! Auth::user()->is_active) {
            Auth::logout();
            return back()->withErrors(['email' => 'Your account has been deactivated.']);
        }

        Auth::user()->update(['last_login_at' => now()]);
        $request->session()->regenerate();

        return redirect()->route('admin.dashboard');
    }

    public function logout(Request $request): RedirectResponse
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect()->route('admin.login');
    }

    // ─────────────────────────────────────────────────────────────────────
    // Dashboard
    // ─────────────────────────────────────────────────────────────────────

    public function dashboard(): View
    {
        $stats = [
            'total'              => CitizenReport::count(),
            'submitted'          => CitizenReport::where('status', CitizenReport::STATUS_SUBMITTED)->count(),
            'pending_validation' => CitizenReport::where('status', CitizenReport::STATUS_PENDING_VALIDATION)->count(),
            'assigned'           => CitizenReport::where('status', CitizenReport::STATUS_ASSIGNED)->count(),
            'in_progress'        => CitizenReport::where('status', CitizenReport::STATUS_IN_PROGRESS)->count(),
            'resolved'           => CitizenReport::where('status', CitizenReport::STATUS_RESOLVED)->count(),
        ];

        $recentReports = CitizenReport::with('assignedOffice')
            ->orderBy('created_at', 'desc')
            ->limit(8)
            ->get();

        $announcements = Announcement::published()
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();

        return view('admin.dashboard', compact('stats', 'recentReports', 'announcements'));
    }

    // ─────────────────────────────────────────────────────────────────────
    // Citizen Reports
    // ─────────────────────────────────────────────────────────────────────

    public function reportsIndex(Request $request): View
    {
        $query = CitizenReport::with(['citizen', 'assignedOffice'])
            ->orderBy('created_at', 'desc');

        if ($request->filled('status'))   $query->where('status', $request->status);
        if ($request->filled('category')) $query->where('category', $request->category);
        if ($request->filled('barangay')) $query->where('barangay', $request->barangay);
        if ($request->filled('search')) {
            $s = $request->search;
            $query->where(fn($q) => $q->where('reference_number', 'like', "%{$s}%")
                                      ->orWhere('concern', 'like', "%{$s}%")
                                      ->orWhere('barangay', 'like', "%{$s}%"));
        }

        $reports = $query->paginate(25)->withQueryString();
        return view('admin.citizen-reports.index', compact('reports'));
    }

    public function reportsShow(int $id): View
    {
        $report  = CitizenReport::with(['citizen', 'assignedOffice', 'activities'])->findOrFail($id);
        $offices = GovernmentOffice::where('is_active', true)->orderBy('name')->get();
        return view('admin.citizen-reports.show', compact('report', 'offices'));
    }

    public function reportsValidate(int $id): RedirectResponse
    {
        $report = CitizenReport::findOrFail($id);
        $report->update(['is_public' => true]);
        if (in_array($report->status, [CitizenReport::STATUS_SUBMITTED, CitizenReport::STATUS_PENDING_VALIDATION])) {
            $report->transitionTo(CitizenReport::STATUS_PENDING_VALIDATION);
        }
        return back()->with('success', 'Report validated and published to community map.');
    }

    public function reportsAssign(Request $request, int $id): RedirectResponse
    {
        $request->validate(['office_id' => 'required|exists:government_offices,id']);
        $report = CitizenReport::findOrFail($id);
        $office = GovernmentOffice::findOrFail($request->office_id);
        $report->update(['assigned_office_id' => $office->id]);
        $report->transitionTo(CitizenReport::STATUS_ASSIGNED, null, $office->name);
        return back()->with('success', "Report assigned to {$office->name}.");
    }

    public function reportsStatus(Request $request, int $id): RedirectResponse
    {
        $request->validate([
            'status'      => 'required|in:' . implode(',', CitizenReport::STATUS_ORDER),
            'description' => 'nullable|string|max:500',
        ]);
        $report = CitizenReport::findOrFail($id);
        $report->transitionTo($request->status, $request->description);
        return back()->with('success', 'Status updated to: ' . $request->status);
    }

    // ─────────────────────────────────────────────────────────────────────
    // Map
    // ─────────────────────────────────────────────────────────────────────

    public function map(): View
    {
        $reports = CitizenReport::with('assignedOffice')
            ->whereNotNull('lat')
            ->whereNotNull('lng')
            ->get()
            ->map(fn($r) => [
                'id'              => $r->id,
                'referenceNumber' => $r->reference_number,
                'category'        => $r->category,
                'concern'         => $r->concern,
                'status'          => $r->status,
                'barangay'        => $r->barangay,
                'lat'             => $r->lat,
                'lng'             => $r->lng,
                'assignedOffice'  => $r->assignedOffice?->name,
            ]);

        return view('admin.map', compact('reports'));
    }

    // ─────────────────────────────────────────────────────────────────────
    // Offices
    // ─────────────────────────────────────────────────────────────────────

    public function officesIndex(): View
    {
        $offices = GovernmentOffice::where('is_active', true)->orderBy('name')->get();
        return view('admin.offices.index', compact('offices'));
    }

    public function officesStore(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'name'         => 'required|string|max:255',
            'abbreviation' => 'required|string|max:20',
            'handles'      => 'required|in:Infrastructure,Environment,Both',
            'phone'        => 'nullable|string|max:30',
            'email'        => 'nullable|email|max:191',
            'address'      => 'nullable|string|max:500',
        ]);
        GovernmentOffice::create($validated);
        return back()->with('success', 'Office created successfully.');
    }

    public function officesUpdate(Request $request, int $id): RedirectResponse
    {
        $office    = GovernmentOffice::findOrFail($id);
        $validated = $request->validate([
            'name'         => 'required|string|max:255',
            'abbreviation' => 'required|string|max:20',
            'handles'      => 'required|in:Infrastructure,Environment,Both',
            'phone'        => 'nullable|string|max:30',
            'email'        => 'nullable|email|max:191',
            'address'      => 'nullable|string|max:500',
        ]);
        $office->update($validated);
        return back()->with('success', 'Office updated.');
    }

    public function officesDestroy(int $id): RedirectResponse
    {
        GovernmentOffice::findOrFail($id)->update(['is_active' => false]);
        return back()->with('success', 'Office deactivated.');
    }

    // ─────────────────────────────────────────────────────────────────────
    // Announcements
    // ─────────────────────────────────────────────────────────────────────

    public function announcementsIndex(): View
    {
        $announcements = Announcement::orderBy('created_at', 'desc')->get();
        return view('admin.announcements.index', compact('announcements'));
    }

    public function announcementsStore(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title'        => 'required|string|max:255',
            'body'         => 'required|string',
            'is_published' => 'boolean',
        ]);
        $validated['published_at'] = now();
        Announcement::create($validated);
        return back()->with('success', 'Announcement posted.');
    }

    public function announcementsUpdate(Request $request, int $id): RedirectResponse
    {
        $announcement = Announcement::findOrFail($id);
        $validated    = $request->validate([
            'title'        => 'required|string|max:255',
            'body'         => 'required|string',
            'is_published' => 'boolean',
        ]);
        $announcement->update($validated);
        return back()->with('success', 'Announcement updated.');
    }

    public function announcementsDestroy(int $id): RedirectResponse
    {
        Announcement::findOrFail($id)->delete();
        return back()->with('success', 'Announcement deleted.');
    }
}
