<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('citizens')) return;

        Schema::create('citizens', function (Blueprint $table) {
            $table->id();
            $table->string('full_name', 150);
            $table->string('email', 191)->nullable()->unique();
            $table->string('phone', 20)->unique(); // e.g. 639XXXXXXXXX
            $table->string('barangay', 100);
            $table->string('city', 100)->default('Digos City');
            $table->string('pin_hash', 255);          // bcrypt of 6-digit PIN
            $table->boolean('is_active')->default(true);
            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('citizens');
    }
};
