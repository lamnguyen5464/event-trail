//
//  MMEventTrailSDK.m
//
//  Created by lam.nguyen5 on 11/2/22.
//

#import "MMEventTrailSDK.h"

@implementation MMEventTrailSDK

static MMEventTrailSDK *sharedSDK = nil;

- (instancetype)initWithIntegrations:(NSArray<id<MMEventTrailIntegration>> *)integrations
                      eventPersister:(MMTrailEventPersister *)eventPersister
                      trailPersister:(MMTrailPersister *)trailPersister
                       trailsManager:(MMTrailsManager *)trailsManager
                        eventCreator:(MMTrailEventCreator *)eventCreator {
    self = [super init];
    if (self) {
        self->integrations = integrations;
        self->trailsManager = trailsManager;
        self->eventCreator = eventCreator;
        self->eventPersister = eventPersister;
        self->trailPersister = trailPersister;
        
        [self startIntegrations];
    }
    return self;
}

+ (MMEventTrailSDK *)sharedSDK {
    if (sharedSDK == nil) {
        @synchronized (self) {
            if (sharedSDK == nil) {
                MMEventTrailPusher *eventTrailPusher = [[MMEventTrailPusher alloc] init];
                MMTrailsManager *trailsManager = [[MMTrailsManager alloc] init];
                id<MMEventTrailStore> eventTrailStore = [[MMSqliteEventTrailStore alloc] init];
                MMTrailEventCreator *eventCreator = [[MMTrailEventCreator alloc] initWithTrailsManager:trailsManager];
                
                MMTrailEventPersister *eventPersister = [[MMTrailEventPersister alloc] initWithStore:eventTrailStore];
                
                MMTrailPersister *trailPersister = [[MMTrailPersister alloc] initWithStore:eventTrailStore
                                                                         trailEventCreator:eventCreator
                                                                       trailEventPersister:eventPersister];
                
                id<MMEventTrailIntegration> eventPushingScheduler = [[MMEventPushingScheduler alloc] initWithStore:eventTrailStore
                                                                                                  eventTrailPusher:eventTrailPusher];
                id<MMEventTrailIntegration> fireAndForgetOldEventPusher = [[MMFireAndForgetOldEventPusher alloc] initWithStore:eventTrailStore
                                                                                                             trailEventCreator:eventCreator
                                                                                                              eventTrailPusher:eventTrailPusher];
                
                NSArray<id<MMEventTrailIntegration>> *integrations = [NSArray arrayWithObjects:eventPushingScheduler, fireAndForgetOldEventPusher, nil];
                
                sharedSDK = [[MMEventTrailSDK alloc] initWithIntegrations:integrations
                                                           eventPersister:eventPersister
                                                           trailPersister:trailPersister
                                                            trailsManager:trailsManager
                                                             eventCreator:eventCreator];
            }
        }
    }
    return sharedSDK;
}


- (void)trackEvent:(NSString *)eventName
       eventParams:(NSDictionary *)eventParams {
    MMTrailEvent *event = [self->eventCreator createWithName:eventName eventParams:eventParams];
    [self->eventPersister persist:event];
}

- (MMTrailOpenData *)openTrailWithMeta:(MMTrailOpenMeta *)meta {
    MMTrailOpenData *trailOpenData = [self->trailsManager createWithMeta:meta];
    [self->trailPersister persist:trailOpenData];
    return trailOpenData;
}

- (void)finishTrailWithMeta:(MMTrailFinishMeta *)meta {
    NSDictionary *eventParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 meta.exitBy, @"exit_point.end_by",
                                 meta.exitScreen, @"screen_name",
                                 meta.appId, @"appId",
                                 nil];
    MMTrailEvent *event = [self->eventCreator createWithName:@"trail_end" eventParams:eventParams];
    [self->eventPersister persist:event];
}


- (void)startIntegrations {
    [self->integrations enumerateObjectsUsingBlock:^(id<MMEventTrailIntegration>  _Nonnull integration, NSUInteger idx, BOOL * _Nonnull stop) {
        [integration start];
    }];
}

- (void)stopIntegrations {
    [self->integrations enumerateObjectsUsingBlock:^(id<MMEventTrailIntegration>  _Nonnull integration, NSUInteger idx, BOOL * _Nonnull stop) {
        [integration stop];
    }];
}

- (void)applicationDidEnterBackground {
    [self stopIntegrations];
    
}

- (void)applicationWillEnterForeground {
    [self startIntegrations];
}

@end

