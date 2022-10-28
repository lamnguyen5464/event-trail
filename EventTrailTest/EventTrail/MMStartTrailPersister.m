//
//  MMStartTrailPersister.m
//
//  Created by lam.nguyen5 on 10/28/22.
//

#import "MMStartTrailPersister.h"

@implementation MMStartTrailPersister

- (instancetype)initWithStore:(id<MMEventTrailStore>)store
            trailEventCreator:(MMTrailEventCreator *)eventCreator
          trailEventPersister:(id<MMPersister>)eventPersister {
    self = [super init];
    if (self) {
        self->store = store;
        self->eventCreator = eventCreator;
        self->eventPersister = eventPersister;
        self->taskQueue = dispatch_queue_create("EventTrail.MMStartTrailPersister.taskQueue", NULL);
    }
    return self;
}

- (void)persist:(MMTrail *)data {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self->taskQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        MMTrailEvent *event = [strongSelf->eventCreator createWithName:@"trail_start" eventParams:@""];
        [strongSelf->eventPersister persist:event];
        [strongSelf->store saveTrail:data];
    });
}

@end
