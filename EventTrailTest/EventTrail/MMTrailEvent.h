//
//  MMTrailEvent.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailEvent: NSObject

@property (nonatomic) NSString *eventId;
@property (nonatomic) NSString *trailId;
@property (nonatomic) NSString *previousEventId;
@property (nonatomic) NSString *eventName;
@property (nonatomic) NSString *eventParams;

@end

NS_ASSUME_NONNULL_END
