//
//  MMSqliteEventTrailStore.m
//  MoMoPlatform
//
//  Created by lam.nguyen5 on 10/17/22.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "MMSqliteEventTrailStore.h"

@implementation MMSqliteEventTrailStore


- (instancetype) init {
    self = [super init];
    if (self) {
        //    self->logger = [SharedProviders.shared providesMoMoLogger];
        [self createDatabase];
        [self createSchema:SQLITE_CREATE_TABLE_EVENT_STATEMENT];
        [self createSchema:SQLITE_CREATE_TABLE_TRAIL_STATEMENT];
    }
    return self;
}

- (id<SqliteExecutionResult>)saveEvent:(MMStorePersistedTrailEvent *)event {
    
    
    NSLog(@"[TrailEvent] save event: eventName: %@ | trailId: %@ | bundle: %@", event.eventName, event.trailId, event.eventBundle);
    
    NSString *insertSQLString = [NSString stringWithFormat:@"INSERT INTO TRAIL_EVENTS(event_id, trail_id, event_name, event_bundle) VALUES ('%@', '%@', '%@', '%@');", event.eventId, event.trailId, event.eventName, event.eventBundle];
    
    const char* insertSQL = [insertSQLString UTF8String];
    sqlite3_stmt *insertStmt = nil;
    id<SqliteExecutionResult> result;
    if (sqlite3_prepare_v2(self->database, insertSQL, -1, &insertStmt, nil) == SQLITE_OK) {
        if (sqlite3_step(insertStmt) == SQLITE_DONE) {
            result = [SqliteExecutionSuccess shared];
        } else {
            NSLog(@"[TrailEvent] Failed to save event: %@ %@ %@ %@", event.eventId, event.trailId, event.eventName, event.eventBundle);
            result = [[SqliteExecutionFailure alloc] initWithException:[self createSqliteExceptionWithReason:[NSString stringWithFormat:@"[TrailEvent] Failed to save event: %@", event.eventBundle]]];
        }
    } else {
        NSLog(@"[TrailEvent] Wrong insert statement: %@", event.eventBundle);
        result = [[SqliteExecutionFailure alloc] initWithException:[self createSqliteExceptionWithReason:[NSString stringWithFormat:@"[TrailEvent] Wrong insert statement: %@", insertSQLString]]];
    }
    sqlite3_finalize(insertStmt);
    return result;
}

- (id<SqliteExecutionResult>)saveTrail:(MMTrail *)trail {
    NSString *insertSQLString = [NSString stringWithFormat:@"INSERT INTO TRAILS(trail_id, trail_session, tracking_session_id, parent_trail_id, level) VALUES ('%@', '%@', '%@', '%@', '%ld');", trail.trailId, trail.trailSession, trail.trackingSessionId, trail.parentTrailId, (long)trail.level];
    NSLog(@"[TrailEvent] save trail: %@", insertSQLString);
    
    const char* insertSQL = [insertSQLString UTF8String];
    sqlite3_stmt *insertStmt = nil;
    id<SqliteExecutionResult> result;
    if (sqlite3_prepare_v2(self->database, insertSQL, -1, &insertStmt, nil) == SQLITE_OK) {
        if (sqlite3_step(insertStmt) == SQLITE_DONE) {
            result = [SqliteExecutionSuccess shared];
        } else {
            result = [[SqliteExecutionFailure alloc] initWithException:[self createSqliteExceptionWithReason:[NSString stringWithFormat:@"[TrailEvent] Failed to save trail: %@", trail.trailId]]];
        }
    } else {
        result = [[SqliteExecutionFailure alloc] initWithException:[self createSqliteExceptionWithReason:[NSString stringWithFormat:@"[TrailEvent] Wrong insert statement: %@", insertSQLString]]];
    }
    sqlite3_finalize(insertStmt);
    return result;
}

- (id<SqliteExecutionResult>)queryEventsBySessionIds:(NSArray<NSString *> *)sessionIds {
    NSMutableArray<NSString *> *parsedSessionIds = [NSMutableArray new];
     
    for (NSString *sessionId in sessionIds) {
        [parsedSessionIds addObject:[NSString stringWithFormat:@"'%@'", sessionId]];
    }
    
    NSString *querySQLString = [NSString stringWithFormat:@"SELECT TRAIL_EVENTS.* FROM TRAIL_EVENTS JOIN TRAILS ON TRAIL_EVENTS.trail_id = TRAILS.trail_id WHERE TRAILS.trail_session IN (%@) ORDER BY id", [parsedSessionIds componentsJoinedByString:@", "]];
    
    return [self queryEventsByStatement:querySQLString];
}

- (id<SqliteExecutionResult>)queryEventsNotInSessionIds:(NSArray<NSString *> *)sessionIds {
    NSMutableArray<NSString *> *parsedSessionIds = [NSMutableArray new];
     
    for (NSString *sessionId in sessionIds) {
        [parsedSessionIds addObject:[NSString stringWithFormat:@"'%@'", sessionId]];
    }
    
    NSString *querySQLString = [NSString stringWithFormat:@"SELECT TRAIL_EVENTS.* FROM TRAIL_EVENTS JOIN TRAILS ON TRAIL_EVENTS.trail_id = TRAILS.trail_id WHERE TRAILS.trail_session NOT IN (%@) ORDER BY id", [parsedSessionIds componentsJoinedByString:@", "]];
    
    return [self queryEventsByStatement:querySQLString];
}

- (id<SqliteExecutionResult>)queryTrailsNotInSessionIds:(NSArray<NSString *> *)sessionIds {
    NSMutableArray<NSString *> *parsedSessionIds = [NSMutableArray new];
     
    for (NSString *sessionId in sessionIds) {
        [parsedSessionIds addObject:[NSString stringWithFormat:@"'%@'", sessionId]];
    }
    
    NSString *querySQLString = [NSString stringWithFormat:@"SELECT TRAILS.* FROM TRAILS  WHERE TRAILS.trail_session NOT IN (%@) ORDER BY id", [parsedSessionIds componentsJoinedByString:@", "]];
    
    return [self queryTrailsByStatement:querySQLString];
}


- (id<SqliteExecutionResult>)queryAllEvents {
    return [self queryEventsByStatement:@"SELECT * FROM TRAIL_EVENTS ORDER BY id"];
    
}
- (id<SqliteExecutionResult>)queryAllTrails {
    return [self queryTrailsByStatement:@"SELECT TRAILS.* FROM TRAILS;"];
}


- (id<SqliteExecutionResult>)deleteEventsByEventIds:(NSArray<NSString *> *)eventIds {
    NSMutableArray<NSString *> *parsedEventIds = [NSMutableArray new];
     
    for (NSString *eventId in eventIds) {
        [parsedEventIds addObject:[NSString stringWithFormat:@"'%@'", eventId]];
    }
    
    NSString *deleteSQLString = [NSString stringWithFormat:@"DELETE FROM TRAIL_EVENTS WHERE event_id IN (%@);", [parsedEventIds componentsJoinedByString:@", "]];
    
    return [self deleteByStatement:deleteSQLString];
}
- (id<SqliteExecutionResult>)deleteEventsByTrailIds:(NSArray<NSString *> *)trailIds {
    NSMutableArray<NSString *> *parsedTrailIds = [NSMutableArray new];
     
    for (NSString *trailId in trailIds) {
        [parsedTrailIds addObject:[NSString stringWithFormat:@"'%@'", trailId]];
    }
    
    NSString *deleteSQLString = [NSString stringWithFormat:@"DELETE FROM TRAIL_EVENTS WHERE trail_id IN (%@);", [parsedTrailIds componentsJoinedByString:@", "]];
    
    return [self deleteByStatement:deleteSQLString];
}
- (id<SqliteExecutionResult>)deleteTrailsByTrailIds:(NSArray<NSString *> *)trailIds {
    NSMutableArray<NSString *> *parsedTrailIds = [NSMutableArray new];
     
    for (NSString *trailId in trailIds) {
        [parsedTrailIds addObject:[NSString stringWithFormat:@"'%@'", trailId]];
    }
    
    NSString *deleteSQLString = [NSString stringWithFormat:@"DELETE FROM TRAILS WHERE trail_id IN (%@);", [parsedTrailIds componentsJoinedByString:@", "]];
    
    return [self deleteByStatement:deleteSQLString];
}

- (id<SqliteExecutionResult>)deleteAllEvents {
    return [self deleteByStatement:[NSString stringWithFormat:@"DELETE FROM TRAIL_EVENTS;"]];
}
- (id<SqliteExecutionResult>)deleteAllTrails {
    return [self deleteByStatement:[NSString stringWithFormat:@"DELETE FROM TRAILS;"]];
}


#pragma mark -
- (id<SqliteExecutionResult>)queryEventsByStatement:(NSString *)querySQLString {
    const char* querySQL = [querySQLString UTF8String];
    sqlite3_stmt *queryStmt = nil;
    id<SqliteExecutionResult> result;
    if (sqlite3_prepare_v2(self->database, querySQL, -1, &queryStmt, nil) == SQLITE_OK) {
        NSMutableArray<MMStorePersistedTrailEvent *> *listEvents = [NSMutableArray new];
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            MMStorePersistedTrailEvent *event = [MMStorePersistedTrailEvent new];
            event.eventId = [self convertFrom:sqlite3_column_text(queryStmt, 1)];
            event.trailId = [self convertFrom:sqlite3_column_text(queryStmt, 2)];
            event.eventName = [self convertFrom:sqlite3_column_text(queryStmt, 3)];
            event.eventBundle = [self convertFrom:sqlite3_column_text(queryStmt, 4)];
            [listEvents addObject:event];
        }
        result = [[SqliteTrailEventQuerySuccess alloc] initWithData:listEvents];
    } else {
        result = [[SqliteExecutionFailure alloc] initWithException:[self createSqliteExceptionWithReason:[NSString stringWithFormat:@"[TrailEvent] Wrong insert statement: %@", querySQLString]]];
    }
    sqlite3_finalize(queryStmt);
    return result;
}

- (id<SqliteExecutionResult>)queryTrailsByStatement:(NSString *)querySQLString {
    const char* querySQL = [querySQLString UTF8String];
    sqlite3_stmt *queryStmt = nil;
    id<SqliteExecutionResult> result;
    if (sqlite3_prepare_v2(self->database, querySQL, -1, &queryStmt, nil) == SQLITE_OK) {
        NSMutableArray<MMTrail *> *listTrails = [NSMutableArray new];
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            MMTrail *trail = [MMTrail new];
            trail.trailId = [self convertFrom:sqlite3_column_text(queryStmt, 1)];
            trail.trailSession = [self convertFrom:sqlite3_column_text(queryStmt, 2)];
            trail.trackingSessionId = [self convertFrom:sqlite3_column_text(queryStmt, 3)];
            trail.parentTrailId = [self convertFrom:sqlite3_column_text(queryStmt, 4)];
            trail.level = sqlite3_column_int(queryStmt, 5);
            [listTrails addObject:trail];
        }
        result = [[SqliteTrailQuerySuccess alloc] initWithData:listTrails];
    } else {
        result = [[SqliteExecutionFailure alloc] initWithException:[self createSqliteExceptionWithReason:[NSString stringWithFormat:@"[TrailEvent] Wrong insert statement: %@", querySQLString]]];
    }
    sqlite3_finalize(queryStmt);
    return result;
}

- (id<SqliteExecutionResult>)deleteByStatement:(NSString *)statement {
    const char* clearSQL = [statement UTF8String];
    sqlite3_stmt *clearStmt = nil;
    id<SqliteExecutionResult> result;
    if (sqlite3_prepare_v2(self->database, clearSQL, -1, &clearStmt, nil) == SQLITE_OK) {
        if (sqlite3_step(clearStmt) == SQLITE_DONE) {
            result = [SqliteExecutionSuccess shared];
        } else {
            result = [[SqliteExecutionFailure alloc] initWithException:[self createSqliteExceptionWithReason:[NSString stringWithFormat:@"[TrailEvent] Failed to clear with statement: %@", statement]]];
        }
    } else {
        result = [[SqliteExecutionFailure alloc] initWithException:[self createSqliteExceptionWithReason:[NSString stringWithFormat:@"[TrailEvent] Wrong sqlite statement: %@", statement]]];
    }
    sqlite3_finalize(clearStmt);
    return result;
}

NSString* const SQLITE_CREATE_TABLE_EVENT_STATEMENT = @"CREATE TABLE IF NOT EXISTS TRAIL_EVENTS (id INTEGER PRIMARY KEY AUTOINCREMENT, event_id TEXT UNIQUE, trail_id TEXT NOT NULL, event_name TEXT NOT NULL, event_bundle TEXT, create_at DATETIME DEFAULT CURRENT_TIMESTAMP);";

NSString* const SQLITE_CREATE_TABLE_TRAIL_STATEMENT = @"CREATE TABLE IF NOT EXISTS TRAILS( id INTEGER PRIMARY KEY AUTOINCREMENT, trail_id TEXT UNIQUE, trail_session TEXT, tracking_session_id TEXT, parent_trail_id TEXT, level INTEGER, create_at DATETIME DEFAULT CURRENT_TIMESTAMP);";

- (void) createDatabase {
    if (sqlite3_open_v2([self getDatabsePath], &(self->database), SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK) {
        //    [logger iMessage:@"Create trail_event db successfully!" throwable:nil tag:@"EventTrail"];
        NSLog(@"[TrailEvent] Create trail_event db successfully!");
    } else {
        //    [logger eMessage:@"Failed to create trail_event db!" throwable:nil tag:@"EventTrail"];
        NSLog(@"[TrailEvent]Failed to create trail_event db !");
    }
}

- (void) createSchema:(NSString *)statement {
    const char* createTableSQL = [statement UTF8String];
    sqlite3_stmt *createTableStmt = nil;
    if (sqlite3_prepare_v2(self->database, createTableSQL, -1, &createTableStmt, nil) == SQLITE_OK) {
        if (sqlite3_step(createTableStmt) == SQLITE_DONE) {
            
            //      [self->logger eMessage:@"DB trail_event is already created" throwable:NULL tag:@"EventTrail"];
            NSLog(@"[TrailEvent] DB trail_event is already created");
        } else {
            //      [self->logger eMessage:@"Failed to create DB trail_event" throwable:NULL tag:@"EventTrail"];
            NSLog(@"[TrailEvent] DB trail_event is already created");
        }
    } else {
        // wrong statement
    }
    sqlite3_finalize(createTableStmt);
}

- (const char *) getDatabsePath {
    NSURL *urlDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask][0];
    NSURL *fileUrl = [urlDirectory URLByAppendingPathComponent:@"trail_events.sqlite"];
    return [[fileUrl path] UTF8String];
}

- (NSException *)createSqliteExceptionWithReason:(NSString *)reason {
    return [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

- (NSString *)convertFrom:(const unsigned char *)characters {
    return [NSString stringWithUTF8String:(char *)characters];
}

@end
