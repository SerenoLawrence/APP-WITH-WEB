<?php

use App\Http\Controllers\Admin\AdminWebController;
use Illuminate\Support\Facades\Route;

// ── Root — serve the HTML/JS web admin (index.html) ───────────────────────
Route::get('/', function () {
    return response(file_get_contents(public_path('index.html')), 200)
        ->header('Content-Type', 'text/html');
});

// ── Laravel Blade Admin (kept for internal use) ────────────────────────────
Route::get('/admin/login',  [AdminWebController::class, 'showLogin'])->name('admin.login');
Route::post('/admin/login', [AdminWebController::class, 'login'])->name('admin.login.post');

Route::middleware(['auth', 'web'])->prefix('admin')->name('admin.')->group(function () {
    Route::post('/logout', [AdminWebController::class, 'logout'])->name('logout');
    Route::get('/dashboard', [AdminWebController::class, 'dashboard'])->name('dashboard');
    Route::get('/citizen-reports', [AdminWebController::class, 'reportsIndex'])->name('citizen-reports.index');
    Route::get('/citizen-reports/{id}', [AdminWebController::class, 'reportsShow'])->name('citizen-reports.show');
    Route::post('/citizen-reports/{id}/validate', [AdminWebController::class, 'reportsValidate'])->name('citizen-reports.validate');
    Route::post('/citizen-reports/{id}/assign', [AdminWebController::class, 'reportsAssign'])->name('citizen-reports.assign');
    Route::post('/citizen-reports/{id}/status', [AdminWebController::class, 'reportsStatus'])->name('citizen-reports.status');
    Route::get('/map', [AdminWebController::class, 'map'])->name('map');
    Route::get('/offices', [AdminWebController::class, 'officesIndex'])->name('offices.index');
    Route::post('/offices', [AdminWebController::class, 'officesStore'])->name('offices.store');
    Route::put('/offices/{id}', [AdminWebController::class, 'officesUpdate'])->name('offices.update');
    Route::delete('/offices/{id}', [AdminWebController::class, 'officesDestroy'])->name('offices.destroy');
    Route::get('/announcements', [AdminWebController::class, 'announcementsIndex'])->name('announcements.index');
    Route::post('/announcements', [AdminWebController::class, 'announcementsStore'])->name('announcements.store');
    Route::put('/announcements/{id}', [AdminWebController::class, 'announcementsUpdate'])->name('announcements.update');
    Route::delete('/announcements/{id}', [AdminWebController::class, 'announcementsDestroy'])->name('announcements.destroy');
});

// ── Catch-all: serve any .html file from public/ ──────────────────────────
// Handles: dashboard.html, analytics.html, offices/ceo/dashboard.html, etc.
// Must be LAST so it doesn't intercept API or admin routes above.
Route::get('{any}', function (string $any) {
    if (str_ends_with($any, '.html')) {
        $path = public_path($any);
        if (file_exists($path)) {
            return response(file_get_contents($path), 200)
                ->header('Content-Type', 'text/html');
        }
    }
    abort(404);
})->where('any', '.*');
