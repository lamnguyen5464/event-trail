//
//  MMFireAndForgetOldEventPusher.h
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import <Foundation/Foundation.h>
#import "MMEventTrailIntegration.h"
#import "MMTrailEventCreator.h"
#import "MMEventTrailPusher.h"
#import "MMEventTrailStore.h"
#import "MMAppSession.h"


NS_ASSUME_NONNULL_BEGIN

@interface MMFireAndForgetOldEventPusher: NSObject<MMEventTrailIntegration> {
    dispatch_queue_t taskQueue;
    id<MMEventTrailStore> store;
    MMTrailEventCreator *trailEventCreator;
    MMEventTrailPusher *pusher;
    
}

- (instancetype)initWithStore:(id<MMEventTrailStore>)store
            trailEventCreator:(MMTrailEventCreator *)trailEventCreator
            eventTrailPusher:(MMEventTrailPusher *)pusher;

@end

NS_ASSUME_NONNULL_END
