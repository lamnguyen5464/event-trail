//
//  MMTrailCreator.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>
#import "MMTrail.h"
#import "MMAppSession.h"
#import "MMTrailsHolder.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailCreator: NSObject

- (MMTrail *)createWithAppId:(NSString *)appId
                  entryScope:(NSString *)entryScope
                   entryType:(NSString *)entryType
           entryAppIdTrigger:(NSString *)entryAppIdTrigger
             entryScreenName:(NSString *)entryScreenName
                      exitBy:(NSString *)exitBy
                  exitScreen:(NSString *)exitScreen;

@end

NS_ASSUME_NONNULL_END
