<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class OtpCode extends Model
{
    protected $table = 'otp_codes';

    public $timestamps = false; // only has created_at

    protected $fillable = [
        'phone',
        'code',
        'is_used',
        'expires_at',
        'created_at',
    ];

    protected function casts(): array
    {
        return [
            'is_used'    => 'boolean',
            'expires_at' => 'datetime',
            'created_at' => 'datetime',
        ];
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /** True if this OTP is still valid (not used, not expired) */
    public function isValid(): bool
    {
        return ! $this->is_used && $this->expires_at->isFuture();
    }

    /**
     * Store a new OTP for a phone number.
     * Invalidates any previous unused OTPs for the same number.
     */
    public static function issue(string $phone, string $code): static
    {
        // Expire previous OTPs for this phone
        static::where('phone', $phone)
              ->where('is_used', false)
              ->update(['is_used' => true]);

        return static::create([
            'phone'      => $phone,
            'code'       => $code,
            'is_used'    => false,
            'expires_at' => Carbon::now()->addMinutes(5),
            'created_at' => Carbon::now(),
        ]);
    }

    /**
     * Find a valid (unused + unexpired) OTP for a phone number.
     */
    public static function findValid(string $phone, string $code): ?static
    {
        return static::where('phone', $phone)
                     ->where('code', $code)
                     ->where('is_used', false)
                     ->where('expires_at', '>', now())
                     ->latest('created_at')
                     ->first();
    }
}
