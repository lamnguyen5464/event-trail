//
//  SqliteExecutionResult.m
//
//  Created by lam.nguyen5 on 10/21/22.
//

#import "SqliteExecutionResult.h"

#pragma mark - SqliteExecutionFailure
@implementation SqliteExecutionFailure

- (instancetype)initWithException:(NSException *)exception {
    self = [super init];
    if (self) {
        self->_exception = exception;
    }
    return self;
}

@end

#pragma mark - SqliteExecutionSuccess
static SqliteExecutionSuccess *sharedObject = nil;
@implementation SqliteExecutionSuccess
+ (SqliteExecutionSuccess *)shared {
    if (sharedObject == nil) { 
        @synchronized (self) {
            if (sharedObject == nil) {
                sharedObject = [SqliteExecutionSuccess new];
            }
            
        }
    }
    return sharedObject;
};
@end


#pragma mark - SqliteTrailEventQuerySuccess
@implementation SqliteTrailEventQuerySuccess

- (instancetype)initWithData:(NSArray<MMTrailEvent *> *)data {
    self = [super init];
    if (self) {
        self->_data = data;
    }
    
    return self;
}
@end

#pragma mark - SqliteTrailQuerySuccess
@implementation SqliteTrailQuerySuccess

- (instancetype)initWithData:(NSArray<MMTrail *> *)data {
    self = [super init];
    if (self) {
        self->_data = data;
    }
    
    return self;
}

@end

