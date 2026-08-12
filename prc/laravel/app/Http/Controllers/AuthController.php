<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    /**
     * POST /api/login
     *
     * Accepts: { email, password }
     * Returns: { success, message, data: { token, user } }
     */
    public function login(Request $request): JsonResponse
    {
        // Step 1 — Validate the incoming data
        // If validation fails, Laravel automatically returns a 422 error response
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        // Step 2 — Find the user by email
        $user = User::where('email', $request->email)->first();

        // Step 3 — Check if user exists
        if (! $user) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid email or password.',
            ], 401);
        }

        // Step 4 — Check if account is active
        if (! $user->isActive()) {
            return response()->json([
                'success' => false,
                'message' => 'Your account has been deactivated. Please contact the administrator.',
            ], 403);
        }

        // Step 5 — Verify the password against the stored hash
        // Hash::check() safely compares plain password vs hashed password
        if (! Hash::check($request->password, $user->getAuthPassword())) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid email or password.',
            ], 401);
        }

        // Step 6 — Update last login timestamp
        $user->update(['last_login_at' => now()]);

        // Step 7 — Create an API token for this user
        // 'auth_token' is just a label for the token
        // abilities: what this token is allowed to do
        $token = $user->createToken('auth_token', ['*'])->plainTextToken;

        // Step 8 — Return success response with token and user info
        return response()->json([
            'success' => true,
            'message' => 'Login successful.',
            'data'    => [
                'token' => $token,
                'user'  => [
                    'id'     => $user->id,
                    'name'   => $user->name,
                    'email'  => $user->email,
                    'role'   => $user->role,
                    'office' => $user->office,
                ],
            ],
        ], 200);
    }

    /**
     * POST /api/logout
     *
     * Revokes the current user's token.
     * Requires: Authorization: Bearer {token} header
     */
    public function logout(Request $request): JsonResponse
    {
        // Delete the token that was used to make this request
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully.',
        ], 200);
    }

    /**
     * GET /api/user
     *
     * Returns the currently authenticated user's info.
     * Requires: Authorization: Bearer {token} header
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'success' => true,
            'message' => 'Authenticated user retrieved.',
            'data'    => [
                'id'            => $user->id,
                'name'          => $user->name,
                'email'         => $user->email,
                'role'          => $user->role,
                'office'        => $user->office,
                'is_active'     => $user->is_active,
                'last_login_at' => $user->last_login_at,
            ],
        ], 200);
    }
}
