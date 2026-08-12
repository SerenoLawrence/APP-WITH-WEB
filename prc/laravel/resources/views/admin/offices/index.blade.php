@extends('admin.layout')
@section('title', 'Government Offices — CivilWatch Admin')
@section('page-title', 'Government Offices')

@section('content')
<div style="display:flex;justify-content:flex-end;margin-bottom:16px">
    <button class="btn btn-primary" onclick="openModal('createModal')">+ Add Office</button>
</div>

<div class="card">
    <div class="card-header"><h2>Offices ({{ $offices->count() }})</h2></div>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Abbrev</th>
                    <th>Handles</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Reports</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($offices as $office)
                <tr>
                    <td style="font-weight:600">{{ $office->name }}</td>
                    <td><span class="badge badge-assigned">{{ $office->abbreviation }}</span></td>
                    <td>
                        @if($office->handles === 'Both')
                            <span class="badge badge-infra">Infrastructure</span>
                            <span class="badge badge-env" style="margin-left:4px">Environment</span>
                        @elseif($office->handles === 'Infrastructure')
                            <span class="badge badge-infra">Infrastructure</span>
                        @else
                            <span class="badge badge-env">Environment</span>
                        @endif
                    </td>
                    <td style="font-size:12px;color:var(--gray-600)">{{ $office->phone ?? '—' }}</td>
                    <td style="font-size:12px;color:var(--gray-600)">{{ $office->email ?? '—' }}</td>
                    <td style="font-weight:600;color:var(--primary)">{{ $office->reports()->count() }}</td>
                    <td>
                        <button class="btn btn-outline btn-sm" onclick='openEdit(@json($office))'>Edit</button>
                        <form method="POST" action="{{ route('admin.offices.destroy', $office->id) }}" style="display:inline" onsubmit="return confirm('Deactivate this office?')">
                            @csrf @method('DELETE')
                            <button type="submit" class="btn btn-danger btn-sm">Deactivate</button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr><td colspan="7" style="text-align:center;color:var(--gray-400);padding:32px">No offices yet.</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>

{{-- Create Modal --}}
<div class="modal-overlay" id="createModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Add Government Office</h3>
            <button class="modal-close" onclick="closeModal('createModal')">×</button>
        </div>
        <form method="POST" action="{{ route('admin.offices.store') }}">
            @csrf
            <div class="modal-body">
                @include('admin.offices._form')
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('createModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Office</button>
            </div>
        </form>
    </div>
</div>

{{-- Edit Modal --}}
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Edit Government Office</h3>
            <button class="modal-close" onclick="closeModal('editModal')">×</button>
        </div>
        <form method="POST" id="editForm">
            @csrf @method('PUT')
            <div class="modal-body">
                @include('admin.offices._form', ['editing' => true])
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('editModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

@push('scripts')
<script>
function openModal(id) { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }

function openEdit(office) {
    const form = document.getElementById('editForm');
    form.action = `/admin/offices/${office.id}`;
    form.querySelector('[name=name]').value         = office.name;
    form.querySelector('[name=abbreviation]').value = office.abbreviation;
    form.querySelector('[name=phone]').value        = office.phone || '';
    form.querySelector('[name=email]').value        = office.email || '';
    form.querySelector('[name=address]').value      = office.address || '';
    form.querySelector('[name=handles]').value      = office.handles;
    openModal('editModal');
}
</script>
@endpush
@endsection
