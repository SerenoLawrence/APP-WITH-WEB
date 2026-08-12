<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('report_activities')) return;

        Schema::create('report_activities', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('citizen_report_id');
            $table->string('title', 100);              // e.g. "Assigned to Office"
            $table->text('description')->nullable();   // human-readable detail
            $table->string('status', 50);              // the status at this point
            $table->timestamp('created_at')->useCurrent();

            $table->foreign('citizen_report_id')
                  ->references('id')
                  ->on('citizen_reports')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('report_activities');
    }
};
