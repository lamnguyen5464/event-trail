//
//  MMEventTrailIntegration.h
//  MoMoPlatform
//
//  Created by lam.nguyen5 on 10/17/22.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MMEventTrailIntegration <NSObject>

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
