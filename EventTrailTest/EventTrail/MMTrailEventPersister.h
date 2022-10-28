//
//  MMTrailEventPersister.h
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import <Foundation/Foundation.h>
#import "MMSqliteEventTrailStore.h"
#import "MMPersister.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailEventPersister: NSObject<MMPersister> {
    dispatch_queue_t taskQueue;
    id<MMEventTrailStore> store;
}

- (instancetype)initWithStore:(id<MMEventTrailStore>)store;

@end

NS_ASSUME_NONNULL_END
