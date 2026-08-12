<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Models\CitizenNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MobileNotificationController extends Controller
{
    // ─────────────────────────────────────────────────────────────────────
    // GET /api/mobile/notifications
    // Returns all notifications for the citizen with unread count.
    // ─────────────────────────────────────────────────────────────────────
    public function index(Request $request): JsonResponse
    {
        $citizen = $request->user('citizen');

        $notifications = CitizenNotification::where('citizen_id', $citizen->id)
            ->orderBy('created_at', 'desc')
            ->limit(50)
            ->get();

        $unreadCount = CitizenNotification::where('citizen_id', $citizen->id)
            ->where('is_read', false)
            ->count();

        return response()->json([
            'success' => true,
            'data'    => [
                'notifications' => $notifications->map(fn($n) => $n->toApiArray())->values(),
                'unread_count'  => $unreadCount,
            ],
        ]);
    }

    // ─────────────────────────────────────────────────────────────────────
    // POST /api/mobile/notifications/mark-all-read
    // ─────────────────────────────────────────────────────────────────────
    public function markAllRead(Request $request): JsonResponse
    {
        CitizenNotification::where('citizen_id', $request->user('citizen')->id)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return response()->json([
            'success' => true,
            'message' => 'All notifications marked as read.',
        ]);
    }

    // ─────────────────────────────────────────────────────────────────────
    // POST /api/mobile/notifications/{id}/read
    // ─────────────────────────────────────────────────────────────────────
    public function markRead(Request $request, int $id): JsonResponse
    {
        $notification = CitizenNotification::where('id', $id)
            ->where('citizen_id', $request->user('citizen')->id)
            ->firstOrFail();

        $notification->update(['is_read' => true]);

        return response()->json([
            'success' => true,
            'message' => 'Notification marked as read.',
        ]);
    }
}
