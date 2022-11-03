//
//  MMTrailsManager.h
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import <Foundation/Foundation.h>
#import "MMTrail.h"
#import "MMAppSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTrailsManager: NSObject

- (MMTrail *)createWithAppId:(NSString *)appId
                  entryScope:(NSString *)entryScope
                   entryType:(NSString *)entryType
           entryAppIdTrigger:(NSString *)entryAppIdTrigger
             entryScreenName:(NSString *)entryScreenName
                      exitBy:(NSString *)exitBy
                  exitScreen:(NSString *)exitScreen;


- (MMTrail *)getLatestTrail;
- (MMTrail *)removeLatestTrail;

@end

NS_ASSUME_NONNULL_END
