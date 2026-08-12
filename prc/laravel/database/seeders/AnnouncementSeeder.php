<?php

namespace Database\Seeders;

use App\Models\Announcement;
use Illuminate\Database\Seeder;

class AnnouncementSeeder extends Seeder
{
    public function run(): void
    {
        $announcements = [
            [
                'title'        => 'Keep Digos City Clean and Safe!',
                'body'         => "Let's work together for a better community. Report any infrastructure or environmental concerns through the CivilWatch app.",
                'is_published' => true,
                'published_at' => now()->subDays(2),
            ],
            [
                'title'        => 'Road Repair Schedule — Barangay San Miguel',
                'body'         => 'Road repairs will be conducted from July 18–20, 2026. Expect partial road closures. Please use alternate routes.',
                'is_published' => true,
                'published_at' => now()->subDays(4),
            ],
        ];

        foreach ($announcements as $item) {
            Announcement::firstOrCreate(
                ['title' => $item['title']],
                $item
            );
        }

        $this->command->info('Announcements seeded: ' . count($announcements));
    }
}
