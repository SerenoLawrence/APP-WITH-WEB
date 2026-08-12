<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('government_offices')) return;

        Schema::create('government_offices', function (Blueprint $table) {
            $table->id();
            $table->string('name', 255);
            $table->string('abbreviation', 20);
            $table->string('phone', 30)->nullable();
            $table->string('email', 191)->nullable();
            $table->string('address', 500)->nullable();
            // handles: 'Infrastructure' | 'Environment' | 'Both'
            $table->enum('handles', ['Infrastructure', 'Environment', 'Both'])->default('Both');
            $table->boolean('is_active')->default(true);
            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('government_offices');
    }
};
