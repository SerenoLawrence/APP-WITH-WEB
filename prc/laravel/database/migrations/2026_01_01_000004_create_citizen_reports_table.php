<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('citizen_reports')) return;

        Schema::create('citizen_reports', function (Blueprint $table) {
            $table->id();
            $table->string('reference_number', 20)->unique(); // CW-2026-00125
            $table->unsignedBigInteger('citizen_id');

            // What was reported
            $table->enum('category', ['Infrastructure', 'Environment', 'Others']);
            $table->string('concern', 100);  // e.g. "Road Repair", "Illegal Dumping"
            $table->text('description')->nullable();

            // Location
            $table->string('street', 255)->nullable();
            $table->string('purok', 100)->nullable();
            $table->string('barangay', 100);
            $table->string('city', 100)->default('Digos City');
            $table->string('province', 100)->default('Davao del Sur');
            $table->string('landmark', 255)->nullable();
            $table->decimal('lat', 10, 7)->nullable();
            $table->decimal('lng', 10, 7)->nullable();

            // Details
            $table->enum('severity', ['Minor', 'Moderate', 'Severe'])->default('Moderate');
            $table->string('photo_url', 500)->nullable();

            // Status & assignment
            $table->enum('status', [
                'Submitted',
                'Pending Validation',
                'Assigned to Office',
                'In Progress',
                'Resolved',
            ])->default('Submitted');
            $table->unsignedBigInteger('assigned_office_id')->nullable();
            $table->timestamp('resolved_at')->nullable();

            // Visibility on community map (admin toggles after validation)
            $table->boolean('is_public')->default(false);

            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();

            $table->foreign('citizen_id')->references('id')->on('citizens')->onDelete('cascade');
            $table->foreign('assigned_office_id')->references('id')->on('government_offices')->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('citizen_reports');
    }
};
