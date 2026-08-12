<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GovernmentOffice;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class AdminOfficeController extends Controller
{
    public function index(): JsonResponse
    {
        $offices = GovernmentOffice::where('is_active', true)
            ->orderBy('name')
            ->get()
            ->map(fn($o) => $o->toApiArray());

        return response()->json(['success' => true, 'data' => $offices]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'         => 'required|string|max:255',
            'abbreviation' => 'required|string|max:20',
            'phone'        => 'nullable|string|max:30',
            'email'        => 'nullable|email|max:191',
            'address'      => 'nullable|string|max:500',
            'handles'      => ['required', Rule::in(['Infrastructure', 'Environment', 'Both'])],
        ]);

        $office = GovernmentOffice::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Office created.',
            'data'    => $office->toApiArray(),
        ], 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $office = GovernmentOffice::findOrFail($id);

        $validated = $request->validate([
            'name'         => 'sometimes|string|max:255',
            'abbreviation' => 'sometimes|string|max:20',
            'phone'        => 'nullable|string|max:30',
            'email'        => 'nullable|email|max:191',
            'address'      => 'nullable|string|max:500',
            'handles'      => ['sometimes', Rule::in(['Infrastructure', 'Environment', 'Both'])],
            'is_active'    => 'boolean',
        ]);

        $office->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Office updated.',
            'data'    => $office->fresh()->toApiArray(),
        ]);
    }

    public function destroy(int $id): JsonResponse
    {
        $office = GovernmentOffice::findOrFail($id);
        $office->update(['is_active' => false]); // soft deactivate

        return response()->json(['success' => true, 'message' => 'Office deactivated.']);
    }
}
