<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Announcement;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AdminAnnouncementController extends Controller
{
    public function index(): JsonResponse
    {
        $announcements = Announcement::orderBy('created_at', 'desc')->get()
            ->map(fn($a) => $a->toApiArray());

        return response()->json(['success' => true, 'data' => $announcements]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title'        => 'required|string|max:255',
            'body'         => 'required|string',
            'is_published' => 'boolean',
            'published_at' => 'nullable|date',
        ]);

        $validated['published_at'] = $validated['published_at'] ?? now();
        $validated['is_published'] = $validated['is_published'] ?? true;

        $announcement = Announcement::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Announcement posted.',
            'data'    => $announcement->toApiArray(),
        ], 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $announcement = Announcement::findOrFail($id);

        $validated = $request->validate([
            'title'        => 'sometimes|string|max:255',
            'body'         => 'sometimes|string',
            'is_published' => 'boolean',
            'published_at' => 'nullable|date',
        ]);

        $announcement->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Announcement updated.',
            'data'    => $announcement->fresh()->toApiArray(),
        ]);
    }

    public function destroy(int $id): JsonResponse
    {
        Announcement::findOrFail($id)->delete();

        return response()->json(['success' => true, 'message' => 'Announcement deleted.']);
    }
}
