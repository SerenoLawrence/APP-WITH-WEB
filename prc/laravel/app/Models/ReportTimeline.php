<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ReportTimeline extends Model
{
    protected $table = 'report_timeline';

    // Only created_at exists on this table, no updated_at
    public $timestamps = false;

    protected $fillable = [
        'report_id',
        'action',
        'note',
        'from_status',
        'to_status',
        'performed_by',
    ];

    protected function casts(): array
    {
        return [
            'created_at' => 'datetime',
        ];
    }

    // ── Relationships ─────────────────────────────────────────

    /** The report this timeline entry belongs to */
    public function report(): BelongsTo
    {
        return $this->belongsTo(Report::class, 'report_id');
    }

    /** The user who performed this action (null = system or citizen) */
    public function performedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'performed_by');
    }

    // ── Helpers ───────────────────────────────────────────────

    /**
     * Quickly log a timeline entry.
     *
     * Usage:
     *   ReportTimeline::log($report->id, 'status_change', 'assigned', 'in_progress', $userId, 'Work started.');
     */
    public static function log(
        int     $reportId,
        string  $action,
        ?string $fromStatus  = null,
        ?string $toStatus    = null,
        ?int    $performedBy = null,
        ?string $note        = null
    ): static {
        return static::create([
            'report_id'    => $reportId,
            'action'       => $action,
            'from_status'  => $fromStatus,
            'to_status'    => $toStatus,
            'performed_by' => $performedBy,
            'note'         => $note,
            'created_at'   => now(),
        ]);
    }
}
