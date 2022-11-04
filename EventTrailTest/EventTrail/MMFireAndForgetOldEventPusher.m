//
//  MMFireAndForgetOldEventPusher.m
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import "MMFireAndForgetOldEventPusher.h"

@implementation MMFireAndForgetOldEventPusher {
    BOOL didTrigger;
}

- (instancetype)initWithStore:(id<MMEventTrailStore>)store
            trailEventCreator:(MMTrailEventCreator *)trailEventCreator
             eventTrailPusher:(MMEventTrailPusher *)pusher {
    self = [super init];
    if (self) {
        self->didTrigger = false;
        self->store = store;
        self->trailEventCreator = trailEventCreator;
        self->pusher = pusher;
        self->taskQueue = dispatch_queue_create("EventTrail.MMFireAndForgetOldEventPusher.taskQueue", NULL);
    }
    return self;
}

- (void)start {
    if (self->didTrigger) {
        return;
    }
    self->didTrigger = true;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self->taskQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        NSArray<MMStorePersistedTrailEvent *> *oldEvents = [strongSelf queryOldEvents:strongSelf];
        NSArray<MMTrail *> *oldTrails = [strongSelf queryOldTrails:strongSelf];
        
        NSArray<MMStorePersistedTrailEvent *> *handledEvents = [strongSelf createExitEventsInternally:strongSelf
                                                                                               events:oldEvents
                                                                                               trails:oldTrails];
        
        BOOL submitedSuccessfully = [strongSelf submitEventsInternally:strongSelf events:handledEvents];
        
        if (submitedSuccessfully) {
            [strongSelf clearEventsInternally:strongSelf
                                       events:oldEvents
                                       trails:oldTrails];
        }
     
        
    });
    [self stop];
}

- (void)stop {
    //no-op
}

# pragma mark -

- (NSArray<MMStorePersistedTrailEvent *> *)queryOldEvents:(MMFireAndForgetOldEventPusher *)_self {
    id<SqliteExecutionResult> result = [_self->store queryEventsNotInSessionIds:[NSArray arrayWithObject:[MMAppSession getCurrentAppSession]]];
    
    if ([result isMemberOfClass:[SqliteTrailEventQuerySuccess class]]) {
        SqliteTrailEventQuerySuccess *successfulResult = (SqliteTrailEventQuerySuccess *)result;
        NSArray<MMStorePersistedTrailEvent *> *oldEvents = successfulResult.data;
        return oldEvents;
    }
    return nil;
}

- (NSArray<MMTrail *> *)queryOldTrails:(MMFireAndForgetOldEventPusher *)_self {
    id<SqliteExecutionResult> result = [_self->store queryTrailsNotInSessionIds:[NSArray arrayWithObject:[MMAppSession getCurrentAppSession]]];
    
    if ([result isMemberOfClass:[SqliteTrailQuerySuccess class]]) {
        SqliteTrailQuerySuccess *successfulResult = (SqliteTrailQuerySuccess *)result;
        NSArray<MMTrail *> *oldTrails = successfulResult.data;
        return oldTrails;
    }
    return nil;
}
 
- (BOOL)submitEventsInternally:(MMFireAndForgetOldEventPusher *)_self
                        events:(NSArray<MMStorePersistedTrailEvent *> *)events {
    return [_self->pusher pushEvents:events];
}

- (NSArray<MMStorePersistedTrailEvent *> *)createExitEventsInternally:(MMFireAndForgetOldEventPusher *)_self
                                                               events:(NSArray<MMStorePersistedTrailEvent *> *)events
                                                               trails:(NSArray<MMTrail *> *)trails {
    
    NSMutableSet *closedTrailIds = [NSMutableSet new];
    
    for (MMStorePersistedTrailEvent *event in events) {
        if (!event) continue;
        if ([event.eventName isEqual: @"trail_end"]) {
            [closedTrailIds addObject:event.trailId];
        }
    }
    
    NSMutableArray<MMStorePersistedTrailEvent *> *listEvents = [NSMutableArray arrayWithArray:events];
    
    for (MMTrail *trail in trails) {
        if (!trail || [closedTrailIds containsObject:trail.trailId]) continue;
        
        NSDictionary *eventParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"app_kill", @"exit_point.end_by",
                                     @"", @"screen_name",
                                     @"", @"appId",
                                     nil];
        
        MMTrailEvent *event = [_self->trailEventCreator createWithName:@"trail_end" eventParams:eventParams];
        [listEvents addObject:[event toPersistModel]];
    }
    
    return listEvents;
}

- (void)clearEventsInternally:(MMFireAndForgetOldEventPusher *)_self
                       events:(NSArray<MMStorePersistedTrailEvent *> *)events
                       trails:(NSArray<MMTrail *> *)trails {
    NSMutableArray<NSString *> *eventIds = [NSMutableArray new];
    NSMutableArray<NSString *> *trailIds = [NSMutableArray new];
    
    for (MMStorePersistedTrailEvent *event in events) {
        if (!event) continue;
        [eventIds addObject:event.eventId];
    }
    
    for (MMTrail *trail in trails) {
        if (!trail) continue;
        [trailIds addObject:trail.trailId];
    }
    
    
    NSLog(@"[TrailEvent] delete events with ids: %@", eventIds);
    NSLog(@"[TrailEvent] delete trails with ids: %@", trailIds);
    [_self->store deleteTrailsByTrailIds:trailIds];
    [_self->store deleteEventsByEventIds:eventIds];
}

@end
