//
//  MMTrailEventCreator.h
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import <Foundation/Foundation.h>
#import "MMTrailEvent.h"
#import "MMTrailsHolder.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailEventCreator: NSObject {
    MMTrailsHolder *trailsHolder;
    NSString *previousEventId;
}

- (instancetype)initWithTrailsHolder:(MMTrailsHolder *)trailsHolder;

- (MMTrailEvent *)createWithName:(NSString *)eventName
                     eventParams:(NSDictionary *)eventParams;
@end

NS_ASSUME_NONNULL_END
