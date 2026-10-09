# The technician's device-health dashboard
SELECT * FROM device_health ORDER BY open_incidents DESC, hostname; 
 
# Unresolved incidents with their affected device and location 
SELECT i.incident_id, i.severity, i.opened_at, d.hostname, l.name AS location, i.summary 
FROM incidents i 
JOIN devices d ON d.device_id = i.device_id 
JOIN locations l ON l.location_id = d.location_id 
WHERE i.resolved_at IS NULL 
ORDER BY CASE i.severity 
    WHEN 'critical' THEN 1 WHEN 'high' THEN 2 WHEN 'medium' THEN 3 ELSE 4 END; 
 
# Incident count and average resolution time by device type
SELECT 
    d.device_type, 
    COUNT(i.incident_id) AS incident_count, 
    ROUND(AVG((julianday(i.resolved_at) - julianday(i.opened_at)) * 24 * 60), 1) AS avg_resolution_minutes 
FROM devices d 
LEFT JOIN incidents i ON i.device_id = d.device_id AND i.resolved_at IS NOT NULL 
GROUP BY d.device_type 
ORDER BY incident_count DESC; 
 
# Devices that have not been checked within the last 24 hours from a chosen reference time
SELECT hostname, ip_address, last_checked_at 
FROM devices 
WHERE last_checked_at < '2026-01-05T12:00:00Z'
   OR last_checked_at IS NULL; 
 