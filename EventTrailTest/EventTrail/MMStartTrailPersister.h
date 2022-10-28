//
//  MMStartTrailPersister.h
//
//  Created by lam.nguyen5 on 10/28/22.
//

#import "MMPersister.h"
#import "MMTrail.h"
#import "MMSqliteEventTrailStore.h"
#import "MMPersister.h"
#import "MMTrailEventCreator.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMStartTrailPersister: NSObject<MMPersister> {
    dispatch_queue_t taskQueue;
    id<MMEventTrailStore> store;
    id<MMPersister> eventPersister;
    MMTrailEventCreator *eventCreator;
}

- (instancetype)initWithStore:(id<MMEventTrailStore>)store
            trailEventCreator:(MMTrailEventCreator *)eventCreator
          trailEventPersister:(id<MMPersister>)eventPersister;

@end

NS_ASSUME_NONNULL_END
