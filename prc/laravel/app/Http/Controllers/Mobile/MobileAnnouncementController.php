<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Models\Announcement;
use Illuminate\Http\JsonResponse;

class MobileAnnouncementController extends Controller
{
    // ─────────────────────────────────────────────────────────────────────
    // GET /api/mobile/announcements
    // Returns published announcements, newest first.
    // ─────────────────────────────────────────────────────────────────────
    public function index(): JsonResponse
    {
        $announcements = Announcement::published()
            ->orderBy('published_at', 'desc')
            ->orderBy('created_at', 'desc')
            ->limit(20)
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $announcements->map(fn($a) => $a->toApiArray())->values(),
        ]);
    }
}
