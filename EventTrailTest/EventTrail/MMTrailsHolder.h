//
//  MMTrailsHolder.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>
#import "MMTrail.h"
#import "MMEventTrailStore.h"
#import "MMAppSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailsHolder: NSObject

- (MMTrail *)getLatestTrail;
- (void)addTrail:(MMTrail *)trail;
- (MMTrail *)removeCurrentTrail;

@end

NS_ASSUME_NONNULL_END
