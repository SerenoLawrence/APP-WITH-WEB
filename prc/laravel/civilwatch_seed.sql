-- ============================================================
-- CIVILWATCH — Complete Seed Data
-- Compatible with phpMyAdmin + MariaDB 10.4
-- Import this file directly into the civilwatch database
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- CLEAN ALL TABLES (safe order)
-- ============================================================
DELETE FROM `notifications`;
DELETE FROM `report_timeline`;
DELETE FROM `report_photos`;
DELETE FROM `report_assignments`;
DELETE FROM `reports`;
DELETE FROM `personal_access_tokens`;
DELETE FROM `users`;

-- Reset auto increments
ALTER TABLE `users`              AUTO_INCREMENT = 1;
ALTER TABLE `reports`            AUTO_INCREMENT = 1;
ALTER TABLE `report_photos`      AUTO_INCREMENT = 1;
ALTER TABLE `report_assignments` AUTO_INCREMENT = 1;
ALTER TABLE `report_timeline`    AUTO_INCREMENT = 1;
ALTER TABLE `notifications`      AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- USERS
-- Credentials:
--   admin@civilwatch.gov.ph  / admin123
--   ceo@civilwatch.gov.ph    / ceo123
--   cenro@civilwatch.gov.ph  / cenro123
-- ============================================================
INSERT INTO `users`
  (`id`, `name`, `email`, `password_hash`, `role`, `office`, `avatar_url`, `is_active`, `last_login_at`, `created_at`, `updated_at`)
VALUES
(1, 'System Administrator',
   'admin@civilwatch.gov.ph',
   '$2y$12$s1Vzu15Uv.MPVwc7T2Vq4./nti/GZqcQtknNq8Rul.F0wvxjMBVgq',
   'super_admin', NULL,
   'https://ui-avatars.com/api/?name=System+Administrator&background=1A56DB&color=fff&size=128',
   1, NULL, '2026-08-01 08:00:00', '2026-08-01 08:00:00'),

(2, 'Engr. Miguel Santos',
   'ceo@civilwatch.gov.ph',
   '$2y$12$5dcO09RTGhFsgE3WLVcvJe1QSfDKnig9H5uvaaBhvaKRBu8XQ/lne',
   'ceo', 'CEO',
   'https://ui-avatars.com/api/?name=Miguel+Santos&background=1A56DB&color=fff&size=128',
   1, NULL, '2026-08-01 08:00:00', '2026-08-01 08:00:00'),

(3, 'Ramon Alonzo',
   'cenro@civilwatch.gov.ph',
   '$2y$12$EBaTTstBpFin3BrdTggTS.Nn55zAKo38VtkpW7vgeLCfl6gh1G2jC',
   'cenro', 'CENRO',
   'https://ui-avatars.com/api/?name=Ramon+Alonzo&background=166534&color=fff&size=128',
   1, NULL, '2026-08-01 08:00:00', '2026-08-01 08:00:00');

-- ============================================================
-- REPORTS (20 records — real Digos City data)
-- ============================================================
INSERT INTO `reports`
  (`id`, `reference_no`, `title`, `description`, `category`, `status`, `priority`,
   `barangay`, `lat`, `lng`, `address_text`,
   `submitted_by`, `submitted_contact`, `assigned_to_office`, `resolved_at`,
   `created_at`, `updated_at`)
VALUES
-- PENDING (6)
(1,  'CW-2026-001', 'Damaged Road',
   'Multiple deep potholes along the main road in Aplaya causing difficulty for vehicles and risk of accidents especially at night.',
   'infrastructure', 'pending', 'high', 'Aplaya', 6.7500, 125.3540,
   'Aplaya Main Road, Digos City', 'Juan Dela Cruz', '0912-345-6789',
   NULL, NULL, '2026-08-10 07:15:00', '2026-08-10 07:15:00'),

(2,  'CW-2026-002', 'Illegal Dumping',
   'Large volume of household garbage illegally dumped along the riverbank near Carmen barangay hall. Foul odor affecting nearby residents.',
   'environmental', 'pending', 'high', 'Carmen', 6.7420, 125.3480,
   'Carmen Riverbank, Digos City', 'Maria Santos', '0998-765-4321',
   NULL, NULL, '2026-08-10 08:30:00', '2026-08-10 08:30:00'),

(3,  'CW-2026-003', 'Damaged Sidewalk',
   'Cracked and uneven sidewalk tiles near the public market in Zone II. Pedestrians especially elderly and children are at risk of tripping.',
   'infrastructure', 'pending', 'medium', 'Zone II', 6.7560, 125.3600,
   'Zone II Public Market, Digos City', 'Pedro Reyes', '0917-111-2222',
   NULL, NULL, '2026-08-10 09:00:00', '2026-08-10 09:00:00'),

(4,  'CW-2026-004', 'Blocked Drainage',
   'Main drainage canal in Magsaysay is fully clogged with silt and debris causing floodwater to overflow into residential streets after rain.',
   'infrastructure', 'pending', 'high', 'Magsaysay', 6.7480, 125.3520,
   'Magsaysay Drainage Canal, Digos City', 'Ana Lopez', '0933-222-1111',
   NULL, NULL, '2026-08-10 10:00:00', '2026-08-10 10:00:00'),

(5,  'CW-2026-005', 'Overgrown Vegetation',
   'Thick overgrown vegetation blocking the pathway and road visibility along the national highway in Badiang. Hazard for motorists.',
   'environmental', 'pending', 'medium', 'Badiang', 6.7610, 125.3680,
   'Badiang National Highway, Digos City', 'Ramon Garcia', '0906-888-7777',
   NULL, NULL, '2026-08-10 11:00:00', '2026-08-10 11:00:00'),

(6,  'CW-2026-006', 'Broken Streetlight',
   'Three consecutive streetlights are not functioning along the road near Zone III basketball court. Area is very dark and unsafe at night.',
   'infrastructure', 'pending', 'medium', 'Zone III', 6.7530, 125.3570,
   'Zone III Basketball Court Road, Digos City', 'Carla Mendoza', '0915-333-4444',
   NULL, NULL, '2026-08-09 18:30:00', '2026-08-09 18:30:00'),

-- ASSIGNED (4)
(7,  'CW-2026-007', 'Road Graveling Needed',
   'Unpaved section of barangay road in Tiguman is impassable during rainy season. Residents requesting immediate graveling.',
   'infrastructure', 'assigned', 'medium', 'Tiguman', 6.7460, 125.3660,
   'Tiguman Barangay Road, Digos City', 'Luz Fernandez', '0921-444-5555',
   'CEO', NULL, '2026-08-08 09:00:00', '2026-08-09 10:00:00'),

(8,  'CW-2026-008', 'Illegal Dumping',
   'Dumping of construction waste along the creek in Dawis barangay. Blocking water flow and causing risk of flash flooding.',
   'environmental', 'assigned', 'high', 'Dawis', 6.7320, 125.3680,
   'Dawis Creek, Digos City', 'Roberto Cruz', '0908-777-8888',
   'CENRO', NULL, '2026-08-08 10:30:00', '2026-08-09 11:00:00'),

(9,  'CW-2026-009', 'Damaged Bridge',
   'Wooden footbridge in Ruparan has missing planks and damaged railings. Residents use it daily to cross to the farm areas.',
   'infrastructure', 'assigned', 'high', 'Ruparan', 6.7140, 125.3600,
   'Ruparan Footbridge, Digos City', 'Gloria Mendoza', '0932-987-6543',
   'CEO', NULL, '2026-08-07 14:00:00', '2026-08-09 09:00:00'),

(10, 'CW-2026-010', 'Garbage Collection',
   'Garbage has not been collected in San Agustin for over two weeks. Waste is piling up along the road attracting flies and rodents.',
   'environmental', 'assigned', 'medium', 'San Agustin', 6.7400, 125.3340,
   'San Agustin Barangay Road, Digos City', 'Elena Reyes', '0917-999-0000',
   'CENRO', NULL, '2026-08-07 08:00:00', '2026-08-09 08:30:00'),

-- IN PROGRESS (4)
(11, 'CW-2026-011', 'Blocked Canal',
   'Main irrigation canal in Kansas barangay is blocked by silt buildup. Farmlands are flooding and crops are being damaged.',
   'infrastructure', 'in_progress', 'high', 'Kansas', 6.7220, 125.3290,
   'Kansas Irrigation Canal, Digos City', 'Felix Santos', '0905-123-4567',
   'CEO', NULL, '2026-08-05 07:00:00', '2026-08-09 14:00:00'),

(12, 'CW-2026-012', 'Soil Erosion',
   'Severe soil erosion on the hillside in Kiagot is threatening nearby homes. Soil is visibly sliding during heavy rain events.',
   'environmental', 'in_progress', 'high', 'Kiagot', 6.7180, 125.3840,
   'Kiagot Hillside Area, Digos City', 'Mario Villanueva', '0916-222-3333',
   'CENRO', NULL, '2026-08-04 10:00:00', '2026-08-09 13:00:00'),

(13, 'CW-2026-013', 'Road Sign Damage',
   'Road signs at the intersection in San Jose are completely damaged and unreadable. Causing confusion for motorists and visitors.',
   'infrastructure', 'in_progress', 'low', 'San Jose', 6.7720, 125.3580,
   'San Jose Intersection, Digos City', 'Nora Bautista', '0922-555-6666',
   'CEO', NULL, '2026-08-06 09:00:00', '2026-08-09 15:00:00'),

(14, 'CW-2026-014', 'Overgrown Vegetation',
   'Tall cogon grass and shrubs along the road in Soong are obstructing visibility at a sharp curve. Risk of vehicular accidents.',
   'environmental', 'in_progress', 'medium', 'Soong', 6.7640, 125.3360,
   'Soong Road Curve, Digos City', 'Carlos Lim', '0935-777-8888',
   'CENRO', NULL, '2026-08-06 11:00:00', '2026-08-09 16:00:00'),

-- RESOLVED (6)
(15, 'CW-2026-015', 'Broken Streetlight',
   'Streetlight at the main entrance of Zone I repaired. New LED bulb and wiring replaced. Area is now well-lit at night.',
   'infrastructure', 'resolved', 'low', 'Zone I', 6.7505, 125.3560,
   'Zone I Main Entrance, Digos City', 'Ate Nena Reyes', '0910-111-2222',
   'CEO', '2026-08-08 17:00:00', '2026-08-03 08:00:00', '2026-08-08 17:00:00'),

(16, 'CW-2026-016', 'Illegal Dumping',
   'Illegal dump site near the creek in Tres De Mayo has been cleared. Warning signs installed to prevent recurrence.',
   'environmental', 'resolved', 'medium', 'Tres De Mayo', 6.7250, 125.3520,
   'Tres De Mayo Creek, Digos City', 'Jun Pascual', '0925-333-4444',
   'CENRO', '2026-08-07 16:00:00', '2026-08-02 09:00:00', '2026-08-07 16:00:00'),

(17, 'CW-2026-017', 'Damaged Road',
   'Pothole along the road in Matti has been patched with asphalt. Road surface is now smooth and safe for vehicles.',
   'infrastructure', 'resolved', 'medium', 'Matti', 6.7280, 125.3460,
   'Matti Barangay Road, Digos City', 'Precy Gomez', '0918-444-5555',
   'CEO', '2026-08-09 11:00:00', '2026-08-04 07:00:00', '2026-08-09 11:00:00'),

(18, 'CW-2026-018', 'Garbage Collection',
   'Uncollected garbage in Baracatan has been addressed. Regular collection schedule has been restored.',
   'environmental', 'resolved', 'low', 'Baracatan', 6.7380, 125.3420,
   'Baracatan Barangay, Digos City', 'Tess Aquino', '0939-666-7777',
   'CENRO', '2026-08-08 14:00:00', '2026-08-03 10:00:00', '2026-08-08 14:00:00'),

(19, 'CW-2026-019', 'Blocked Drainage',
   'Drainage along Mahayahay road has been fully cleared and desilted. Water now flows freely and flooding issue has been resolved.',
   'infrastructure', 'resolved', 'high', 'Mahayahay', 6.7690, 125.3480,
   'Mahayahay Road, Digos City', 'Danny Flores', '0927-888-9999',
   'CEO', '2026-08-09 15:00:00', '2026-08-05 08:00:00', '2026-08-09 15:00:00'),

(20, 'CW-2026-020', 'Soil Erosion',
   'Erosion on the slope in Lungag has been stabilized with riprap and vegetation planting. Area is now safe.',
   'environmental', 'resolved', 'high', 'Lungag', 6.7560, 125.3420,
   'Lungag Slope Area, Digos City', 'Minda Soriano', '0913-000-1111',
   'CENRO', '2026-08-10 10:00:00', '2026-08-04 09:00:00', '2026-08-10 10:00:00');

-- ============================================================
-- REPORT PHOTOS (Unsplash URLs — no API key needed)
-- ============================================================
INSERT INTO `report_photos`
  (`id`, `report_id`, `type`, `cloudinary_url`, `cloudinary_public_id`, `uploaded_by`, `created_at`)
VALUES
(1,  1,  'before', 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800&h=500&fit=crop&q=85', 'cw_damaged_road_001',       NULL, '2026-08-10 07:15:00'),
(2,  2,  'before', 'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=800&h=500&fit=crop&q=85', 'cw_illegal_dump_002',       NULL, '2026-08-10 08:30:00'),
(3,  3,  'before', 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=800&h=500&fit=crop&q=85', 'cw_damaged_sidewalk_003',   NULL, '2026-08-10 09:00:00'),
(4,  4,  'before', 'https://images.unsplash.com/photo-1590845947670-c009801ffa74?w=800&h=500&fit=crop&q=85', 'cw_blocked_drainage_004',   NULL, '2026-08-10 10:00:00'),
(5,  5,  'before', 'https://images.unsplash.com/photo-1588392382834-a891154bca4d?w=800&h=500&fit=crop&q=85', 'cw_overgrown_veg_005',      NULL, '2026-08-10 11:00:00'),
(6,  6,  'before', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&h=500&fit=crop&q=85', 'cw_streetlight_006',        NULL, '2026-08-09 18:30:00'),
(7,  7,  'before', 'https://images.unsplash.com/photo-1503516459261-40c66117780a?w=800&h=500&fit=crop&q=85', 'cw_road_gravel_007',        NULL, '2026-08-08 09:00:00'),
(8,  8,  'before', 'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=800&h=500&fit=crop&q=85', 'cw_illegal_dump_008',       NULL, '2026-08-08 10:30:00'),
(9,  9,  'before', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=500&fit=crop&q=85', 'cw_damaged_bridge_009',     NULL, '2026-08-07 14:00:00'),
(10, 10, 'before', 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800&h=500&fit=crop&q=85', 'cw_garbage_010',            NULL, '2026-08-07 08:00:00'),
(11, 11, 'before', 'https://images.unsplash.com/photo-1590845947670-c009801ffa74?w=800&h=500&fit=crop&q=85', 'cw_blocked_canal_011',      NULL, '2026-08-05 07:00:00'),
(12, 12, 'before', 'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=800&h=500&fit=crop&q=85', 'cw_soil_erosion_012',       NULL, '2026-08-04 10:00:00'),
(13, 13, 'before', 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&h=500&fit=crop&q=85', 'cw_road_sign_013',          NULL, '2026-08-06 09:00:00'),
(14, 14, 'before', 'https://images.unsplash.com/photo-1588392382834-a891154bca4d?w=800&h=500&fit=crop&q=85', 'cw_overgrown_veg_014',      NULL, '2026-08-06 11:00:00'),
-- Resolved reports: before + after photos
(15, 15, 'before', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&h=500&fit=crop&q=85', 'cw_streetlight_before_015', NULL, '2026-08-03 08:00:00'),
(16, 15, 'after',  'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=500&fit=crop&q=85', 'cw_streetlight_after_015',  2,    '2026-08-08 17:00:00'),
(17, 16, 'before', 'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=800&h=500&fit=crop&q=85', 'cw_dump_before_016',        NULL, '2026-08-02 09:00:00'),
(18, 16, 'after',  'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=800&h=500&fit=crop&q=85', 'cw_dump_after_016',         3,    '2026-08-07 16:00:00'),
(19, 17, 'before', 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800&h=500&fit=crop&q=85', 'cw_road_before_017',        NULL, '2026-08-04 07:00:00'),
(20, 17, 'after',  'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=800&h=500&fit=crop&q=85', 'cw_road_after_017',         2,    '2026-08-09 11:00:00'),
(21, 18, 'before', 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800&h=500&fit=crop&q=85', 'cw_garbage_before_018',     NULL, '2026-08-03 10:00:00'),
(22, 18, 'after',  'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=800&h=500&fit=crop&q=85', 'cw_garbage_after_018',      3,    '2026-08-08 14:00:00'),
(23, 19, 'before', 'https://images.unsplash.com/photo-1590845947670-c009801ffa74?w=800&h=500&fit=crop&q=85', 'cw_drainage_before_019',    NULL, '2026-08-05 08:00:00'),
(24, 19, 'after',  'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800&h=500&fit=crop&q=85', 'cw_drainage_after_019',     2,    '2026-08-09 15:00:00'),
(25, 20, 'before', 'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=800&h=500&fit=crop&q=85', 'cw_erosion_before_020',     NULL, '2026-08-04 09:00:00'),
(26, 20, 'after',  'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800&h=500&fit=crop&q=85', 'cw_erosion_after_020',      3,    '2026-08-10 10:00:00');

-- ============================================================
-- REPORT ASSIGNMENTS
-- ============================================================
INSERT INTO `report_assignments`
  (`id`, `report_id`, `assigned_to`, `assigned_by`, `priority`, `notes`, `created_at`)
VALUES
(1,  7,  'CEO',   1, 'medium', 'Please prioritize. Barangay road impassable during rain. Coordinate with barangay captain.',     '2026-08-09 10:00:00'),
(2,  8,  'CENRO', 1, 'high',   'Construction waste near creek. Risk of flooding. Immediate cleanup required.',                   '2026-08-09 11:00:00'),
(3,  9,  'CEO',   1, 'high',   'Footbridge used daily by residents. Missing planks are a safety hazard. Urgent repair needed.',  '2026-08-09 09:00:00'),
(4,  10, 'CENRO', 1, 'medium', 'Two weeks without collection. Coordinate with garbage truck schedule for San Agustin.',          '2026-08-09 08:30:00'),
(5,  11, 'CEO',   1, 'high',   'Irrigation canal blocking crops. Farmers reporting losses. Desilting required immediately.',     '2026-08-07 09:00:00'),
(6,  12, 'CENRO', 1, 'high',   'Hillside erosion near homes. Risk of landslide. Assess and recommend stabilization measures.',  '2026-08-06 11:00:00'),
(7,  13, 'CEO',   1, 'low',    'Replace damaged road signs at intersection. Coordinate with traffic management office.',         '2026-08-08 10:00:00'),
(8,  14, 'CENRO', 1, 'medium', 'Clear vegetation along road curve. Safety hazard for motorists.',                                '2026-08-08 12:00:00'),
(9,  15, 'CEO',   1, 'low',    'Replace bulb and check wiring for Zone I entrance streetlight.',                                  '2026-08-04 09:00:00'),
(10, 16, 'CENRO', 1, 'medium', 'Clear dump site and install warning signs. Document for barangay records.',                      '2026-08-03 10:00:00'),
(11, 17, 'CEO',   1, 'medium', 'Patch pothole in Matti. Use cold-mix asphalt for immediate repair.',                             '2026-08-05 08:00:00'),
(12, 18, 'CENRO', 1, 'low',    'Restore garbage collection schedule for Baracatan. Coordinate with driver.',                     '2026-08-04 10:00:00'),
(13, 19, 'CEO',   1, 'high',   'Desilt Mahayahay drainage. Flooding reported after every rain.',                                 '2026-08-06 09:00:00'),
(14, 20, 'CENRO', 1, 'high',   'Stabilize Lungag slope with riprap. Plant grass cover after. Monitor for 30 days.',             '2026-08-05 10:00:00');

-- ============================================================
-- REPORT TIMELINE (full audit trail)
-- ============================================================
INSERT INTO `report_timeline`
  (`id`, `report_id`, `action`, `note`, `from_status`, `to_status`, `performed_by`, `created_at`)
VALUES
(1,  1,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-10 07:15:00'),
(2,  2,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-10 08:30:00'),
(3,  3,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-10 09:00:00'),
(4,  4,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-10 10:00:00'),
(5,  5,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-10 11:00:00'),
(6,  6,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-09 18:30:00'),
(7,  7,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-08 09:00:00'),
(8,  7,  'status_change',    'Report validated by Super Admin.',            'submitted', 'pending',     1,    '2026-08-08 14:00:00'),
(9,  7,  'report_assigned',  'Assigned to City Engineering Office. Priority: Medium.', 'pending', 'assigned', 1, '2026-08-09 10:00:00'),
(10, 8,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-08 10:30:00'),
(11, 8,  'status_change',    'Report validated by Super Admin.',            'submitted', 'pending',     1,    '2026-08-08 16:00:00'),
(12, 8,  'report_assigned',  'Assigned to CENRO. Priority: High.',         'pending',   'assigned',    1,    '2026-08-09 11:00:00'),
(13, 9,  'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-07 14:00:00'),
(14, 9,  'status_change',    'Report validated by Super Admin.',            'submitted', 'pending',     1,    '2026-08-08 08:00:00'),
(15, 9,  'report_assigned',  'Assigned to City Engineering Office. Priority: High.', 'pending', 'assigned', 1, '2026-08-09 09:00:00'),
(16, 10, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-07 08:00:00'),
(17, 10, 'status_change',    'Report validated by Super Admin.',            'submitted', 'pending',     1,    '2026-08-08 09:00:00'),
(18, 10, 'report_assigned',  'Assigned to CENRO. Priority: Medium.',       'pending',   'assigned',    1,    '2026-08-09 08:30:00'),
(19, 11, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-05 07:00:00'),
(20, 11, 'status_change',    'Report validated by Super Admin.',            'submitted', 'pending',     1,    '2026-08-06 08:00:00'),
(21, 11, 'report_assigned',  'Assigned to City Engineering Office. Priority: High.', 'pending', 'assigned', 1, '2026-08-07 09:00:00'),
(22, 11, 'status_change',    'Team deployed to site. Desilting work started.', 'assigned', 'in_progress', 2, '2026-08-09 14:00:00'),
(23, 12, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-04 10:00:00'),
(24, 12, 'status_change',    'Report validated by Super Admin.',            'submitted', 'pending',     1,    '2026-08-05 09:00:00'),
(25, 12, 'report_assigned',  'Assigned to CENRO. Priority: High.',         'pending',   'assigned',    1,    '2026-08-06 11:00:00'),
(26, 12, 'status_change',    'Site assessment done. Riprap installation started.', 'assigned', 'in_progress', 3, '2026-08-09 13:00:00'),
(27, 13, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-06 09:00:00'),
(28, 13, 'status_change',    'Validated. Signs ordered from supplier.',     'submitted', 'pending',     1,    '2026-08-07 10:00:00'),
(29, 13, 'report_assigned',  'Assigned to City Engineering Office. Priority: Low.', 'pending', 'assigned', 1, '2026-08-08 10:00:00'),
(30, 13, 'status_change',    'Road signs delivered. Installation in progress.', 'assigned', 'in_progress', 2, '2026-08-09 15:00:00'),
(31, 14, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-06 11:00:00'),
(32, 14, 'status_change',    'Validated and prioritized.',                  'submitted', 'pending',     1,    '2026-08-07 11:00:00'),
(33, 14, 'report_assigned',  'Assigned to CENRO. Priority: Medium.',       'pending',   'assigned',    1,    '2026-08-08 12:00:00'),
(34, 14, 'status_change',    'Clearing crew dispatched. Work ongoing.',     'assigned',  'in_progress', 3,    '2026-08-09 16:00:00'),
(35, 15, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-03 08:00:00'),
(36, 15, 'status_change',    'Validated.',                                  'submitted', 'pending',     1,    '2026-08-03 14:00:00'),
(37, 15, 'report_assigned',  'Assigned to City Engineering Office.',        'pending',   'assigned',    1,    '2026-08-04 09:00:00'),
(38, 15, 'status_change',    'Electrician scheduled for repair.',           'assigned',  'in_progress', 2,    '2026-08-07 10:00:00'),
(39, 15, 'status_change',    'Streetlight repaired. New LED bulb installed. Area is now well-lit.', 'in_progress', 'resolved', 2, '2026-08-08 17:00:00'),
(40, 16, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-02 09:00:00'),
(41, 16, 'status_change',    'Validated.',                                  'submitted', 'pending',     1,    '2026-08-02 15:00:00'),
(42, 16, 'report_assigned',  'Assigned to CENRO.',                         'pending',   'assigned',    1,    '2026-08-03 10:00:00'),
(43, 16, 'status_change',    'Cleanup crew deployed.',                      'assigned',  'in_progress', 3,    '2026-08-06 08:00:00'),
(44, 16, 'status_change',    'Dump site fully cleared. Warning signs installed.', 'in_progress', 'resolved', 3, '2026-08-07 16:00:00'),
(45, 17, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-04 07:00:00'),
(46, 17, 'status_change',    'Validated.',                                  'submitted', 'pending',     1,    '2026-08-04 14:00:00'),
(47, 17, 'report_assigned',  'Assigned to City Engineering Office.',        'pending',   'assigned',    1,    '2026-08-05 08:00:00'),
(48, 17, 'status_change',    'Repair team on site. Patching started.',      'assigned',  'in_progress', 2,    '2026-08-08 08:00:00'),
(49, 17, 'status_change',    'Pothole patched with asphalt. Road is now smooth.', 'in_progress', 'resolved', 2, '2026-08-09 11:00:00'),
(50, 18, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-03 10:00:00'),
(51, 18, 'status_change',    'Validated.',                                  'submitted', 'pending',     1,    '2026-08-04 09:00:00'),
(52, 18, 'report_assigned',  'Assigned to CENRO.',                         'pending',   'assigned',    1,    '2026-08-04 10:00:00'),
(53, 18, 'status_change',    'Collection schedule restored for Baracatan.', 'assigned', 'resolved',    3,    '2026-08-08 14:00:00'),
(54, 19, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-05 08:00:00'),
(55, 19, 'status_change',    'Validated.',                                  'submitted', 'pending',     1,    '2026-08-05 14:00:00'),
(56, 19, 'report_assigned',  'Assigned to City Engineering Office.',        'pending',   'assigned',    1,    '2026-08-06 09:00:00'),
(57, 19, 'status_change',    'Desilting work started.',                     'assigned',  'in_progress', 2,    '2026-08-08 07:00:00'),
(58, 19, 'status_change',    'Drainage fully cleared. Water flows freely. Flooding resolved.', 'in_progress', 'resolved', 2, '2026-08-09 15:00:00'),
(59, 20, 'report_submitted', 'Report submitted by citizen via mobile app.', NULL,        'submitted',   NULL, '2026-08-04 09:00:00'),
(60, 20, 'status_change',    'Validated.',                                  'submitted', 'pending',     1,    '2026-08-05 09:00:00'),
(61, 20, 'report_assigned',  'Assigned to CENRO.',                         'pending',   'assigned',    1,    '2026-08-05 10:00:00'),
(62, 20, 'status_change',    'Riprap installation started.',                'assigned',  'in_progress', 3,    '2026-08-07 08:00:00'),
(63, 20, 'status_change',    'Slope stabilized with riprap and grass cover. Area is now safe.', 'in_progress', 'resolved', 3, '2026-08-10 10:00:00');

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
INSERT INTO `notifications`
  (`id`, `user_id`, `message`, `type`, `report_id`, `is_read`, `created_at`)
VALUES
-- Super Admin notifications
(1,  1, 'New report submitted: Damaged Road in Aplaya (CW-2026-001).',              'report_submitted', 1,  0, '2026-08-10 07:15:00'),
(2,  1, 'New report submitted: Illegal Dumping in Carmen (CW-2026-002).',           'report_submitted', 2,  0, '2026-08-10 08:30:00'),
(3,  1, 'New report submitted: Damaged Sidewalk in Zone II (CW-2026-003).',         'report_submitted', 3,  0, '2026-08-10 09:00:00'),
(4,  1, 'New report submitted: Blocked Drainage in Magsaysay (CW-2026-004).',       'report_submitted', 4,  0, '2026-08-10 10:00:00'),
(5,  1, 'New report submitted: Overgrown Vegetation in Badiang (CW-2026-005).',     'report_submitted', 5,  0, '2026-08-10 11:00:00'),
(6,  1, 'Report CW-2026-011 updated to In Progress by City Engineering Office.',    'status_update',    11, 1, '2026-08-09 14:00:00'),
(7,  1, 'Report CW-2026-012 updated to In Progress by CENRO.',                      'status_update',    12, 1, '2026-08-09 13:00:00'),
(8,  1, 'Report CW-2026-017 has been resolved by City Engineering Office.',         'report_resolved',  17, 1, '2026-08-09 11:00:00'),
(9,  1, 'Report CW-2026-019 has been resolved by City Engineering Office.',         'report_resolved',  19, 1, '2026-08-09 15:00:00'),
(10, 1, 'Report CW-2026-020 has been resolved by CENRO.',                           'report_resolved',  20, 1, '2026-08-10 10:00:00'),
-- CEO notifications
(11, 2, 'Report CW-2026-007 assigned to your office. Priority: Medium.',            'report_assigned',  7,  0, '2026-08-09 10:00:00'),
(12, 2, 'Report CW-2026-009 assigned to your office. Priority: High.',              'report_assigned',  9,  0, '2026-08-09 09:00:00'),
(13, 2, 'Report CW-2026-015 has been resolved. Great work!',                        'report_resolved',  15, 1, '2026-08-08 17:00:00'),
-- CENRO notifications
(14, 3, 'Report CW-2026-008 assigned to your office. Priority: High.',              'report_assigned',  8,  0, '2026-08-09 11:00:00'),
(15, 3, 'Report CW-2026-010 assigned to your office. Priority: Medium.',            'report_assigned',  10, 0, '2026-08-09 08:30:00'),
(16, 3, 'Report CW-2026-016 has been resolved. Great work!',                        'report_resolved',  16, 1, '2026-08-07 16:00:00');

-- ============================================================
-- RESET AUTO INCREMENT
-- ============================================================
ALTER TABLE `users`              AUTO_INCREMENT = 4;
ALTER TABLE `reports`            AUTO_INCREMENT = 21;
ALTER TABLE `report_photos`      AUTO_INCREMENT = 27;
ALTER TABLE `report_assignments` AUTO_INCREMENT = 15;
ALTER TABLE `report_timeline`    AUTO_INCREMENT = 64;
ALTER TABLE `notifications`      AUTO_INCREMENT = 17;

COMMIT;

-- ============================================================
-- SUMMARY
-- ============================================================
-- Users:              3  (admin, ceo, cenro)
-- Reports:           20  (6 pending, 4 assigned, 4 in_progress, 6 resolved)
-- Report Photos:     26  (before for all 20, after for 6 resolved)
-- Assignments:       14  (all non-pending reports)
-- Timeline entries:  63  (full audit trail)
-- Notifications:     16  (split across 3 users)
--
-- LOGIN CREDENTIALS:
--   admin@civilwatch.gov.ph  / admin123  → Super Admin
--   ceo@civilwatch.gov.ph    / ceo123    → City Engineering Office
--   cenro@civilwatch.gov.ph  / cenro123  → CENRO
-- ============================================================
