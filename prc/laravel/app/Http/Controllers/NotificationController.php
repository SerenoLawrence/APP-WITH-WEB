<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    // ──────────────────────────────────────────────────────────
    // GET /api/notifications
    // Returns all notifications for the authenticated user
    // ?unread_only=1  → filter to unread only
    // ──────────────────────────────────────────────────────────
    public function index(Request $request): JsonResponse
    {
        $query = Notification::where('user_id', $request->user()->id)
                             ->orderBy('created_at', 'desc');

        if ($request->boolean('unread_only')) {
            $query->where('is_read', false);
        }

        $notifications = $query->limit(50)->get();
        $unreadCount   = Notification::where('user_id', $request->user()->id)
                                     ->where('is_read', false)
                                     ->count();

        return response()->json([
            'success' => true,
            'data'    => [
                'notifications' => $notifications,
                'unread_count'  => $unreadCount,
            ],
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // POST /api/notifications/{id}/read
    // Mark a single notification as read
    // ──────────────────────────────────────────────────────────
    public function markRead(Request $request, int $id): JsonResponse
    {
        $notification = Notification::where('id', $id)
                                    ->where('user_id', $request->user()->id)
                                    ->firstOrFail();

        $notification->update(['is_read' => true]);

        return response()->json([
            'success' => true,
            'message' => 'Notification marked as read.',
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // POST /api/notifications/read-all
    // Mark ALL of the user's notifications as read
    // ──────────────────────────────────────────────────────────
    public function markAllRead(Request $request): JsonResponse
    {
        Notification::where('user_id', $request->user()->id)
                    ->where('is_read', false)
                    ->update(['is_read' => true]);

        return response()->json([
            'success' => true,
            'message' => 'All notifications marked as read.',
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // DELETE /api/notifications/{id}
    // Delete a single notification
    // ──────────────────────────────────────────────────────────
    public function destroy(Request $request, int $id): JsonResponse
    {
        $notification = Notification::where('id', $id)
                                    ->where('user_id', $request->user()->id)
                                    ->firstOrFail();

        $notification->delete();

        return response()->json([
            'success' => true,
            'message' => 'Notification deleted.',
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // DELETE /api/notifications
    // Clear all notifications for the current user
    // ──────────────────────────────────────────────────────────
    public function destroyAll(Request $request): JsonResponse
    {
        Notification::where('user_id', $request->user()->id)->delete();

        return response()->json([
            'success' => true,
            'message' => 'All notifications cleared.',
        ]);
    }

    // ──────────────────────────────────────────────────────────
    // GET /api/notifications/unread-count
    // Lightweight poll endpoint — returns just the badge count
    // The frontend can call this every 30s to update the bell badge
    // ──────────────────────────────────────────────────────────
    public function unreadCount(Request $request): JsonResponse
    {
        $count = Notification::where('user_id', $request->user()->id)
                             ->where('is_read', false)
                             ->count();

        return response()->json([
            'success' => true,
            'data'    => ['unread_count' => $count],
        ]);
    }
}
