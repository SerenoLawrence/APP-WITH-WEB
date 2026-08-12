<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;

    /**
     * The table associated with the model.
     */
    protected $table = 'users';

    /**
     * The column used to store the password.
     * Your table uses 'password_hash' instead of Laravel's default 'password'.
     */
    protected $authPasswordName = 'password_hash';

    /**
     * Fields that are allowed to be mass-assigned.
     */
    protected $fillable = [
        'name',
        'email',
        'password_hash',
        'role',
        'office',
        'avatar_url',
        'is_active',
    ];

    /**
     * Fields that should NEVER appear in API responses or JSON output.
     */
    protected $hidden = [
        'password_hash',
    ];

    /**
     * Type casting for specific fields.
     */
    protected function casts(): array
    {
        return [
            'is_active'     => 'boolean',
            'last_login_at' => 'datetime',
            'created_at'    => 'datetime',
            'updated_at'    => 'datetime',
            'password_hash' => 'hashed',
        ];
    }

    /**
     * Laravel's Auth system calls this to get the password field value.
     * We override it because our column is 'password_hash', not 'password'.
     */
    public function getAuthPassword(): string
    {
        return $this->password_hash;
    }

    /**
     * Check if this user is a Super Admin.
     */
    public function isSuperAdmin(): bool
    {
        return $this->role === 'super_admin';
    }

    /**
     * Check if this user account is active.
     */
    public function isActive(): bool
    {
        return (bool) $this->is_active;
    }
}

