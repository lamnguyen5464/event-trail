//
//  SqliteExecutionResult.h
//
//  Created by lam.nguyen5 on 10/21/22.
//

#import <Foundation/Foundation.h>
#import "MMTrailEvent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SqliteExecutionResult <NSObject>

@end

#pragma mark - SqliteExecutionFailure
@interface SqliteExecutionFailure: NSObject<SqliteExecutionResult>
- (instancetype)initWithException:(NSException *)exception;
@property (nonatomic, readonly) NSException* exception;
@end

#pragma mark - SqliteExecutionSuccess
@interface SqliteExecutionSuccess: NSObject<SqliteExecutionResult>
+ (SqliteExecutionSuccess *)shared;
@end

#pragma mark - SqliteTrailEventQuerySuccess
@interface SqliteTrailEventQuerySuccess: NSObject<SqliteExecutionResult>
- (instancetype)initWithData:(NSArray<MMTrailEvent *> *)data;
@property (nonatomic, readonly) NSArray<MMTrailEvent *> * data;
@end



NS_ASSUME_NONNULL_END
