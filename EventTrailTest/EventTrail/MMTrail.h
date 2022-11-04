//
//  MMTrail.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTrail: NSObject

@property (nonatomic) NSString *trailId;
@property (nonatomic) NSString *trailSession;
@property (nonatomic) NSString *trackingSessionId;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSString *parentTrailId;


@end

NS_ASSUME_NONNULL_END
