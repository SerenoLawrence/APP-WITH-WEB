<?php

use App\Http\Controllers\Admin\AdminWebController;
use Illuminate\Support\Facades\Route;

// ── Root redirect ──────────────────────────────────────────────────────────
Route::get('/', fn() => redirect()->route('admin.login'));

// ── Admin Auth (public) ────────────────────────────────────────────────────
Route::get('/admin/login',   [AdminWebController::class, 'showLogin'])->name('admin.login');
Route::post('/admin/login',  [AdminWebController::class, 'login'])->name('admin.login.post');

// ── Admin Panel (requires web session auth) ────────────────────────────────
Route::middleware(['auth', 'web'])->prefix('admin')->name('admin.')->group(function () {

    Route::post('/logout', [AdminWebController::class, 'logout'])->name('logout');

    // Dashboard
    Route::get('/dashboard', [AdminWebController::class, 'dashboard'])->name('dashboard');

    // Citizen reports
    Route::get('/citizen-reports',                    [AdminWebController::class, 'reportsIndex'])->name('citizen-reports.index');
    Route::get('/citizen-reports/{id}',               [AdminWebController::class, 'reportsShow'])->name('citizen-reports.show');
    Route::post('/citizen-reports/{id}/validate',     [AdminWebController::class, 'reportsValidate'])->name('citizen-reports.validate');
    Route::post('/citizen-reports/{id}/assign',       [AdminWebController::class, 'reportsAssign'])->name('citizen-reports.assign');
    Route::post('/citizen-reports/{id}/status',       [AdminWebController::class, 'reportsStatus'])->name('citizen-reports.status');

    // Map
    Route::get('/map', [AdminWebController::class, 'map'])->name('map');

    // Government offices
    Route::get('/offices',           [AdminWebController::class, 'officesIndex'])->name('offices.index');
    Route::post('/offices',          [AdminWebController::class, 'officesStore'])->name('offices.store');
    Route::put('/offices/{id}',      [AdminWebController::class, 'officesUpdate'])->name('offices.update');
    Route::delete('/offices/{id}',   [AdminWebController::class, 'officesDestroy'])->name('offices.destroy');

    // Announcements
    Route::get('/announcements',           [AdminWebController::class, 'announcementsIndex'])->name('announcements.index');
    Route::post('/announcements',          [AdminWebController::class, 'announcementsStore'])->name('announcements.store');
    Route::put('/announcements/{id}',      [AdminWebController::class, 'announcementsUpdate'])->name('announcements.update');
    Route::delete('/announcements/{id}',   [AdminWebController::class, 'announcementsDestroy'])->name('announcements.destroy');
});
