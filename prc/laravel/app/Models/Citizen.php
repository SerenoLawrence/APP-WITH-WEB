<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Citizen extends Authenticatable
{
    use HasApiTokens, Notifiable;

    protected $table = 'citizens';

    protected $fillable = [
        'full_name',
        'email',
        'phone',
        'barangay',
        'city',
        'pin_hash',
        'is_active',
    ];

    protected $hidden = [
        'pin_hash',
    ];

    protected function casts(): array
    {
        return [
            'is_active'  => 'boolean',
            'created_at' => 'datetime',
            'updated_at' => 'datetime',
            'pin_hash'   => 'hashed',
        ];
    }

    /**
     * Laravel Auth needs this — our password column is pin_hash.
     */
    public function getAuthPassword(): string
    {
        return $this->pin_hash;
    }

    // ── Relationships ──────────────────────────────────────────────────────

    public function reports(): HasMany
    {
        return $this->hasMany(CitizenReport::class, 'citizen_id');
    }

    public function notifications(): HasMany
    {
        return $this->hasMany(CitizenNotification::class, 'citizen_id')
                    ->orderBy('created_at', 'desc');
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /** First name extracted from full_name */
    public function getFirstNameAttribute(): string
    {
        return explode(' ', $this->full_name)[0];
    }

    /** Total reports submitted */
    public function getTotalReportsAttribute(): int
    {
        return $this->reports()->count();
    }

    /** Count of resolved reports */
    public function getResolvedReportsAttribute(): int
    {
        return $this->reports()->where('status', 'Resolved')->count();
    }
}
