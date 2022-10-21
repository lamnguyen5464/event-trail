//
//  MMAppSession.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMAppSession.h"

static NSString* currentSession = nil;

@implementation MMAppSession

+ (NSString *)getCurrentAppSession {
    if (currentSession == nil) {
        @synchronized (self) {
            if (currentSession == nil) {
                currentSession = [MMAppSession createNewSession];
            }
        }
    }
    return currentSession;
}

#pragma mark -
+ (NSString *)createNewSession {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return [NSString stringWithFormat:@"app-session-%@", uuid];
}

@end
