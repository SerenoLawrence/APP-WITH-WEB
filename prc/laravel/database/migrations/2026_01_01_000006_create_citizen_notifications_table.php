<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('citizen_notifications')) return;

        Schema::create('citizen_notifications', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('citizen_id');
            $table->string('title', 100);
            $table->text('message');
            $table->string('type', 50)->default('status_update');
            // type: report_submitted | status_update | assigned | resolved | system
            $table->unsignedBigInteger('citizen_report_id')->nullable();
            $table->string('reference_number', 20)->nullable();
            $table->string('status', 50)->nullable();  // status at time of notification
            $table->boolean('is_read')->default(false);
            $table->timestamp('created_at')->useCurrent();

            $table->foreign('citizen_id')->references('id')->on('citizens')->onDelete('cascade');
            $table->foreign('citizen_report_id')->references('id')->on('citizen_reports')->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('citizen_notifications');
    }
};
