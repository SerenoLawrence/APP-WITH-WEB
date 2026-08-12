<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class GovernmentOffice extends Model
{
    protected $table = 'government_offices';

    protected $fillable = [
        'name',
        'abbreviation',
        'phone',
        'email',
        'address',
        'handles',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'is_active'  => 'boolean',
            'created_at' => 'datetime',
            'updated_at' => 'datetime',
        ];
    }

    // ── Relationships ──────────────────────────────────────────────────────

    public function reports(): HasMany
    {
        return $this->hasMany(CitizenReport::class, 'assigned_office_id');
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /**
     * Returns handles as an array — the Flutter app expects List<String>.
     * e.g. 'Infrastructure' → ['Infrastructure']
     *      'Both'           → ['Infrastructure', 'Environment']
     */
    public function getHandlesListAttribute(): array
    {
        return match ($this->handles) {
            'Infrastructure' => ['Infrastructure'],
            'Environment'    => ['Environment'],
            'Both'           => ['Infrastructure', 'Environment'],
            default          => [],
        };
    }

    /**
     * Build the API response shape expected by the Flutter GovernmentOffice model.
     */
    public function toApiArray(): array
    {
        return [
            'id'            => (string) $this->id,
            'name'          => $this->name,
            'abbreviation'  => $this->abbreviation,
            'handles'       => $this->handles_list,
            'contactNumber' => $this->phone ?? '',
            'email'         => $this->email,
            'address'       => $this->address,
        ];
    }
}
