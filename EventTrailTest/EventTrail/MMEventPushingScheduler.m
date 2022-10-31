//
//  MMEventPushingScheduler.m
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import "MMEventPushingScheduler.h"

@implementation MMEventPushingScheduler 

int const MMAnalyticsDefaultFlushIntervalMillis = 15000;

- (instancetype)initWithStore:(id<MMEventTrailStore>)store
            eventTrailPusher:(MMEventTrailPusher *)pusher {
    self = [super init];
    if (self) {
        self->store = store;
        self->pusher = pusher;
        self->taskQueue = dispatch_queue_create("EventTrail.MMEventPushingScheduler.taskQueue", NULL);
    }
    return self;
}

- (void)start {
    if (self->flushTimer) {
        return;
    }
    double defaultFlushIntervalInSeconds = MMAnalyticsDefaultFlushIntervalMillis / 1000;
    
    __weak __typeof(self) weakSelf = self;
    self->flushTimer = [MMUtils startTimer:self->taskQueue withInterval:defaultFlushIntervalInSeconds block:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"[TrailEvent] start flush events");
        [strongSelf flushEvents:strongSelf];
    }];
}

- (void)stop {
    [MMUtils stopTimer:self->flushTimer];
    self->flushTimer = nil;
}

- (void)flushEvents:(MMEventPushingScheduler *)_self {
    
    NSArray<MMStorePersistedTrailEvent *> *events = [_self queryEvents:_self];
    if (!events) {
        return;
    }
    
    [_self->pusher pushEvents:events];
    // TODO: handle pushing status
    
    NSMutableArray<NSString *> *eventIds = [NSMutableArray new];
    for (MMTrailEvent *event in events) {
        [eventIds addObject:event.eventId];
    }
    
    [_self->store deleteEventsByEventIds:eventIds];
   
}

- (NSArray<MMStorePersistedTrailEvent *> *)queryEvents:(MMEventPushingScheduler *)_self {
    NSArray<NSString *> *sessionIds = [NSArray arrayWithObject:[MMAppSession getCurrentAppSession]];
    id<SqliteExecutionResult> result = [_self->store queryEventsBySessionIds:sessionIds];
    if ([result isMemberOfClass:[SqliteTrailEventQuerySuccess class]]) {
        SqliteTrailEventQuerySuccess *resultSuccess = (SqliteTrailEventQuerySuccess *)result;
        return resultSuccess.data;
    } else {
        return nil;
    }
}

@end
