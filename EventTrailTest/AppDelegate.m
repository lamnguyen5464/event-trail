//
//  AppDelegate.m
//  EventTrailTest
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "AppDelegate.h"
#import "EventTrail/MMEventTrailSDK.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"AppSession: %@", [MMAppSession getCurrentAppSession]);
    
    MMTrailOpenMeta *meta = [MMTrailOpenMeta new];
    meta.appId = @"vn.momo.1";
    meta.entryScope = @"scope_1";
    meta.entryType = @"type_1";
    meta.entryAppIdTrigger = @"app.id.trigger.01";
    meta.entryScreenName = @"screen_name_01";
    
    [[MMEventTrailSDK sharedSDK] openTrailWithMeta:meta];
    
    
    for(int i = 0; i < 10; i++) {
        [[MMEventTrailSDK sharedSDK] trackEvent:[NSString stringWithFormat:@"event_name_%d", i]
                                         eventParams:[NSDictionary dictionaryWithObjectsAndKeys:@([MMUtils getTimeStampLong]), @"time", nil]];
    }
    
    MMTrailOpenMeta *meta2 = [MMTrailOpenMeta new];
    meta2.appId = @"vn.momo.2";
    meta2.entryScope = @"scope_2";
    meta2.entryType = @"type_2";
    meta2.entryAppIdTrigger = @"app.id.trigger.02";
    meta2.entryScreenName = @"screen_name_02";

    [[MMEventTrailSDK sharedSDK] openTrailWithMeta:meta2];
     
    for(int i = 11; i < 20; i++) {
        [[MMEventTrailSDK sharedSDK] trackEvent:[NSString stringWithFormat:@"event_name_%d", i]
                                         eventParams:[NSDictionary dictionaryWithObjectsAndKeys:@([MMUtils getTimeStampLong]), @"time", nil]];
    }
    
    MMTrailFinishMeta *finishTrailMeta = [MMTrailFinishMeta new];
    finishTrailMeta.appId = @"vn.momo.2";
    finishTrailMeta.exitScreen = @"screenNameEnd";
    finishTrailMeta.exitBy = @"endBy2";
    [[MMEventTrailSDK sharedSDK] finishTrailWithMeta:finishTrailMeta];
    
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[MMEventTrailSDK sharedSDK] applicationWillEnterForeground];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[MMEventTrailSDK sharedSDK] applicationDidEnterBackground];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
