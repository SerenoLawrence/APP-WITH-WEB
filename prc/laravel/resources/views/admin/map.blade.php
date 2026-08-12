@extends('admin.layout')
@section('title', 'Map View — CivilWatch Admin')
@section('page-title', 'Community Map')

@push('styles')
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<style>
    #map { height: 600px; border-radius: 12px; border: 1px solid var(--gray-200); }
    .legend { background:#fff; padding:14px 18px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,.1); font-size:12px; }
    .legend-item { display:flex; align-items:center; gap:8px; margin-bottom:6px; }
    .legend-dot { width:12px; height:12px; border-radius:50%; }
    .popup-ref { font-weight:700; color:#1A5276; }
    .popup-status { font-size:11px; font-weight:600; margin-top:3px; }
</style>
@endpush

@section('content')
<div style="display:flex;gap:10px;margin-bottom:16px;flex-wrap:wrap">
    <select id="filterStatus" class="form-control" style="width:auto">
        <option value="">All Statuses</option>
        @foreach(['Submitted','Pending Validation','Assigned to Office','In Progress','Resolved'] as $s)
        <option value="{{ $s }}">{{ $s }}</option>
        @endforeach
    </select>
    <select id="filterCategory" class="form-control" style="width:auto">
        <option value="">All Categories</option>
        <option value="Infrastructure">Infrastructure</option>
        <option value="Environment">Environment</option>
        <option value="Others">Others</option>
    </select>
</div>

<div id="map"></div>
@endsection

@push('scripts')
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
const reports = @json($reports);

const map = L.map('map').setView([6.7498, 125.3572], 13);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
}).addTo(map);

const statusColors = {
    'Submitted':          '#3B5BDB',
    'Pending Validation': '#B7770D',
    'Assigned to Office': '#1A6089',
    'In Progress':        '#E65100',
    'Resolved':           '#1E8449',
};

const categoryColors = {
    'Infrastructure': '#1565C0',
    'Environment':    '#2E7D32',
    'Others':         '#666',
};

let markers = [];

function makeMarker(r) {
    if (!r.lat || !r.lng) return null;
    const color = statusColors[r.status] || '#666';
    const icon = L.divIcon({
        className: '',
        html: `<div style="width:14px;height:14px;border-radius:50%;background:${color};border:2px solid #fff;box-shadow:0 1px 4px rgba(0,0,0,.4)"></div>`,
        iconSize: [14, 14],
        iconAnchor: [7, 7],
    });
    const marker = L.marker([r.lat, r.lng], { icon });
    marker.bindPopup(`
        <div class="popup-ref">${r.referenceNumber}</div>
        <div style="font-size:12px;margin-top:2px">${r.concern}</div>
        <div style="font-size:11px;color:#666">${r.barangay}</div>
        <div class="popup-status" style="color:${color}">${r.status}</div>
        <div style="margin-top:6px"><a href="/admin/citizen-reports/${r.id}" style="color:#1A5276;font-size:12px;font-weight:600">View Report →</a></div>
    `);
    marker._reportData = r;
    return marker;
}

function renderMarkers() {
    markers.forEach(m => map.removeLayer(m));
    markers = [];

    const filterStatus   = document.getElementById('filterStatus').value;
    const filterCategory = document.getElementById('filterCategory').value;

    reports.forEach(r => {
        if (filterStatus   && r.status   !== filterStatus)   return;
        if (filterCategory && r.category !== filterCategory) return;
        const m = makeMarker(r);
        if (m) { m.addTo(map); markers.push(m); }
    });
}

document.getElementById('filterStatus').addEventListener('change', renderMarkers);
document.getElementById('filterCategory').addEventListener('change', renderMarkers);

renderMarkers();

// Legend
const legend = L.control({ position: 'bottomright' });
legend.onAdd = () => {
    const div = L.DomUtil.create('div', 'legend');
    div.innerHTML = '<strong style="font-size:12px;font-weight:700">Status</strong><br>' +
        Object.entries(statusColors).map(([s, c]) =>
            `<div class="legend-item"><div class="legend-dot" style="background:${c}"></div>${s}</div>`
        ).join('');
    return div;
};
legend.addTo(map);
</script>
@endpush
