<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ReportActivity extends Model
{
    protected $table = 'report_activities';

    public $timestamps = false; // only has created_at

    protected $fillable = [
        'citizen_report_id',
        'title',
        'description',
        'status',
        'created_at',
    ];

    protected function casts(): array
    {
        return [
            'created_at' => 'datetime',
        ];
    }

    // ── Relationships ──────────────────────────────────────────────────────

    public function report(): BelongsTo
    {
        return $this->belongsTo(CitizenReport::class, 'citizen_report_id');
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /**
     * API response shape expected by the Flutter ActivityEntry model.
     */
    public function toApiArray(): array
    {
        return [
            'title'       => $this->title,
            'description' => $this->description ?? '',
            'timestamp'   => $this->created_at?->toIso8601String(),
            'status'      => $this->status,
        ];
    }
}
