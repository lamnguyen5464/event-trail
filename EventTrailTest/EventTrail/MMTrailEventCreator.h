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
- (MMTrailEvent *)createWithName:(NSString *)eventName
                     eventParams:(NSString *)eventParams;
@end

NS_ASSUME_NONNULL_END
