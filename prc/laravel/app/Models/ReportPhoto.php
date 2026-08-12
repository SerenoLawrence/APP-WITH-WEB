<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ReportPhoto extends Model
{
    protected $table = 'report_photos';

    // Only created_at exists on this table
    public $timestamps = false;

    protected $fillable = [
        'report_id',
        'type',           // 'before' or 'after'
        'cloudinary_url',
        'cloudinary_public_id',
        'uploaded_by',
    ];

    protected function casts(): array
    {
        return [
            'created_at' => 'datetime',
        ];
    }

    // ── Relationships ─────────────────────────────────────────

    /** The report this photo belongs to */
    public function report(): BelongsTo
    {
        return $this->belongsTo(Report::class, 'report_id');
    }

    /** The user who uploaded this photo (null = citizen) */
    public function uploadedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'uploaded_by');
    }
}
