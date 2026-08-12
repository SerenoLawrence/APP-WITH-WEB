@extends('admin.layout')
@section('title', 'Citizen Reports — CivilWatch Admin')
@section('page-title', 'Citizen Reports')

@section('content')
<div class="filter-bar">
    <form method="GET" style="display:contents">
        <select name="status" onchange="this.form.submit()">
            <option value="">All Statuses</option>
            @foreach(['Submitted','Pending Validation','Assigned to Office','In Progress','Resolved'] as $s)
                <option value="{{ $s }}" {{ request('status') === $s ? 'selected' : '' }}>{{ $s }}</option>
            @endforeach
        </select>
        <select name="category" onchange="this.form.submit()">
            <option value="">All Categories</option>
            @foreach(['Infrastructure','Environment','Others'] as $c)
                <option value="{{ $c }}" {{ request('category') === $c ? 'selected' : '' }}>{{ $c }}</option>
            @endforeach
        </select>
        <select name="barangay" onchange="this.form.submit()">
            <option value="">All Barangays</option>
            @foreach(['Aplaya','Badiang','Balabag','Binaton','Cogon','Colorado','Dawis','Dulangan','Goma','Igpit','Kapatagan','Kiagdan','Matti','New Visayas','Rizal','San Jose','San Miguel','Soong','Tres de Mayo','Zone 1','Zone 2','Zone 3'] as $b)
                <option value="{{ $b }}" {{ request('barangay') === $b ? 'selected' : '' }}>{{ $b }}</option>
            @endforeach
        </select>
        <input type="text" name="search" value="{{ request('search') }}" placeholder="Search reference, concern..." style="flex:1;min-width:200px">
        <button type="submit" class="btn btn-primary btn-sm">Search</button>
        @if(request()->hasAny(['status','category','barangay','search']))
            <a href="{{ route('admin.citizen-reports.index') }}" class="btn btn-outline btn-sm">Clear</a>
        @endif
    </form>
</div>

<div class="card">
    <div class="card-header">
        <h2>Reports ({{ $reports->total() }})</h2>
        <a href="{{ route('admin.map') }}" class="btn btn-outline btn-sm">View on Map</a>
    </div>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Reference</th>
                    <th>Category</th>
                    <th>Concern</th>
                    <th>Barangay</th>
                    <th>Severity</th>
                    <th>Status</th>
                    <th>Submitted</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($reports as $report)
                <tr>
                    <td style="font-weight:600;color:var(--primary)">{{ $report->reference_number }}</td>
                    <td>
                        @if($report->category === 'Infrastructure')
                            <span class="badge badge-infra">{{ $report->category }}</span>
                        @elseif($report->category === 'Environment')
                            <span class="badge badge-env">{{ $report->category }}</span>
                        @else
                            <span class="badge badge-others">{{ $report->category }}</span>
                        @endif
                    </td>
                    <td>{{ $report->concern }}</td>
                    <td>{{ $report->barangay }}</td>
                    <td>
                        @php $sevColor = ['Minor'=>'#1E8449','Moderate'=>'#B7770D','Severe'=>'#C0392B'][$report->severity] ?? '#666'; @endphp
                        <span style="color:{{ $sevColor }};font-weight:600;font-size:12px">{{ $report->severity }}</span>
                    </td>
                    <td>@include('admin.partials.status-badge', ['status' => $report->status])</td>
                    <td style="color:var(--gray-400);font-size:12px">{{ $report->created_at->format('M d, Y') }}</td>
                    <td>
                        <a href="{{ route('admin.citizen-reports.show', $report->id) }}" class="btn btn-outline btn-sm">View</a>
                    </td>
                </tr>
                @empty
                <tr><td colspan="8" style="text-align:center;color:var(--gray-400);padding:32px">No reports found.</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>
    @if($reports->hasPages())
    <div style="padding:16px 22px;border-top:1px solid var(--gray-200)">
        {{ $reports->withQueryString()->links() }}
    </div>
    @endif
</div>
@endsection
