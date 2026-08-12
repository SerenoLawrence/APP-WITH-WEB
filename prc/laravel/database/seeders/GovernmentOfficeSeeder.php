<?php

namespace Database\Seeders;

use App\Models\GovernmentOffice;
use Illuminate\Database\Seeder;

class GovernmentOfficeSeeder extends Seeder
{
    public function run(): void
    {
        $offices = [
            [
                'name'         => 'City Engineering Office',
                'abbreviation' => 'CEO',
                'phone'        => '+63 82 553 0001',
                'email'        => 'ceo@digos.gov.ph',
                'address'      => 'City Hall Complex, Digos City, Davao del Sur',
                'handles'      => 'Infrastructure',
            ],
            [
                'name'         => 'City Environment and Natural Resources Office',
                'abbreviation' => 'CENRO',
                'phone'        => '+63 82 553 0002',
                'email'        => 'cenro@digos.gov.ph',
                'address'      => 'City Hall Complex, Digos City, Davao del Sur',
                'handles'      => 'Environment',
            ],
            [
                'name'         => 'City Public Works Department',
                'abbreviation' => 'CPWD',
                'phone'        => '+63 82 553 0003',
                'email'        => 'cpwd@digos.gov.ph',
                'address'      => 'City Hall Complex, Digos City, Davao del Sur',
                'handles'      => 'Both',
            ],
            [
                'name'         => 'Digos City Disaster Risk Reduction and Management Office',
                'abbreviation' => 'CDRRMO',
                'phone'        => '+63 82 553 0004',
                'email'        => 'cdrrmo@digos.gov.ph',
                'address'      => 'City Hall Complex, Digos City, Davao del Sur',
                'handles'      => 'Both',
            ],
            [
                'name'         => 'City Veterinary Office',
                'abbreviation' => 'CVO',
                'phone'        => '+63 82 553 0005',
                'email'        => 'cvo@digos.gov.ph',
                'address'      => 'City Hall Complex, Digos City, Davao del Sur',
                'handles'      => 'Both',
            ],
        ];

        foreach ($offices as $office) {
            GovernmentOffice::firstOrCreate(
                ['abbreviation' => $office['abbreviation']],
                $office
            );
        }

        $this->command->info('Government offices seeded: ' . count($offices));
    }
}
