<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Announcement extends Model
{
    protected $table = 'announcements';

    protected $fillable = [
        'title',
        'body',
        'is_published',
        'published_at',
    ];

    protected function casts(): array
    {
        return [
            'is_published' => 'boolean',
            'published_at' => 'datetime',
            'created_at'   => 'datetime',
            'updated_at'   => 'datetime',
        ];
    }

    // ── Scopes ─────────────────────────────────────────────────────────────

    public function scopePublished($query)
    {
        return $query->where('is_published', true);
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /**
     * API response shape expected by the Flutter Announcement model.
     */
    public function toApiArray(): array
    {
        return [
            'id'    => (string) $this->id,
            'title' => $this->title,
            'body'  => $this->body,
            'date'  => ($this->published_at ?? $this->created_at)?->toIso8601String(),
        ];
    }
}
