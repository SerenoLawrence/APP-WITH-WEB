<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * This migration matches the existing 'civilwatch' database schema.
     * We use Schema::hasTable() checks so running this on an existing
     * database does not throw "table already exists" errors.
     */
    public function up(): void
    {
        // Only create 'users' if it doesn't already exist
        if (! Schema::hasTable('users')) {
            Schema::create('users', function (Blueprint $table) {
                $table->increments('id');
                $table->string('name', 120);
                $table->string('email', 191)->unique('uq_users_email');
                $table->string('password_hash', 255);
                $table->enum('role', ['super_admin', 'ceo', 'cenro'])->default('ceo');
                $table->string('office', 100)->nullable();
                $table->string('avatar_url', 500)->nullable();
                $table->boolean('is_active')->default(true);
                $table->dateTime('last_login_at')->nullable();
                $table->dateTime('created_at')->useCurrent();
                $table->dateTime('updated_at')->useCurrent()->useCurrentOnUpdate();
            });
        }

        // Sessions table — used by Laravel internally if SESSION_DRIVER=database
        // We skip it here since we use SESSION_DRIVER=file
        // If you ever switch to session driver=database, uncomment this block
        /*
        if (! Schema::hasTable('sessions')) {
            Schema::create('sessions', function (Blueprint $table) {
                $table->string('id')->primary();
                $table->foreignId('user_id')->nullable()->index();
                $table->string('ip_address', 45)->nullable();
                $table->text('user_agent')->nullable();
                $table->longText('payload');
                $table->integer('last_activity')->index();
            });
        }
        */
    }

    /**
     * Reverse the migrations.
     * dropIfExists is safe — it won't error if the table is already gone.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
