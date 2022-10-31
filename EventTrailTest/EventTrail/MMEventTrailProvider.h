//
//  MMEventTrailProvider.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>

#import "MMSqliteEventTrailStore.h"
#import "MMEventTrailStore.h"
#import "MMTrailCreator.h"
#import "MMTrailEventCreator.h"
#import "MMTrailEvent.h"
#import "MMTrail.h"
#import "SqliteExecutionResult.h"
#import "MMEventPushingScheduler.h"
#import "MMEventTrailPusher.h"
#import "MMTrailEventPersister.h"
#import "MMStartTrailPersister.h"
#import "MMEventTrailIntegration.h"
#import "MMFireAndForgetOldEventPusher.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMEventTrailProvider: NSObject

+ (MMEventTrailPusher *)sharedEventTrailPusher;
+ (id<MMEventTrailStore>)sharedEventTrailStore;
+ (MMTrailEventCreator *)sharedTrailEventCreator;
+ (MMTrailCreator *)sharedTrailCreator;
+ (MMTrailEventPersister *)sharedTrailEventPersister;
+ (MMStartTrailPersister *)sharedTrailPersister;
+ (NSArray<id<MMEventTrailIntegration>> *)sharedIntegrations;

@end

NS_ASSUME_NONNULL_END
