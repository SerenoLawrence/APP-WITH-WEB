<?php

namespace App\Http\Controllers;

use App\Models\Report;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AnalyticsController extends Controller
{
    // ──────────────────────────────────────────────────────────
    // GET /api/analytics/summary
    // Top-level stat cards — used by all dashboards
    // Super admin sees all; CEO/CENRO see their office scope only
    // ──────────────────────────────────────────────────────────
    public function summary(Request $request): JsonResponse
    {
        $query = $this->scopedQuery($request);

        $total      = (clone $query)->count();
        $pending    = (clone $query)->where('status', 'pending')->count();
        $submitted  = (clone $query)->where('status', 'submitted')->count();
        $assigned   = (clone $query)->where('status', 'assigned')->count();
        $inProgress = (clone $query)->where('status', 'in_progress')->count();
        $resolved   = (clone $query)->where('status', 'resolved')->count();

        return response()->json([
            'success' => true,
            'data'    => [
                'total_reports'      => $total,
                'pending_validation' => $pending + $submitted,
                'assigned'           => $assigned,
                'in_progress'        => $inProgress,
                'resolved'           => $resolved,
            ],
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/analytics/status-distribution
    // Doughnut chart — count per status
    // ──────────────────────────────────────────────────────────
    public function statusDistribution(Request $request): JsonResponse
    {
        $query = $this->scopedQuery($request);

        $rows = (clone $query)
            ->select('status', DB::raw('COUNT(*) as count'))
            ->groupBy('status')
            ->get()
            ->keyBy('status');

        $statuses = ['submitted', 'pending', 'assigned', 'in_progress', 'for_resolution', 'resolved'];
        $labels   = [];
        $data     = [];

        foreach ($statuses as $s) {
            $labels[] = $this->formatLabel($s);
            $data[]   = $rows->get($s)?->count ?? 0;
        }

        $total = array_sum($data);
        $percentages = array_map(
            fn($n) => $total > 0 ? round(($n / $total) * 100, 1) . '%' : '0%',
            $data
        );

        return response()->json([
            'success' => true,
            'data'    => compact('labels', 'data', 'percentages'),
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/analytics/by-category
    // Doughnut chart — Infrastructure vs Environmental
    // ──────────────────────────────────────────────────────────
    public function byCategory(Request $request): JsonResponse
    {
        $query = $this->scopedQuery($request);

        $rows = (clone $query)
            ->select('category', DB::raw('COUNT(*) as count'))
            ->groupBy('category')
            ->get()
            ->keyBy('category');

        $categories = ['infrastructure', 'environmental', 'public_safety', 'sanitation', 'other'];
        $labels     = [];
        $data       = [];

        foreach ($categories as $c) {
            $count = $rows->get($c)?->count ?? 0;
            if ($count > 0) {
                $labels[] = ucfirst(str_replace('_', ' ', $c));
                $data[]   = $count;
            }
        }

        $total = array_sum($data);
        $percentages = array_map(
            fn($n) => $total > 0 ? round(($n / $total) * 100, 1) . '%' : '0%',
            $data
        );

        return response()->json([
            'success' => true,
            'data'    => compact('labels', 'data', 'percentages'),
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/analytics/top-issues
    // Bar chart — top issue titles by volume
    // ──────────────────────────────────────────────────────────
    public function topIssues(Request $request): JsonResponse
    {
        $query = $this->scopedQuery($request);

        $rows = (clone $query)
            ->select('title', DB::raw('COUNT(*) as count'))
            ->groupBy('title')
            ->orderByDesc('count')
            ->limit(10)
            ->get();

        return response()->json([
            'success' => true,
            'data'    => [
                'labels' => $rows->pluck('title')->toArray(),
                'data'   => $rows->pluck('count')->toArray(),
            ],
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/analytics/top-barangays
    // Bar chart — barangays with the most reports
    // ──────────────────────────────────────────────────────────
    public function topBarangays(Request $request): JsonResponse
    {
        $query = $this->scopedQuery($request);

        $rows = (clone $query)
            ->select('barangay', DB::raw('COUNT(*) as count'))
            ->whereNotNull('barangay')
            ->groupBy('barangay')
            ->orderByDesc('count')
            ->limit(10)
            ->get();

        return response()->json([
            'success' => true,
            'data'    => [
                'labels' => $rows->pluck('barangay')->toArray(),
                'data'   => $rows->pluck('count')->toArray(),
            ],
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/analytics/weekly-trend
    // Line chart — reports submitted per week (last 5 weeks)
    // ──────────────────────────────────────────────────────────
    public function weeklyTrend(Request $request): JsonResponse
    {
        $query  = $this->scopedQuery($request);
        $weeks  = 5;
        $labels = [];
        $data   = [];

        for ($i = $weeks - 1; $i >= 0; $i--) {
            $start = now()->startOfWeek()->subWeeks($i);
            $end   = (clone $start)->endOfWeek();

            $count = (clone $query)
                ->whereBetween('created_at', [$start, $end])
                ->count();

            $labels[] = $start->format('M d') . '–' . $end->format('M d');
            $data[]   = $count;
        }

        return response()->json([
            'success' => true,
            'data'    => compact('labels', 'data'),
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/analytics/monthly-trend
    // Line chart — reports submitted per month (last 6 months)
    // ──────────────────────────────────────────────────────────
    public function monthlyTrend(Request $request): JsonResponse
    {
        $query  = $this->scopedQuery($request);
        $months = 6;
        $labels = [];
        $data   = [];

        for ($i = $months - 1; $i >= 0; $i--) {
            $month = now()->startOfMonth()->subMonths($i);

            $count = (clone $query)
                ->whereYear('created_at', $month->year)
                ->whereMonth('created_at', $month->month)
                ->count();

            $labels[] = $month->format('M Y');
            $data[]   = $count;
        }

        return response()->json([
            'success' => true,
            'data'    => compact('labels', 'data'),
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/analytics/full
    // All chart data in one request — used by Analytics pages
    // ──────────────────────────────────────────────────────────
    public function full(Request $request): JsonResponse
    {
        $summaryResp     = $this->summary($request);
        $statusResp      = $this->statusDistribution($request);
        $categoryResp    = $this->byCategory($request);
        $topIssuesResp   = $this->topIssues($request);
        $topBarangaysResp = $this->topBarangays($request);
        $weeklyResp      = $this->weeklyTrend($request);
        $monthlyResp     = $this->monthlyTrend($request);

        return response()->json([
            'success' => true,
            'data'    => [
                'summary'             => json_decode($summaryResp->getContent(), true)['data'],
                'status_distribution' => json_decode($statusResp->getContent(), true)['data'],
                'by_category'         => json_decode($categoryResp->getContent(), true)['data'],
                'top_issues'          => json_decode($topIssuesResp->getContent(), true)['data'],
                'top_barangays'       => json_decode($topBarangaysResp->getContent(), true)['data'],
                'weekly_trend'        => json_decode($weeklyResp->getContent(), true)['data'],
                'monthly_trend'       => json_decode($monthlyResp->getContent(), true)['data'],
            ],
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // Private helpers
    // ──────────────────────────────────────────────────────────

    /**
     * Return a base Report query already scoped to the user's role.
     * Super admin → all reports
     * CEO         → only CEO-assigned reports
     * CENRO       → only CENRO-assigned reports
     */
    private function scopedQuery(Request $request)
    {
        $user  = $request->user();
        $query = Report::query();

        if ($user->role === 'ceo') {
            $query->where('assigned_to_office', 'CEO');
        } elseif ($user->role === 'cenro') {
            $query->where('assigned_to_office', 'CENRO');
        }

        return $query;
    }

    /** Convert snake_case status to a human-readable label */
    private function formatLabel(string $status): string
    {
        return match ($status) {
            'submitted'      => 'Submitted',
            'pending'        => 'Pending Validation',
            'assigned'       => 'Assigned',
            'in_progress'    => 'In Progress',
            'for_resolution' => 'For Resolution',
            'resolved'       => 'Resolved',
            default          => ucfirst(str_replace('_', ' ', $status)),
        };
    }
}
