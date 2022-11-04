//
//  MMTrailsManager.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>
#import "MMTrail.h"
#import "MMAppSession.h"
#import "MMTrailOpenMeta.h"
#import "MMTrailOpenData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailsManager: NSObject

- (MMTrailOpenData *)createWithMeta:(MMTrailOpenMeta *)meta;

- (MMTrail *)getLatestTrail;
- (MMTrail *)removeLatestTrail;

@end

NS_ASSUME_NONNULL_END
