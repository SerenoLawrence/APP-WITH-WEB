<?php

use App\Http\Controllers\AnalyticsController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes — CivilWatch
|--------------------------------------------------------------------------
| All routes here are automatically prefixed with /api
|
| Public routes    — no token required
| Protected routes — must send:  Authorization: Bearer {token}
|--------------------------------------------------------------------------
*/

// -----------------------------------------------------------------------
// Public
// -----------------------------------------------------------------------

Route::get('/ping', fn() => response()->json([
    'success' => true,
    'message' => 'CivilWatch API is running.',
]));

Route::post('/login', [AuthController::class, 'login']);

// -----------------------------------------------------------------------
// Protected — requires valid Sanctum token
// -----------------------------------------------------------------------

Route::middleware('auth:sanctum')->group(function () {

    // ── Auth ────────────────────────────────────────────────
    Route::get('/user',    [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // ── Users (super_admin only — enforced inside controller) ─
    Route::get('/users',         [UserController::class, 'index']);
    Route::post('/users',        [UserController::class, 'store']);
    Route::get('/users/{id}',    [UserController::class, 'show']);
    Route::put('/users/{id}',    [UserController::class, 'update']);
    Route::delete('/users/{id}', [UserController::class, 'destroy']);

    // ── Reports ─────────────────────────────────────────────
    // List & create
    Route::get('/reports',  [ReportController::class, 'index']);
    Route::post('/reports', [ReportController::class, 'store']);

    // Map pins (must come before {id} to avoid route conflict)
    Route::get('/reports/map', [ReportController::class, 'mapPins']);

    // Single report
    Route::get('/reports/{id}',    [ReportController::class, 'show']);
    Route::put('/reports/{id}',    [ReportController::class, 'update']);
    Route::delete('/reports/{id}', [ReportController::class, 'destroy']);

    // Workflow actions
    Route::post('/reports/{id}/validate', [ReportController::class, 'validateReport']);
    Route::post('/reports/{id}/reject',   [ReportController::class, 'rejectReport']);
    Route::post('/reports/{id}/assign',   [ReportController::class, 'assign']);
    Route::post('/reports/{id}/status',   [ReportController::class, 'updateStatus']);

    // ── Analytics ───────────────────────────────────────────
    // All-in-one (used by Analytics pages — one fetch loads all charts)
    Route::get('/analytics',                     [AnalyticsController::class, 'full']);

    // Individual endpoints (used by Dashboard stat cards)
    Route::get('/analytics/summary',             [AnalyticsController::class, 'summary']);
    Route::get('/analytics/status-distribution', [AnalyticsController::class, 'statusDistribution']);
    Route::get('/analytics/by-category',         [AnalyticsController::class, 'byCategory']);
    Route::get('/analytics/top-issues',          [AnalyticsController::class, 'topIssues']);
    Route::get('/analytics/top-barangays',       [AnalyticsController::class, 'topBarangays']);
    Route::get('/analytics/weekly-trend',        [AnalyticsController::class, 'weeklyTrend']);
    Route::get('/analytics/monthly-trend',       [AnalyticsController::class, 'monthlyTrend']);

    // ── Notifications ───────────────────────────────────────
    // Lightweight badge poll
    Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);

    // Full list & bulk actions
    Route::get('/notifications',    [NotificationController::class, 'index']);
    Route::delete('/notifications', [NotificationController::class, 'destroyAll']);

    // Single notification actions
    Route::post('/notifications/{id}/read', [NotificationController::class, 'markRead']);
    Route::delete('/notifications/{id}',    [NotificationController::class, 'destroy']);

    // Mark all read
    Route::post('/notifications/read-all', [NotificationController::class, 'markAllRead']);

});
