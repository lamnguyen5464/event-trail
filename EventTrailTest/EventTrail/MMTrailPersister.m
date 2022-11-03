//
//  MMTrailPersister.m
//
//  Created by lam.nguyen5 on 10/28/22.
//

#import "MMTrailPersister.h"

@implementation MMTrailPersister

- (instancetype)initWithStore:(id<MMEventTrailStore>)store
            trailEventCreator:(MMTrailEventCreator *)eventCreator
          trailEventPersister:(id<MMPersister>)eventPersister {
    self = [super init];
    if (self) {
        self->store = store;
        self->eventCreator = eventCreator;
        self->eventPersister = eventPersister;
        self->taskQueue = dispatch_queue_create("EventTrail.MMTrailPersister.taskQueue", NULL);
    }
    return self;
}

- (void)persist:(MMTrail *)data {
    if (!data) return;
    NSLog(@"[TrailEvent] persist trail: %@", data.trailId);
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self->taskQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSDictionary *eventParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                     data.trailId, @"trail_id",
                                     @(data.level), @"level",
                                     data.entryScope, @"entry_point.scope",
                                     data.entryType, @"entry_point.type",
                                     data.entryAppIdTrigger, @"entry_point.app_id_trigger",
                                     data.entryScreenName, @"entry_point.screen_name",
                                     data.entryParentTrailId, @"entry_point.parent_id",
                                     nil];

        MMTrailEvent *event = [strongSelf->eventCreator createWithName:@"trail_start" eventParams:eventParams];
        [strongSelf->store saveTrail:data];
        [strongSelf->eventPersister persist:event];
    });
}

@end
