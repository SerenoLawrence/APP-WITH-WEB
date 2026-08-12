@extends('admin.layout')
@section('title', $report->reference_number . ' — CivilWatch Admin')
@section('page-title', $report->reference_number)

@section('content')
<div style="display:grid;grid-template-columns:1fr 340px;gap:20px;align-items:start">

    {{-- Left: Report Details --}}
    <div style="display:flex;flex-direction:column;gap:20px">

        {{-- Summary --}}
        <div class="card">
            <div class="card-header">
                <h2>Report Details</h2>
                @include('admin.partials.status-badge', ['status' => $report->status])
            </div>
            <div class="card-body">
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
                    <div>
                        <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:4px">CATEGORY</div>
                        <div style="font-size:14px;font-weight:600">{{ $report->category }}</div>
                    </div>
                    <div>
                        <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:4px">CONCERN</div>
                        <div style="font-size:14px;font-weight:600">{{ $report->concern }}</div>
                    </div>
                    <div>
                        <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:4px">BARANGAY</div>
                        <div style="font-size:14px">{{ $report->barangay }}, {{ $report->city }}</div>
                    </div>
                    <div>
                        <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:4px">SEVERITY</div>
                        @php $sevColor = ['Minor'=>'#1E8449','Moderate'=>'#B7770D','Severe'=>'#C0392B'][$report->severity] ?? '#666'; @endphp
                        <div style="font-size:14px;font-weight:700;color:{{ $sevColor }}">{{ $report->severity }}</div>
                    </div>
                    @if($report->street || $report->purok)
                    <div>
                        <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:4px">STREET / PUROK</div>
                        <div style="font-size:14px">{{ implode(', ', array_filter([$report->street, $report->purok])) }}</div>
                    </div>
                    @endif
                    @if($report->landmark)
                    <div>
                        <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:4px">LANDMARK</div>
                        <div style="font-size:14px">{{ $report->landmark }}</div>
                    </div>
                    @endif
                    <div>
                        <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:4px">SUBMITTED BY</div>
                        <div style="font-size:14px">{{ $report->citizen->full_name ?? 'Unknown' }}</div>
                    </div>
                    <div>
                        <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:4px">SUBMITTED AT</div>
                        <div style="font-size:14px">{{ $report->created_at->format('M d, Y h:i A') }}</div>
                    </div>
                </div>
                @if($report->description)
                <div style="margin-top:16px;padding-top:16px;border-top:1px solid var(--gray-200)">
                    <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:6px">DESCRIPTION</div>
                    <div style="font-size:13px;line-height:1.6;color:var(--gray-600)">{{ $report->description }}</div>
                </div>
                @endif
                @if($report->photo_url)
                <div style="margin-top:16px;padding-top:16px;border-top:1px solid var(--gray-200)">
                    <div style="font-size:11px;color:var(--gray-400);font-weight:600;margin-bottom:8px">PHOTO</div>
                    <img src="{{ $report->photo_url }}" alt="Report photo" style="max-width:100%;border-radius:10px;max-height:300px;object-fit:cover">
                </div>
                @endif
            </div>
        </div>

        {{-- Activity Log --}}
        <div class="card">
            <div class="card-header"><h2>Activity Log</h2></div>
            <div class="card-body">
                @if($report->activities->isEmpty())
                    <p style="color:var(--gray-400);font-size:13px">No activity yet.</p>
                @else
                <div class="timeline">
                    @foreach($report->activities as $activity)
                    <div class="tl-item">
                        <div class="tl-dot"></div>
                        <div class="tl-title">{{ $activity->title }}</div>
                        <div class="tl-desc">{{ $activity->description }}</div>
                        <div class="tl-time">{{ $activity->created_at->format('M d, Y h:i A') }}</div>
                    </div>
                    @endforeach
                </div>
                @endif
            </div>
        </div>
    </div>

    {{-- Right: Actions --}}
    <div style="display:flex;flex-direction:column;gap:16px">

        {{-- Assigned Office --}}
        <div class="card">
            <div class="card-header"><h2>Assigned Office</h2></div>
            <div class="card-body">
                @if($report->assignedOffice)
                    <div style="font-weight:700;font-size:14px">{{ $report->assignedOffice->name }}</div>
                    <div style="font-size:12px;color:var(--gray-400);margin-top:4px">{{ $report->assignedOffice->abbreviation }}</div>
                    @if($report->assignedOffice->phone)
                    <div style="font-size:12px;color:var(--gray-600);margin-top:4px">{{ $report->assignedOffice->phone }}</div>
                    @endif
                @else
                    <p style="font-size:13px;color:var(--gray-400)">Not yet assigned.</p>
                @endif
            </div>
        </div>

        {{-- Validate --}}
        @if(in_array($report->status, ['Submitted', 'Pending Validation']))
        <div class="card">
            <div class="card-header"><h2>Validate Report</h2></div>
            <div class="card-body">
                <p style="font-size:12px;color:var(--gray-600);margin-bottom:12px">Validating will make this report visible on the community map.</p>
                <form method="POST" action="{{ route('admin.citizen-reports.validate', $report->id) }}">
                    @csrf
                    <button type="submit" class="btn btn-success" style="width:100%">✓ Validate Report</button>
                </form>
            </div>
        </div>
        @endif

        {{-- Assign to Office --}}
        @if(!in_array($report->status, ['Resolved']))
        <div class="card">
            <div class="card-header"><h2>Assign to Office</h2></div>
            <div class="card-body">
                <form method="POST" action="{{ route('admin.citizen-reports.assign', $report->id) }}">
                    @csrf
                    <div class="form-group">
                        <label>Select Office</label>
                        <select name="office_id" class="form-control" required>
                            <option value="">— Choose office —</option>
                            @foreach($offices as $office)
                                <option value="{{ $office->id }}" {{ $report->assigned_office_id === $office->id ? 'selected' : '' }}>
                                    {{ $office->abbreviation }} — {{ $office->name }}
                                </option>
                            @endforeach
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%">Assign</button>
                </form>
            </div>
        </div>
        @endif

        {{-- Update Status --}}
        <div class="card">
            <div class="card-header"><h2>Update Status</h2></div>
            <div class="card-body">
                <form method="POST" action="{{ route('admin.citizen-reports.status', $report->id) }}">
                    @csrf
                    <div class="form-group">
                        <label>New Status</label>
                        <select name="status" class="form-control" required>
                            @foreach(['Submitted','Pending Validation','Assigned to Office','In Progress','Resolved'] as $s)
                                <option value="{{ $s }}" {{ $report->status === $s ? 'selected' : '' }}>{{ $s }}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Note (optional)</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Add a note..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%">Update Status</button>
                </form>
            </div>
        </div>

        {{-- Back --}}
        <a href="{{ route('admin.citizen-reports.index') }}" class="btn btn-outline" style="justify-content:center">← Back to Reports</a>
    </div>
</div>
@endsection
