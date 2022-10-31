//
//  MMTrailEvent.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>
#import "MMUtils.h"
#import "MMStorePersistedTrailEvent.h"
#import "MMUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailEvent: NSObject

@property (nonatomic) NSString *trailId;
@property (nonatomic) NSString *eventId;
@property (nonatomic) NSString *eventName;
@property (nonatomic) NSDictionary *eventParams;

- (MMStorePersistedTrailEvent *)toPersistModel;

@end

NS_ASSUME_NONNULL_END
