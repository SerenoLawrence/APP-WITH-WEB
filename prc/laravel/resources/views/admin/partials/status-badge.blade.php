@php
$map = [
    'Submitted'          => 'badge-submitted',
    'Pending Validation' => 'badge-pending',
    'Assigned to Office' => 'badge-assigned',
    'In Progress'        => 'badge-inprogress',
    'Resolved'           => 'badge-resolved',
];
$cls = $map[$status] ?? 'badge-submitted';
@endphp
<span class="badge {{ $cls }}">{{ $status }}</span>
