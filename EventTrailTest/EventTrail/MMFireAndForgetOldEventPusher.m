//
//  MMFireAndForgetOldEventPusher.m
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import "MMFireAndForgetOldEventPusher.h"

@implementation MMFireAndForgetOldEventPusher 

- (instancetype)initWithStore:(id<MMEventTrailStore>)store
            trailEventCreator:(MMTrailEventCreator *)trailEventCreator
             eventTrailPusher:(MMEventTrailPusher *)pusher {
    self = [super init];
    if (self) {
        self->store = store;
        self->trailEventCreator = trailEventCreator;
        self->pusher = pusher;
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
            
            NSArray<MMTrailEvent *> *handledEvents = [strongSelf createExitEventsInternally:strongSelf events:oldEvents];
            
            BOOL submitedSuccessfully = [strongSelf submitEventsInternally:strongSelf events:handledEvents];
            
            if (submitedSuccessfully) {
                [strongSelf clearEventsInternally:strongSelf events:handledEvents];
            }
        }
        
    });
    [self stop];
}

- (void)stop {
    //no-op
}

# pragma mark -
 
- (BOOL)submitEventsInternally:(MMFireAndForgetOldEventPusher *)_self
                        events:(NSArray<MMTrailEvent *> *)events {
    return [_self->pusher pushEvents:events];
}

- (NSArray<MMTrailEvent *> *)createExitEventsInternally:(MMFireAndForgetOldEventPusher *)_self
              events:(NSArray<MMTrailEvent *> *)events {
    
    NSMutableSet *trailIds = [NSMutableSet new];
    for (MMTrailEvent *event in events) {
        if (!event) continue;
        [trailIds addObject:event.trailId];
    }
    
    NSMutableArray *listEvents = [NSMutableArray arrayWithArray:events];
    
    [trailIds enumerateObjectsUsingBlock:^(NSString * _Nonnull trailId, BOOL * _Nonnull stop) {
        MMTrailEvent *event = [_self->trailEventCreator createWithName:@"trail_end" eventParams:@""];
        [listEvents addObject:event];
    }];
    
    return listEvents;
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
