//
//  MMEventTrailPusher.h
//
//  Created by lam.nguyen5 on 10/31/22.
//

#import <Foundation/Foundation.h>
#import "MMTrailEvent.h"
#import "MMUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMEventTrailPusher: NSObject

- (BOOL)pushEvents:(NSArray<MMTrailEvent *> *)events;

@end

NS_ASSUME_NONNULL_END
