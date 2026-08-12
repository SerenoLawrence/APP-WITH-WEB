<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CivilWatch — Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #EBF5FB; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .card { background: #fff; border-radius: 16px; padding: 40px 36px; width: 100%; max-width: 400px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); }
        .brand { text-align: center; margin-bottom: 32px; }
        .brand h1 { font-size: 22px; font-weight: 800; color: #1A5276; letter-spacing: .5px; }
        .brand p  { font-size: 13px; color: #7F8C8D; margin-top: 4px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; color: #555; margin-bottom: 6px; }
        .form-group input { width: 100%; padding: 11px 14px; border: 1px solid #ddd; border-radius: 10px; font-size: 14px; font-family: inherit; }
        .form-group input:focus { outline: none; border-color: #1A5276; box-shadow: 0 0 0 3px rgba(26,82,118,.1); }
        .btn { width: 100%; padding: 12px; background: #1A5276; color: #fff; border: none; border-radius: 10px; font-size: 15px; font-weight: 700; cursor: pointer; font-family: inherit; margin-top: 4px; }
        .btn:hover { background: #2E86C1; }
        .error { background: #FDEDEC; color: #C0392B; border: 1px solid #F1948A; border-radius: 8px; padding: 10px 14px; font-size: 13px; margin-bottom: 16px; }
    </style>
</head>
<body>
    <div class="card">
        <div class="brand">
            <h1>CIVILWATCH</h1>
            <p>Admin Panel — Digos City, Davao del Sur</p>
        </div>

        @if($errors->any())
            <div class="error">{{ $errors->first() }}</div>
        @endif

        <form method="POST" action="{{ route('admin.login.post') }}">
            @csrf
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" value="{{ old('email') }}" required autofocus placeholder="admin@civilwatch.ph">
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required placeholder="••••••••">
            </div>
            <button type="submit" class="btn">Sign In</button>
        </form>
    </div>
</body>
</html>
