//
//  MMSqliteEventTrailStore.h
//  MoMoPlatform
//
//  Created by lam.nguyen5 on 10/17/22.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MMEventTrailStore.h"
//#import <shared/shared.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSqliteEventTrailStore: NSObject<MMEventTrailStore> {
    sqlite3 *database;
    //  id<SharedLogger> logger;
    
}
- (id<SqliteExecutionResult>)saveEvent:(MMTrailEvent *)event;
- (id<SqliteExecutionResult>)saveTrail:(MMTrail *)trail;

- (id<SqliteExecutionResult>)queryEventsBySessionIds:(NSArray<NSString *> *)sessionIds;
- (id<SqliteExecutionResult>)queryEventsNotInSessionIds:(NSArray<NSString *> *)sessionIds;

 
- (id<SqliteExecutionResult>)deleteEventsByEventIds:(NSArray<NSString *> *)eventIds;
- (id<SqliteExecutionResult>)deleteEventsByTrailIds:(NSArray<NSString *> *)trailIds;
- (id<SqliteExecutionResult>)deleteTrailsByTrailIds:(NSArray<NSString *> *)trailIds;

- (id<SqliteExecutionResult>)clearAllEvents;
- (id<SqliteExecutionResult>)clearAllTrails;

@end

NS_ASSUME_NONNULL_END
