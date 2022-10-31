//
//  EventTrailTestTests.m
//  EventTrailTestTests
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <XCTest/XCTest.h>
#import "MMEventTrailProvider.h"


@interface EventTrailTestTests : XCTestCase

@end

@implementation EventTrailTestTests {
    id<MMEventTrailStore> store;
}

- (void)setUp {
    NSLog(@">> SetUp");
    
    self->store = [MMEventTrailProvider sharedEventTrailStore];
    
    [[MMEventTrailProvider sharedIntegrations] enumerateObjectsUsingBlock:^(id<MMEventTrailIntegration>  _Nonnull integration, NSUInteger idx, BOOL * _Nonnull stop) {
        [integration start];
    }];
    
    [self->store deleteAllTrails];
    [self->store deleteAllEvents];
}

- (void)tearDown {
    NSLog(@">> TearDown");
}

- (void)testSaveTrail {
    for (NSInteger i = 0; i < 5; i ++) {
        MMTrail *trail = [MMTrail new];
        trail.trailId = [NSString stringWithFormat:@"trail-id-%ld", (long)i];
        trail.trailSession = [NSString stringWithFormat:@"trail-session-id-%d", (i < 3) ? 0 : 1];
        trail.level = i;
        
        id<SqliteExecutionResult> result = [self->store saveTrail:trail];
        if ([result isMemberOfClass:[SqliteExecutionFailure class]]) {
            SqliteExecutionFailure *resultFailure = (SqliteExecutionFailure *) result;
            NSString *errorString = [NSString stringWithFormat:@"Error: %@",resultFailure.exception.reason];
            NSLog(@"%@", errorString);
            XCTFail();
        }
        
        if ([result isMemberOfClass:[SqliteExecutionSuccess class]]) {
            NSLog(@"[TrailEvent] save trail: successfully - id: %@ | session: %@ | level: %ld", trail.trailId, trail.trailSession, (long)trail.level);
        }
    }
}


- (void)testSaveEvent {
    for (NSInteger i = 0; i < 20; i ++) {
        MMTrailEvent *event = [MMTrailEvent new];
        event.eventId = [NSString stringWithFormat:@"event-id-%@",[[NSUUID UUID] UUIDString]];
        event.trailId = [NSString stringWithFormat:@"trail-id-%ld",i%5];
        event.eventName = [NSString stringWithFormat:@"event_name_%ld", (long)i];
        
        id<SqliteExecutionResult> result = [self->store saveEvent:event];
        if ([result isMemberOfClass:[SqliteExecutionFailure class]]) {
            SqliteExecutionFailure *resultFailure = (SqliteExecutionFailure *) result;
            NSString *errorString = [NSString stringWithFormat:@"Error: %@",resultFailure.exception.reason];
            NSLog(@"%@", errorString);
            XCTFail();
        }
        
        if ([result isMemberOfClass:[SqliteExecutionSuccess class]]) {
            NSLog(@"[TrailEvent] save event successfully - id: %@ | trailId: %@ | eventName: %@ ", event.eventId, event.trailId, event.eventName);
        }
    }
}

- (void)testQueryAllTrails {
    [self testSaveTrail];
    
    id<SqliteExecutionResult> result = [self->store queryAllTrails];
    
    if ([result isMemberOfClass:[SqliteExecutionFailure class]]) {
        SqliteExecutionFailure *resultFailure = (SqliteExecutionFailure *) result;
        NSString *errorString = [NSString stringWithFormat:@"Error: %@",resultFailure.exception.reason];
        NSLog(@"%@", errorString);
        XCTFail();
    }
    
    if ([result isMemberOfClass:[SqliteTrailQuerySuccess class]]) {
        SqliteTrailQuerySuccess *resultSuccess = (SqliteTrailQuerySuccess *)result;
        for (MMTrail *trail in resultSuccess.data) {
            NSLog(@"[TrailEvent] queried trail: %@ - %@ - %ld", trail.trailId, trail.trailSession, (long)trail.level);
        }
    }
}

- (void)testQueryEventsBySession {
    [self testSaveTrail];
    [self testSaveEvent];
    
    id<SqliteExecutionResult> result = [self->store queryEventsBySessionIds:@[@"trail-session-id-1", @"trail-session-id-0"]];
    if ([result isMemberOfClass:[SqliteExecutionFailure class]]) {
        SqliteExecutionFailure *resultFailure = (SqliteExecutionFailure *) result;
        NSString *errorString = [NSString stringWithFormat:@"Error: %@",resultFailure.exception.reason];
        NSLog(@"%@", errorString);
        XCTFail();
    }
    
    if ([result isMemberOfClass:[SqliteTrailEventQuerySuccess class]]) {
        SqliteTrailEventQuerySuccess *resultSuccess = (SqliteTrailEventQuerySuccess *)result;
        for (MMTrailEvent *event in resultSuccess.data) {
            NSLog(@"[TrailEvent] queried event: %@ - %@ - %@", event.eventId, event.trailId, event.eventName);
        }
    }
}

- (void)testDeleteEventsByTrailIds {
    [self testSaveTrail];
    [self testSaveEvent];
    
    [self->store deleteEventsByTrailIds:@[@"trail-id-0", @"trail-id-1", @"trail-id-10"]];
    
    id<SqliteExecutionResult> result = [self->store queryEventsBySessionIds:@[@"trail-session-id-1", @"trail-session-id-0"]];
    if ([result isMemberOfClass:[SqliteExecutionFailure class]]) {
        SqliteExecutionFailure *resultFailure = (SqliteExecutionFailure *) result;
        NSString *errorString = [NSString stringWithFormat:@"Error: %@",resultFailure.exception.reason];
        NSLog(@"%@", errorString);
        XCTFail();
    }
    
    if ([result isMemberOfClass:[SqliteTrailEventQuerySuccess class]]) {
        SqliteTrailEventQuerySuccess *resultSuccess = (SqliteTrailEventQuerySuccess *)result;
        for (MMTrailEvent *event in resultSuccess.data) {
            if ([event.trailId  isEqual: @"trail-id-0"] || [event.trailId  isEqual: @"trail-id-1"]) {
                XCTFail();
            }
            NSLog(@"[TrailEvent] queried event: %@ - %@ - %@", event.eventId, event.trailId, event.eventName);
        }
    }
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
