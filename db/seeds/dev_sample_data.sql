-- Development sample data. Not a migration: run it by hand on an empty database.
INSERT INTO projects (name, developer, location) VALUES
  ('Marina Heights Tower B', 'Al Noor Developments', 'Dubai Marina'),
  ('Palm Residences', 'Coastline Properties', 'Palm Jumeirah');

INSERT INTO units (project_id, unit_number, floor) VALUES
  (1, '401', 4),
  (1, '402', 4),
  (1, '1203', 12),
  (2, 'V-07', NULL),
  (2, 'V-12', NULL);

INSERT INTO handover_items (project_id, unit_id, location, description, trade, severity, status, raised_at, resolved_at) VALUES
  (1, 1,    'Master bedroom', 'Hairline crack above window frame',     'civil',      'medium', 'open',        now() - interval '6 days', NULL),
  (1, 2,    'Kitchen',        'Sink drain leaking under cabinet',      'plumbing',   'high',   'in_progress', now() - interval '4 days', NULL),
  (1, 2,    'Living room',    'Socket near balcony door not working',  'electrical', 'medium', 'fixed',       now() - interval '9 days', now() - interval '2 days'),
  (1, NULL, 'Lobby',          'Cracked floor tile by main entrance',   'civil',      'low',    'open',        now() - interval '3 days', NULL),
  (2, 4,    'Garden',         'Irrigation pipe damaged near boundary', 'plumbing',   'medium', 'open',        now() - interval '1 day',  NULL);