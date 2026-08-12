<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'CivilWatch Admin')</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --primary: #1A5276;
            --primary-light: #EBF5FB;
            --accent: #2E86C1;
            --success: #1E8449;
            --success-bg: #EAFAF1;
            --warning: #B7770D;
            --warning-bg: #FEF9E7;
            --danger: #C0392B;
            --danger-bg: #FDEDEC;
            --info: #1A6089;
            --info-bg: #EBF5FB;
            --gray-50: #F8FAFC;
            --gray-100: #F1F5F9;
            --gray-200: #E2E8F0;
            --gray-400: #94A3B8;
            --gray-600: #475569;
            --gray-800: #1E293B;
            --white: #FFFFFF;
            --sidebar-w: 250px;
            --radius: 12px;
        }
        body { font-family: 'Inter', sans-serif; background: var(--gray-50); color: var(--gray-800); display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar { width: var(--sidebar-w); background: var(--primary); position: fixed; top:0; left:0; height:100vh; display:flex; flex-direction:column; z-index:100; }
        .sidebar-brand { padding: 24px 20px 20px; border-bottom: 1px solid rgba(255,255,255,0.12); }
        .sidebar-brand h1 { color:#fff; font-size:18px; font-weight:800; letter-spacing:.5px; }
        .sidebar-brand p  { color:rgba(255,255,255,.6); font-size:11px; margin-top:2px; }
        .sidebar-nav { flex:1; overflow-y:auto; padding:16px 0; }
        .nav-section { padding: 6px 20px 4px; font-size:10px; font-weight:700; color:rgba(255,255,255,.4); letter-spacing:1px; text-transform:uppercase; }
        .nav-link { display:flex; align-items:center; gap:10px; padding:10px 20px; color:rgba(255,255,255,.75); text-decoration:none; font-size:14px; font-weight:500; transition:.15s; }
        .nav-link:hover, .nav-link.active { background:rgba(255,255,255,.12); color:#fff; }
        .nav-link svg { width:18px; height:18px; flex-shrink:0; }
        .sidebar-footer { padding:16px 20px; border-top:1px solid rgba(255,255,255,.12); }
        .logout-btn { display:flex; align-items:center; gap:8px; color:rgba(255,255,255,.6); font-size:13px; text-decoration:none; cursor:pointer; background:none; border:none; width:100%; }
        .logout-btn:hover { color:#fff; }

        /* ── Main ── */
        .main { margin-left: var(--sidebar-w); flex:1; display:flex; flex-direction:column; min-height:100vh; }
        .topbar { background:var(--white); border-bottom:1px solid var(--gray-200); padding:0 28px; height:60px; display:flex; align-items:center; justify-content:space-between; position:sticky; top:0; z-index:50; }
        .topbar-title { font-size:16px; font-weight:700; color:var(--gray-800); }
        .topbar-user { display:flex; align-items:center; gap:10px; font-size:13px; color:var(--gray-600); }
        .avatar { width:34px; height:34px; border-radius:50%; background:var(--primary); color:#fff; display:flex; align-items:center; justify-content:center; font-size:13px; font-weight:700; }
        .content { padding:28px; flex:1; }

        /* ── Cards ── */
        .card { background:var(--white); border-radius:var(--radius); border:1px solid var(--gray-200); }
        .card-header { padding:18px 22px; border-bottom:1px solid var(--gray-200); display:flex; align-items:center; justify-content:space-between; }
        .card-header h2 { font-size:15px; font-weight:700; }
        .card-body { padding:22px; }

        /* ── Stat cards ── */
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:16px; margin-bottom:24px; }
        .stat-card { background:var(--white); border-radius:var(--radius); border:1px solid var(--gray-200); padding:18px; }
        .stat-card .label { font-size:12px; color:var(--gray-400); font-weight:500; margin-bottom:6px; }
        .stat-card .value { font-size:28px; font-weight:800; color:var(--gray-800); }
        .stat-card .sub   { font-size:11px; color:var(--gray-400); margin-top:2px; }

        /* ── Table ── */
        .table-wrap { overflow-x:auto; }
        table { width:100%; border-collapse:collapse; font-size:13px; }
        th { background:var(--gray-50); color:var(--gray-600); font-weight:600; font-size:11px; text-transform:uppercase; letter-spacing:.5px; padding:10px 14px; text-align:left; border-bottom:1px solid var(--gray-200); white-space:nowrap; }
        td { padding:12px 14px; border-bottom:1px solid var(--gray-100); vertical-align:middle; }
        tr:last-child td { border-bottom:none; }
        tr:hover td { background:var(--gray-50); }

        /* ── Badges ── */
        .badge { display:inline-flex; align-items:center; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:600; white-space:nowrap; }
        .badge-submitted   { background:#F0F4FF; color:#3B5BDB; }
        .badge-pending     { background:var(--warning-bg); color:var(--warning); }
        .badge-assigned    { background:var(--info-bg); color:var(--info); }
        .badge-inprogress  { background:#FFF3E0; color:#E65100; }
        .badge-resolved    { background:var(--success-bg); color:var(--success); }
        .badge-infra       { background:#E8F4FD; color:#1565C0; }
        .badge-env         { background:#E8F5E9; color:#2E7D32; }
        .badge-others      { background:var(--gray-100); color:var(--gray-600); }

        /* ── Buttons ── */
        .btn { display:inline-flex; align-items:center; gap:6px; padding:8px 16px; border-radius:8px; font-size:13px; font-weight:600; border:none; cursor:pointer; text-decoration:none; transition:.15s; }
        .btn-primary { background:var(--primary); color:#fff; }
        .btn-primary:hover { background:var(--accent); }
        .btn-outline { background:transparent; color:var(--gray-600); border:1px solid var(--gray-200); }
        .btn-outline:hover { background:var(--gray-100); }
        .btn-success { background:var(--success); color:#fff; }
        .btn-danger  { background:var(--danger); color:#fff; }
        .btn-sm { padding:5px 12px; font-size:12px; }

        /* ── Form ── */
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:12px; font-weight:600; color:var(--gray-600); margin-bottom:6px; }
        .form-control { width:100%; padding:9px 12px; border:1px solid var(--gray-200); border-radius:8px; font-size:13px; font-family:inherit; color:var(--gray-800); background:var(--white); }
        .form-control:focus { outline:none; border-color:var(--primary); box-shadow:0 0 0 3px rgba(26,82,118,.1); }
        select.form-control { cursor:pointer; }
        textarea.form-control { resize:vertical; min-height:100px; }

        /* ── Modal ── */
        .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.45); z-index:200; align-items:center; justify-content:center; }
        .modal-overlay.open { display:flex; }
        .modal { background:var(--white); border-radius:16px; width:90%; max-width:520px; max-height:90vh; overflow-y:auto; box-shadow:0 20px 60px rgba(0,0,0,.2); }
        .modal-header { padding:20px 24px 16px; border-bottom:1px solid var(--gray-200); display:flex; align-items:center; justify-content:space-between; }
        .modal-header h3 { font-size:16px; font-weight:700; }
        .modal-close { background:none; border:none; cursor:pointer; color:var(--gray-400); font-size:20px; line-height:1; }
        .modal-body { padding:24px; }
        .modal-footer { padding:16px 24px; border-top:1px solid var(--gray-200); display:flex; gap:10px; justify-content:flex-end; }

        /* ── Filter bar ── */
        .filter-bar { display:flex; gap:10px; flex-wrap:wrap; margin-bottom:20px; }
        .filter-bar select, .filter-bar input { padding:8px 12px; border:1px solid var(--gray-200); border-radius:8px; font-size:13px; font-family:inherit; color:var(--gray-800); background:var(--white); }
        .filter-bar select:focus, .filter-bar input:focus { outline:none; border-color:var(--primary); }

        /* ── Alert ── */
        .alert { padding:12px 16px; border-radius:8px; font-size:13px; margin-bottom:16px; }
        .alert-success { background:var(--success-bg); color:var(--success); border:1px solid #A9DFBF; }
        .alert-error   { background:var(--danger-bg);  color:var(--danger);  border:1px solid #F1948A; }

        /* ── Timeline ── */
        .timeline { position:relative; padding-left:24px; }
        .timeline::before { content:''; position:absolute; left:8px; top:0; bottom:0; width:2px; background:var(--gray-200); }
        .tl-item { position:relative; margin-bottom:16px; }
        .tl-dot { position:absolute; left:-20px; top:4px; width:14px; height:14px; border-radius:50%; background:var(--primary); border:2px solid var(--white); box-shadow:0 0 0 2px var(--primary); }
        .tl-title { font-size:13px; font-weight:700; color:var(--gray-800); }
        .tl-desc  { font-size:12px; color:var(--gray-600); margin-top:2px; }
        .tl-time  { font-size:11px; color:var(--gray-400); margin-top:3px; }

        @media (max-width:768px) {
            .sidebar { transform:translateX(-100%); }
            .main { margin-left:0; }
        }
    </style>
    @stack('styles')
</head>
<body>

{{-- ── Sidebar ── --}}
<aside class="sidebar">
    <div class="sidebar-brand">
        <h1>CIVILWATCH</h1>
        <p>Admin Panel — Digos City</p>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">Main</div>
        <a href="{{ route('admin.dashboard') }}" class="nav-link {{ request()->routeIs('admin.dashboard') ? 'active' : '' }}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
        </a>

        <div class="nav-section">Citizen Reports</div>
        <a href="{{ route('admin.citizen-reports.index') }}" class="nav-link {{ request()->routeIs('admin.citizen-reports.*') ? 'active' : '' }}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
            All Reports
        </a>
        <a href="{{ route('admin.map') }}" class="nav-link {{ request()->routeIs('admin.map') ? 'active' : '' }}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/><line x1="8" y1="2" x2="8" y2="18"/><line x1="16" y1="6" x2="16" y2="22"/></svg>
            Map View
        </a>

        <div class="nav-section">Manage</div>
        <a href="{{ route('admin.offices.index') }}" class="nav-link {{ request()->routeIs('admin.offices.*') ? 'active' : '' }}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            Offices
        </a>
        <a href="{{ route('admin.announcements.index') }}" class="nav-link {{ request()->routeIs('admin.announcements.*') ? 'active' : '' }}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 17H2a3 3 0 000 6h20v-6zM6 17V7a6 6 0 0112 0v10"/></svg>
            Announcements
        </a>
    </nav>
    <div class="sidebar-footer">
        <form action="{{ route('admin.logout') }}" method="POST">
            @csrf
            <button type="submit" class="logout-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                Logout
            </button>
        </form>
    </div>
</aside>

{{-- ── Main ── --}}
<div class="main">
    <header class="topbar">
        <span class="topbar-title">@yield('page-title', 'Dashboard')</span>
        <div class="topbar-user">
            <span>{{ auth()->user()->name }}</span>
            <div class="avatar">{{ strtoupper(substr(auth()->user()->name, 0, 1)) }}</div>
        </div>
    </header>
    <main class="content">
        @if(session('success'))
            <div class="alert alert-success">{{ session('success') }}</div>
        @endif
        @if(session('error'))
            <div class="alert alert-error">{{ session('error') }}</div>
        @endif
        @yield('content')
    </main>
</div>

@stack('scripts')
</body>
</html>
