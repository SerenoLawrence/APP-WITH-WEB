@extends('admin.layout')
@section('title', 'Announcements — CivilWatch Admin')
@section('page-title', 'Announcements')

@section('content')
<div style="display:flex;justify-content:flex-end;margin-bottom:16px">
    <button class="btn btn-primary" onclick="openModal('createModal')">+ Post Announcement</button>
</div>

<div class="card">
    <div class="card-header"><h2>Announcements ({{ $announcements->count() }})</h2></div>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Body</th>
                    <th>Published</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($announcements as $a)
                <tr>
                    <td style="font-weight:600;max-width:200px">{{ $a->title }}</td>
                    <td style="max-width:300px;color:var(--gray-600);font-size:12px">{{ Str::limit($a->body, 80) }}</td>
                    <td>
                        @if($a->is_published)
                            <span class="badge" style="background:var(--success-bg);color:var(--success)">Published</span>
                        @else
                            <span class="badge" style="background:var(--gray-100);color:var(--gray-600)">Draft</span>
                        @endif
                    </td>
                    <td style="font-size:12px;color:var(--gray-400)">{{ ($a->published_at ?? $a->created_at)?->format('M d, Y') }}</td>
                    <td>
                        <button class="btn btn-outline btn-sm" onclick='openEdit(@json($a))'>Edit</button>
                        <form method="POST" action="{{ route('admin.announcements.destroy', $a->id) }}" style="display:inline" onsubmit="return confirm('Delete this announcement?')">
                            @csrf @method('DELETE')
                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr><td colspan="5" style="text-align:center;color:var(--gray-400);padding:32px">No announcements yet.</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>

{{-- Create Modal --}}
<div class="modal-overlay" id="createModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Post Announcement</h3>
            <button class="modal-close" onclick="closeModal('createModal')">×</button>
        </div>
        <form method="POST" action="{{ route('admin.announcements.store') }}">
            @csrf
            <div class="modal-body">
                @include('admin.announcements._form')
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('createModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Post</button>
            </div>
        </form>
    </div>
</div>

{{-- Edit Modal --}}
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Edit Announcement</h3>
            <button class="modal-close" onclick="closeModal('editModal')">×</button>
        </div>
        <form method="POST" id="editForm">
            @csrf @method('PUT')
            <div class="modal-body">
                @include('admin.announcements._form', ['editing' => true])
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

function openEdit(a) {
    const form = document.getElementById('editForm');
    form.action = `/admin/announcements/${a.id}`;
    form.querySelector('[name=title]').value        = a.title;
    form.querySelector('[name=body]').value         = a.body;
    form.querySelector('[name=is_published]').value = a.is_published ? '1' : '0';
    openModal('editModal');
}
</script>
@endpush
@endsection
