//
//  MMEventTrailSDK.h
//
//  Created by lam.nguyen5 on 11/2/22.
//

#import <Foundation/Foundation.h>
#import "MMTrail.h"
#import "MMEventTrailEngine.h"
#import "MMTrailsManager.h"
#import "MMTrailEventCreator.h"
#import "MMTrailEvent.h"
#import "MMFireAndForgetOldEventPusher.h"
#import "MMEventTrailPusher.h"
#import "MMEventPushingScheduler.h"
#import "MMTrailFinishMeta.h"
#import "MMTrailOpenMeta.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMEventTrailSDK: NSObject {
    NSArray<id<MMEventTrailIntegration>> *integrations;
    MMTrailsManager *trailsManager;
    MMTrailEventCreator *eventCreator;
    MMTrailEventPersister *eventPersister;
    MMTrailPersister *trailPersister;
}

+ (MMEventTrailSDK *)sharedSDK;

- (instancetype)initWithIntegrations:(NSArray<id<MMEventTrailIntegration>> *)integrations
                      eventPersister:(MMTrailEventPersister *)eventPersister
                      trailPersister:(MMTrailPersister *)trailPersister
                       trailsManager:(MMTrailsManager *)trailsManager
                        eventCreator:(MMTrailEventCreator *)eventCreator
;

- (void)trackEvent:(NSString *)eventName
       eventParams:(NSDictionary *)eventParams;


- (MMTrail *)openTrailWithAppId:(NSString *)appId
                     entryScope:(NSString *)entryScope
                      entryType:(NSString *)entryType
              entryAppIdTrigger:(NSString *)entryAppIdTrigger
                entryScreenName:(NSString *)entryScreenName;

- (void)closeTrailWithAppId:(NSString *)appId
                 screenName:(NSString *)screenName
                      endBy:(NSString *)endBy;

- (MMTrail *)openTrailWithMeta:(MMTrailOpenMeta *)meta;

- (void)finishTrailWithMeta:(MMTrailFinishMeta *)meta;

- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;

@end

NS_ASSUME_NONNULL_END
