//
//  MMTrailEventCreator.h
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import <Foundation/Foundation.h>
#import "MMTrailEvent.h"
#import "MMTrailsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailEventCreator: NSObject {
    NSString *previousEventId;
    MMTrailsManager *trailsManager;
}

- (instancetype)initWithTrailsManager:(MMTrailsManager *)trailsManager;

- (MMTrailEvent *)createWithName:(NSString *)eventName
                     eventParams:(NSDictionary *)eventParams;
@end

NS_ASSUME_NONNULL_END
