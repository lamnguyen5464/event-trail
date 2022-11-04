//
//  MMTrailOpenMeta.h
//
//  Created by lam.nguyen5 on 11/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailOpenMeta: NSObject
 
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *entryScope;
@property (nonatomic) NSString *entryType;
@property (nonatomic) NSString *entryAppIdTrigger;
@property (nonatomic) NSString *entryScreenName;

@end

NS_ASSUME_NONNULL_END
