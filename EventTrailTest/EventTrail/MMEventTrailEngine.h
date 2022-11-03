//
//  MMEventTrailEngine.h
//
//  Created by lam.nguyen5 on 10/31/22.
//

#import <Foundation/Foundation.h>
#import "MMStorePersistedTrailEvent.h"
#import "MMTrailEvent.h"
#import "MMTrail.h"
#import "MMEventTrailIntegration.h"
#import "MMTrailEventPersister.h"
#import "MMTrailPersister.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMEventTrailEngine: NSObject {
    NSArray<id<MMEventTrailIntegration>> *integrations;
    MMTrailEventPersister *eventPersister;
    MMTrailPersister *trailPersister;
};

- (instancetype)initWithIntegrations:(NSArray<id<MMEventTrailIntegration>> *)integrations
                      eventPersister:(MMTrailEventPersister *)eventPersister
                      trailPersister:(MMTrailPersister *)trailPersister;

- (void)start;
- (void)stop;

- (void)trackEvent:(MMTrailEvent *)event;
- (void)trackTrail:(MMTrail *)trail;

@end

NS_ASSUME_NONNULL_END
