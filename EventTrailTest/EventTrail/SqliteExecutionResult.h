//
//  SqliteExecutionResult.h
//
//  Created by lam.nguyen5 on 10/21/22.
//

#import <Foundation/Foundation.h>
#import "MMStorePersistedTrailEvent.h"
#import "MMTrail.h"

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
- (instancetype)initWithData:(NSArray<MMStorePersistedTrailEvent *> *)data;
@property (nonatomic, readonly) NSArray<MMStorePersistedTrailEvent *> * data;
@end


#pragma mark - SqliteTrailQuerySuccess
@interface SqliteTrailQuerySuccess: NSObject<SqliteExecutionResult>
- (instancetype)initWithData:(NSArray<MMTrail *> *)data;
@property (nonatomic, readonly) NSArray<MMTrail *> * data;
@end




NS_ASSUME_NONNULL_END
