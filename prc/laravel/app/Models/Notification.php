<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Notification extends Model
{
    protected $table = 'notifications';

    // Only created_at exists on this table
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'message',
        'type',       // report_submitted | report_assigned | status_update | report_resolved | system
        'report_id',
        'is_read',
    ];

    protected function casts(): array
    {
        return [
            'is_read'    => 'boolean',
            'created_at' => 'datetime',
        ];
    }

    // ── Relationships ─────────────────────────────────────────

    /** The user this notification belongs to */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /** The related report (optional) */
    public function report(): BelongsTo
    {
        return $this->belongsTo(Report::class, 'report_id');
    }

    // ── Helpers ───────────────────────────────────────────────

    /**
     * Send a notification to a user.
     *
     * Usage:
     *   Notification::send($userId, 'Report CW-2026-001 has been assigned to CENRO.', 'report_assigned', $reportId);
     */
    public static function send(
        int     $userId,
        string  $message,
        string  $type      = 'system',
        ?int    $reportId  = null
    ): static {
        return static::create([
            'user_id'    => $userId,
            'message'    => $message,
            'type'       => $type,
            'report_id'  => $reportId,
            'is_read'    => false,
            'created_at' => now(),
        ]);
    }

    /**
     * Notify all users of a specific role.
     *
     * Usage:
     *   Notification::sendToRole('super_admin', 'New report submitted.', 'report_submitted', $reportId);
     */
    public static function sendToRole(
        string  $role,
        string  $message,
        string  $type     = 'system',
        ?int    $reportId = null
    ): void {
        $users = User::where('role', $role)->where('is_active', true)->get();
        foreach ($users as $user) {
            static::send($user->id, $message, $type, $reportId);
        }
    }
}
