//
//  MMEventTrailProvider.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>

#import "MMSqliteEventTrailStore.h"
#import "MMEventTrailStore.h"
#import "MMTrailsManager.h"
#import "MMTrailEventCreator.h"
#import "MMTrailEvent.h"
#import "MMTrail.h"
#import "SqliteExecutionResult.h"
#import "MMEventPushingScheduler.h"
#import "MMEventTrailPusher.h"
#import "MMTrailEventPersister.h"
#import "MMTrailPersister.h"
#import "MMEventTrailIntegration.h"
#import "MMFireAndForgetOldEventPusher.h"
#import "MMEventTrailSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMEventTrailProvider: NSObject
 
+ (MMEventTrailSDK *)sharedSDK;

@end

NS_ASSUME_NONNULL_END
