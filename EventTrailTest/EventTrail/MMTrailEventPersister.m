//
//  MMTrailEventPersister.m
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import "MMTrailEventPersister.h"

@implementation MMTrailEventPersister

- (instancetype)initWithStore:(id<MMEventTrailStore>)store {
    self = [super init];
    if (self) {
        self->store = store;
        self->taskQueue = dispatch_queue_create("EventTrail.MMTrailEventPersister.taskQueue", NULL);
    }
    return self;
}

- (void)persist:(MMTrailEvent *)data {
    if (!data) return;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self->taskQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf->store saveEvent:[data toPersistModel]];
    });
}

@end
