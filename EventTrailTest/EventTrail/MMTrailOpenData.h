//
//  MMTrailOpenData.h
//
//  Created by lam.nguyen5 on 11/4/22.
//

#import <Foundation/Foundation.h>
#import "MMTrail.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailOpenData: NSObject

@property (nonatomic) MMTrail *trailData;
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *entryScope;
@property (nonatomic) NSString *entryType;
@property (nonatomic) NSString *entryAppIdTrigger;
@property (nonatomic) NSString *entryScreenName;

@end

NS_ASSUME_NONNULL_END
