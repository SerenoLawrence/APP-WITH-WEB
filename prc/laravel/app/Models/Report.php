<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Report extends Model
{
    protected $table = 'reports';

    protected $fillable = [
        'reference_no',
        'title',
        'description',
        'category',
        'status',
        'priority',
        'barangay',
        'lat',
        'lng',
        'address_text',
        'submitted_by',
        'submitted_contact',
        'assigned_to_office',
        'resolved_at',
    ];

    protected function casts(): array
    {
        return [
            'lat'         => 'float',
            'lng'         => 'float',
            'resolved_at' => 'datetime',
            'created_at'  => 'datetime',
            'updated_at'  => 'datetime',
        ];
    }

    // ── Relationships ─────────────────────────────────────────

    /** All assignment records for this report */
    public function assignments(): HasMany
    {
        return $this->hasMany(ReportAssignment::class, 'report_id');
    }

    /** The most recent assignment */
    public function latestAssignment()
    {
        return $this->hasOne(ReportAssignment::class, 'report_id')->latestOfMany();
    }

    /** All timeline/audit entries */
    public function timeline(): HasMany
    {
        return $this->hasMany(ReportTimeline::class, 'report_id')->orderBy('created_at', 'asc');
    }

    /** Before/after photos */
    public function photos(): HasMany
    {
        return $this->hasMany(ReportPhoto::class, 'report_id');
    }

    /** Before photo only */
    public function beforePhoto()
    {
        return $this->hasOne(ReportPhoto::class, 'report_id')->where('type', 'before');
    }

    /** After photo only */
    public function afterPhoto()
    {
        return $this->hasOne(ReportPhoto::class, 'report_id')->where('type', 'after');
    }

    /** Notifications linked to this report */
    public function notifications(): HasMany
    {
        return $this->hasMany(Notification::class, 'report_id');
    }

    // ── Helpers ───────────────────────────────────────────────

    /** Generate the next reference number e.g. CW-2026-00242 */
    public static function generateReferenceNo(): string
    {
        $year  = now()->year;
        $count = static::whereYear('created_at', $year)->count() + 1;
        return 'CW-' . $year . '-' . str_pad($count, 3, '0', STR_PAD_LEFT);
    }

    /** True if the report is still open (not resolved) */
    public function isOpen(): bool
    {
        return $this->status !== 'resolved';
    }
}
