INSERT INTO locations (location_id, name, city, contact_name) VALUES
    (1, 'Sofia Office', 'Sofia', 'Georgina Georgieva'),
    (2, 'Plovdiv Office', 'Plovdiv', 'Ivan Ivanov');
 
INSERT INTO devices (device_id, hostname, device_type, ip_address, mac_address, location_id, status, last_checked_at) VALUES 
    (1, 'sofia-rtr-01', 'router', '10.10.0.1', '00:1A:2B:3C:4D:01', 1, 'active', '2026-03-27T09:15:00Z'),  
    (2, 'sofia-sw-01', 'switch', '10.10.0.10', '00:1A:2B:3C:4D:02', 1, 'active', '2026-03-28T09:50:00Z'),
    (3, 'plovdiv-ap-01', 'access_point', '10.20.0.25', '00:1A:2B:3C:4D:03', 2, 'maintenance', '2026-05-30T15:00:00Z'),
    (4, 'sofia-files-01', 'server', '10.10.0.50', '00:1A:2B:3C:4D:04', 1, 'active', '2026-06-01T10:00:00Z');
 
INSERT INTO incidents (device_id, opened_at, resolved_at, severity, summary) VALUES 
    (3, '2026-05-25T08:00:00Z', NULL, 'high', 'Access point drops clients intermittently'),
    (4, '2026-05-20T13:10:00Z', '2026-05-20T15:40:00Z', 'medium', 'File-share authentication delay'),
    (1, '2026-03-25T10:00:00Z', '2026-03-25T10:32:00Z', 'low', 'Scheduled routing table verification');
