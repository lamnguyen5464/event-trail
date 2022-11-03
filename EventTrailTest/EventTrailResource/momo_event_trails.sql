DROP TABLE IF EXISTS TRAILS;
DROP TABLE IF EXISTS TRAIL_EVENTS;


CREATE TABLE IF NOT EXISTS TRAILS(
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 trail_id TEXT UNIQUE,
 trail_session TEXT,
 tracking_session_id TEXT,
 parent_trail_id TEXT,
 level INTEGER,
 create_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TRAIL_EVENTS (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 event_id TEXT UNIQUE,
 trail_id TEXT,
 event_name TEXT,
 event_bundle TEXT,
 create_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Sample data trails

INSERT INTO TRAILS(trail_id, trail_session, tracking_session_id, parent_trail_id, level)
VALUES ("trail_id_01", "trail_session_001", "tracking_session_id", "parent_trail_id", 0);

INSERT INTO TRAILS(trail_id, trail_session, tracking_session_id, parent_trail_id, level)
VALUES ("trail_id_02", "trail_session_001", "tracking_session_id", "parent_trail_id", 1);

INSERT INTO TRAILS(trail_id, trail_session, tracking_session_id, parent_trail_id, level)
VALUES ("trail_id_03", "trail_session_001", "tracking_session_id", "parent_trail_id", 2);

INSERT INTO TRAILS(trail_id, trail_session, tracking_session_id, parent_trail_id, level)
VALUES ("trail_id_04", "current_session", "tracking_session_id", "parent_trail_id", 0);


-- Sample data trail_events

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_01", "trail_id_01", "event_1", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_02", "trail_id_01", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_03", "trail_id_01", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_04", "trail_id_01", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_05", "trail_id_01", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_06", "trail_id_01", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_07", "trail_id_01", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_08", "trail_id_01", "this_is_name", "{}");

-- Switch to trail 2

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_09", "trail_id_02", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_10", "trail_id_02", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_11", "trail_id_02", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_12", "trail_id_02", "this_is_name", "{}");

-- Switch to trail 3

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_13", "trail_id_03", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_14", "trail_id_03", "this_is_name", "{}");

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_15", "trail_id_03", "close_trail", "{}");

-- Back to trail 2

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_16", "trail_id_02", "this_is_name", "{}");

-- Back to trail 1

INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_17", "trail_id_01", "this_is_name", "{}");


INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle)
VALUES ("event_id_18", "trail_id_04", "this_is_name", "{}");




-- Query event in session 
SELECT TRAIL_EVENTS.* FROM TRAIL_EVENTS JOIN TRAILS ON TRAIL_EVENTS.trail_id = TRAILS.trail_id WHERE TRAILS.trail_session IN ("current_session") ORDER BY id;


-- Query events not in sessions
SELECT TRAIL_EVENTS.* FROM TRAIL_EVENTS JOIN TRAILS ON TRAIL_EVENTS.trail_id = TRAILS.trail_id WHERE TRAILS.trail_session NOT IN ("current_session") ORDER BY id;

-- Query trails in NOT in session
SELECT TRAILS.* FROM TRAILS  WHERE TRAILS.trail_session NOT IN ("current_session") ORDER BY id;


-- Query event with trail_id
-- SELECT * FROM TRAIL_EVENTS WHERE trail_id in ("trail_id_01", "") ORDER BY create_at ASC;

-- -- Uses this query instead for perfomance
-- SELECT * FROM TRAIL_EVENTS WHERE trail_id in ("trail_id_01", "") ORDER BY id ASC;

-- Delete event with event_ids
DELETE FROM TRAIL_EVENTS WHERE event_id IN ("event_id_01", "event_id_02");

-- -- Delete event with trails_id
-- DELETE FROM TRAIL_EVENTS WHERE trail_id IN ("trail_id_01", "trail_id_02");

-- Delete trail with trail_ids
DELETE FROM TRAILS WHERE trail_id IN ("trail_id_02", "trail_id_03");

-- -- Select current events with trails
-- SELECT TRAILS.id as trail_id, TRAIL_EVENTS.id as event_id FROM TRAILS JOIN TRAIL_EVENTS ORDER BY TRAILS.id; -- ???

-- -- Select all events
-- SELECT * FROM TRAIL_EVENTS;

-- -- 
-- SELECT TRAILS.id, TRAILS.trail_id,  TRAILS.trail_session, TRAILS.tracking_session_id, TRAILS.app_id, TRAILS.level, TRAILS.entry_scope, TRAILS.entry_type, TRAILS.entry_app_id_trigger, TRAILS.entry_screen_name, TRAILS.entry_parent_trail_id, TRAILS.exit_by, TRAILS.exit_screen FROM TRAILS;

-- SELECT TRAIL_EVENTS.event_id, TRAIL_EVENTS.trail_id, TRAIL_EVENTS.event_name, TRAIL_EVENTS.event_bundle FROM TRAIL_EVENTS JOIN TRAILS ON TRAIL_EVENTS.trail_id = TRAILS.trail_id WHERE TRAILS.trail_session NOT in ("trail_session_001")