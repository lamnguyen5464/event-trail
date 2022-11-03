//
//  MMEventTrailStore.h
//  MoMoPlatform
//
//  Created by lam.nguyen5 on 10/17/22.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMTrailEvent.h"
#import "MMTrail.h"
#import "SqliteExecutionResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MMEventTrailStore <NSObject>
- (id<SqliteExecutionResult>)saveEvent:(MMStorePersistedTrailEvent *)event;
- (id<SqliteExecutionResult>)saveTrail:(MMTrail *)trail;

- (id<SqliteExecutionResult>)queryEventsBySessionIds:(NSArray<NSString *> *)sessionIds;
- (id<SqliteExecutionResult>)queryEventsNotInSessionIds:(NSArray<NSString *> *)sessionIds;
- (id<SqliteExecutionResult>)queryTrailsNotInSessionIds:(NSArray<NSString *> *)sessionIds;
- (id<SqliteExecutionResult>)queryAllEvents;
- (id<SqliteExecutionResult>)queryAllTrails;

 
- (id<SqliteExecutionResult>)deleteEventsByEventIds:(NSArray<NSString *> *)eventIds;
- (id<SqliteExecutionResult>)deleteEventsByTrailIds:(NSArray<NSString *> *)trailIds;
- (id<SqliteExecutionResult>)deleteTrailsByTrailIds:(NSArray<NSString *> *)trailIds;


- (id<SqliteExecutionResult>)deleteAllEvents;
- (id<SqliteExecutionResult>)deleteAllTrails;

@end

NS_ASSUME_NONNULL_END
