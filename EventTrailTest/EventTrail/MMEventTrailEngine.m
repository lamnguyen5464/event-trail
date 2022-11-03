//
//  MMEventTrailEngine.m
//
//  Created by lam.nguyen5 on 10/31/22.
//

#import "MMEventTrailEngine.h"

@implementation MMEventTrailEngine

- (instancetype)initWithIntegrations:(NSArray<id<MMEventTrailIntegration>> *)integration
                      eventPersister:(MMTrailEventPersister *)eventPersister
                      trailPersister:(MMTrailPersister *)trailPersister {
    self = [super init];
    if (self) {
        self->integrations = integration;
        self->eventPersister = eventPersister;
        self->trailPersister = trailPersister;
    }
    return self;
}


- (void)start {
    [self->integrations enumerateObjectsUsingBlock:^(id<MMEventTrailIntegration>  _Nonnull integration, NSUInteger idx, BOOL * _Nonnull stop) {
        [integration start];
    }];
}

- (void)stop {
    [self->integrations enumerateObjectsUsingBlock:^(id<MMEventTrailIntegration>  _Nonnull integration, NSUInteger idx, BOOL * _Nonnull stop) {
        [integration stop];
    }];
}

- (void)trackEvent:(MMTrailEvent *)event {
    [self->eventPersister persist:event];
}

- (void)trackTrail:(MMTrail *)trail {
    [self->trailPersister persist:trail];
}


@end
