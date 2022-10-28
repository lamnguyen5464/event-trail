//
//  MMEventPushingScheduler.m
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import "MMEventPushingScheduler.h"

@implementation MMEventPushingScheduler 

int const MMAnalyticsDefaultFlushIntervalMillis = 15000;

- (instancetype)initWithStore:(id<MMEventTrailStore>)store {
    self = [super init];
    if (self) {
        self->store = store;
        self->taskQueue = dispatch_queue_create("EventTrail.MMEventPushingScheduler.taskQueue", NULL);
    }
    return self;
}

- (void)start {
    if (self->flushTimer) {
        return;
    }
    double MMAnalyticsDefaultFlushIntervalInSeconds = MMAnalyticsDefaultFlushIntervalMillis / 1000;
    
    __weak __typeof(self) weakSelf = self;
    self->flushTimer = [MMUtils startTimer:self->taskQueue withInterval:MMAnalyticsDefaultFlushIntervalInSeconds block:^{
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
    
}

- (void)queryEvents:(MMEventPushingScheduler *)_self {
    
}

@end
