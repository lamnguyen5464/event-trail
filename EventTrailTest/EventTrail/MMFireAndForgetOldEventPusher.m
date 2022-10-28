//
//  MMFireAndForgetOldEventPusher.m
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import "MMFireAndForgetOldEventPusher.h"

@implementation MMFireAndForgetOldEventPusher 

- (instancetype)initWithStore:(id<MMEventTrailStore>)store {
    self = [super init];
    if (self) {
        self->store = store;
        self->taskQueue = dispatch_queue_create("EventTrail.MMFireAndForgetOldEventPusher.taskQueue", NULL);
    }
    return self;
}

- (void)start {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self->taskQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        id<SqliteExecutionResult> result = [strongSelf->store queryEventsNotInSessionIds:[NSArray arrayWithObject:[MMAppSession getCurrentAppSession]]];
        
        if ([result isMemberOfClass:[SqliteTrailEventQuerySuccess class]]) {
            SqliteTrailEventQuerySuccess *successfulResult = (SqliteTrailEventQuerySuccess *)result;
            NSArray<MMTrailEvent *> *oldEvents = successfulResult.data;
            
            [strongSelf createExitEventsInternally:strongSelf events:oldEvents];
            [strongSelf submitEventsInternally:strongSelf events:oldEvents];
            [strongSelf clearEventsInternally:strongSelf events:oldEvents];
            
        }
        
    });
    [self stop];
}

- (void)stop {
    //no-op
}

# pragma mark -
 
- (void)submitEventsInternally:(MMFireAndForgetOldEventPusher *)_self
                        events:(NSArray<MMTrailEvent *> *)events {
    
}

- (void)createExitEventsInternally:(MMFireAndForgetOldEventPusher *)_self
              events:(NSArray<MMTrailEvent *> *)events {
    
}

- (void)clearEventsInternally:(MMFireAndForgetOldEventPusher *)_self
                       events:(NSArray<MMTrailEvent *> *)events {
    NSMutableArray<NSString *> *eventIds = [NSMutableArray new];
    for (MMTrailEvent *event in events) {
        [eventIds addObject:event.eventId];
    }
    
    [_self->store deleteEventsByEventIds:eventIds];
}

@end
