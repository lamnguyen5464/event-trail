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


- (MMTrail *)openTrailWithAppId:(NSString *)appId
                       entryScope:(NSString *)entryScope
                        entryType:(NSString *)entryType
                entryAppIdTrigger:(NSString *)entryAppIdTrigger
                  entryScreenName:(NSString *)entryScreenName {
    MMTrail *trail = [self->trailsManager createWithAppId:appId entryScope:entryScope entryType:entryType entryAppIdTrigger:entryAppIdTrigger entryScreenName:entryScreenName exitBy:@"" exitScreen:@""];
    [self->trailPersister persist:trail];
    return trail;
}

- (void)closeTrailWithAppId:(NSString *)appId
                 screenName:(NSString *)screenName
                      endBy:(NSString *)endBy {
    
    NSDictionary *eventParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 endBy, @"exit_point.end_by",
                                 screenName, @"screen_name",
                                 appId, @"appId",
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

