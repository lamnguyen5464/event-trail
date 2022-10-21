//
//  MMTrailManager.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>
#import "MMTrail.h"
#import "MMEventTrailStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailManager: NSObject

- (MMTrail *)getCurrentTrail;
- (MMTrail *)createNewTrail;
- (MMTrail *)removeCurrentTrail;

@end

NS_ASSUME_NONNULL_END
