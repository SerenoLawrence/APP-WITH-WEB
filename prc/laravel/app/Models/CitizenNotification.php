<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CitizenNotification extends Model
{
    protected $table = 'citizen_notifications';

    public $timestamps = false; // only has created_at

    protected $fillable = [
        'citizen_id',
        'title',
        'message',
        'type',
        'citizen_report_id',
        'reference_number',
        'status',
        'is_read',
        'created_at',
    ];

    protected function casts(): array
    {
        return [
            'is_read'    => 'boolean',
            'created_at' => 'datetime',
        ];
    }

    // ── Relationships ──────────────────────────────────────────────────────

    public function citizen(): BelongsTo
    {
        return $this->belongsTo(Citizen::class, 'citizen_id');
    }

    public function report(): BelongsTo
    {
        return $this->belongsTo(CitizenReport::class, 'citizen_report_id');
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /**
     * Send a notification to a citizen.
     */
    public static function send(
        int     $citizenId,
        string  $title,
        string  $message,
        string  $type            = 'status_update',
        ?int    $reportId        = null,
        ?string $referenceNumber = null,
        ?string $status          = null,
    ): static {
        return static::create([
            'citizen_id'        => $citizenId,
            'title'             => $title,
            'message'           => $message,
            'type'              => $type,
            'citizen_report_id' => $reportId,
            'reference_number'  => $referenceNumber,
            'status'            => $status,
            'is_read'           => false,
            'created_at'        => now(),
        ]);
    }

    /**
     * API response shape expected by the Flutter AppNotification model.
     */
    public function toApiArray(): array
    {
        return [
            'id'              => (string) $this->id,
            'title'           => $this->title,
            'message'         => $this->message,
            'referenceNumber' => $this->reference_number ?? '',
            'status'          => $this->status ?? '',
            'timestamp'       => $this->created_at?->toIso8601String(),
            'isRead'          => $this->is_read,
        ];
    }
}
