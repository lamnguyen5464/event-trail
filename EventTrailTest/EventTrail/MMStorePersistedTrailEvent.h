//
//  MMStorePersistedTrailEvent.h
//
//  Created by lam.nguyen5 on 10/31/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMStorePersistedTrailEvent: NSObject

@property (nonatomic) NSString *eventId;
@property (nonatomic) NSString *trailId;
@property (nonatomic) NSString *eventName;
@property (nonatomic) NSString *eventBundle;

@end

NS_ASSUME_NONNULL_END
