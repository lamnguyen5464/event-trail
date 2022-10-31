//
//  MMEventPushingScheduler.h
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import <Foundation/Foundation.h>
#import "MMEventTrailIntegration.h"
#import "MMUtils.h"
#import "MMSqliteEventTrailStore.h"
#import "MMAppSession.h"
#import "SqliteExecutionResult.h"
#import "MMEventTrailPusher.h"
#import "MMStorePersistedTrailEvent.h"


NS_ASSUME_NONNULL_BEGIN

@interface MMEventPushingScheduler: NSObject<MMEventTrailIntegration> {
    dispatch_source_t flushTimer;
    dispatch_queue_t taskQueue;
    id<MMEventTrailStore> store;
    MMEventTrailPusher *pusher;
}

- (instancetype)initWithStore:(id<MMEventTrailStore>)store
            eventTrailPusher:(MMEventTrailPusher *)pusher;


@end

NS_ASSUME_NONNULL_END
