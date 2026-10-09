PRAGMA foreign_keys = ON;   # Enforces foreign keys who link one table to another
 
CREATE TABLE locations ( 
    location_id INTEGER PRIMARY KEY,   
    name TEXT NOT NULL UNIQUE, 
    city TEXT NOT NULL, 
    contact_name TEXT NOT NULL 
); 
 
CREATE TABLE devices ( 
    device_id INTEGER PRIMARY KEY,  
    hostname TEXT NOT NULL UNIQUE, 
    device_type TEXT NOT NULL CHECK (device_type IN ('router', 'switch', 'access_point', 'server', 'workstation')), 
    ip_address TEXT NOT NULL UNIQUE, 
    mac_address TEXT NOT NULL UNIQUE, 
    location_id INTEGER NOT NULL REFERENCES locations(location_id), 
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'maintenance', 'retired')), 
    last_checked_at TEXT  # ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ)
); 
 
CREATE TABLE incidents ( 
    incident_id INTEGER PRIMARY KEY, 
    device_id INTEGER NOT NULL REFERENCES devices(device_id), 
    opened_at TEXT NOT NULL, 
    resolved_at TEXT, 
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')), 
    summary TEXT NOT NULL, 
    CHECK (resolved_at IS NULL OR resolved_at >= opened_at)   # Data quality rule
); 
 
CREATE VIEW device_health AS   # The view is based on the following query
SELECT 
    d.hostname, d
    d.device_type, 
    d.ip_address, 
    l.name AS location, 
    d.status, 
    COUNT(i.incident_id) AS open_incidents 
FROM devices d 
JOIN locations l ON l.location_id = d.location_id    # Joins every device to its location
LEFT JOIN incidents i ON i.device_id = d.device_id AND i.resolved_at IS NULL   # Joins open incidents to devices
GROUP BY d.device_id;   # Groups all matching incident rows under each device not rows under incidents 
 
CREATE TRIGGER prevent_incident_on_retired_device 
BEFORE INSERT ON incidents 
FOR EACH ROW 
WHEN (SELECT status FROM devices WHERE device_id = NEW.device_id) = 'retired' 
BEGIN 
    SELECT RAISE(ABORT, 'Cannot create an incident for a retired device'); 
END; 
 