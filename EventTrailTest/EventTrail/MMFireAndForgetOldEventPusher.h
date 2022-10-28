//
//  MMFireAndForgetOldEventPusher.h
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import <Foundation/Foundation.h>
#import "MMEventTrailIntegration.h"
#import "MMEventTrailStore.h"
#import "MMAppSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMFireAndForgetOldEventPusher: NSObject<MMEventTrailIntegration> {
    dispatch_queue_t taskQueue;
    id<MMEventTrailStore> store;
}

@end

NS_ASSUME_NONNULL_END
