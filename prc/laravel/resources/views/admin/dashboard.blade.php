@extends('admin.layout')
@section('title', 'Dashboard — CivilWatch Admin')
@section('page-title', 'Dashboard')

@section('content')
<div class="stats-grid">
    <div class="stat-card">
        <div class="label">Total Reports</div>
        <div class="value">{{ $stats['total'] }}</div>
        <div class="sub">All time</div>
    </div>
    <div class="stat-card">
        <div class="label">Submitted</div>
        <div class="value" style="color:#3B5BDB">{{ $stats['submitted'] }}</div>
        <div class="sub">Awaiting review</div>
    </div>
    <div class="stat-card">
        <div class="label">Pending Validation</div>
        <div class="value" style="color:#B7770D">{{ $stats['pending_validation'] }}</div>
        <div class="sub">Under review</div>
    </div>
    <div class="stat-card">
        <div class="label">Assigned</div>
        <div class="value" style="color:#1A6089">{{ $stats['assigned'] }}</div>
        <div class="sub">Sent to office</div>
    </div>
    <div class="stat-card">
        <div class="label">In Progress</div>
        <div class="value" style="color:#E65100">{{ $stats['in_progress'] }}</div>
        <div class="sub">Being worked on</div>
    </div>
    <div class="stat-card">
        <div class="label">Resolved</div>
        <div class="value" style="color:#1E8449">{{ $stats['resolved'] }}</div>
        <div class="sub">Completed</div>
    </div>
</div>

<div style="display:grid;grid-template-columns:1fr 1fr;gap:20px">
    {{-- Recent Reports --}}
    <div class="card">
        <div class="card-header">
            <h2>Recent Citizen Reports</h2>
            <a href="{{ route('admin.citizen-reports.index') }}" class="btn btn-outline btn-sm">View All</a>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Reference</th>
                        <th>Concern</th>
                        <th>Barangay</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($recentReports as $report)
                    <tr>
                        <td><a href="{{ route('admin.citizen-reports.show', $report->id) }}" style="color:var(--primary);font-weight:600;text-decoration:none">{{ $report->reference_number }}</a></td>
                        <td>{{ $report->concern }}</td>
                        <td>{{ $report->barangay }}</td>
                        <td>@include('admin.partials.status-badge', ['status' => $report->status])</td>
                    </tr>
                    @empty
                    <tr><td colspan="4" style="text-align:center;color:var(--gray-400);padding:24px">No reports yet.</td></tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

    {{-- Latest Announcements --}}
    <div class="card">
        <div class="card-header">
            <h2>Announcements</h2>
            <a href="{{ route('admin.announcements.index') }}" class="btn btn-outline btn-sm">Manage</a>
        </div>
        <div class="card-body" style="padding-top:12px">
            @forelse($announcements as $a)
            <div style="padding:12px 0;border-bottom:1px solid var(--gray-100)">
                <div style="font-size:13px;font-weight:600;color:var(--gray-800)">{{ $a->title }}</div>
                <div style="font-size:12px;color:var(--gray-400);margin-top:3px">{{ ($a->published_at ?? $a->created_at)?->format('M d, Y') }}</div>
            </div>
            @empty
            <p style="font-size:13px;color:var(--gray-400);text-align:center;padding:20px 0">No announcements yet.</p>
            @endforelse
        </div>
    </div>
</div>
@endsection
