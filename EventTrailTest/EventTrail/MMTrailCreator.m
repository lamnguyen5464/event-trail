//
//  MMTrailCreator.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMTrailCreator.h"
 
#pragma mark - MMTrailCreator implementation
@implementation MMTrailCreator {
    MMTrailsHolder *trailsHolder;
}

- (instancetype)initWithTrailsHolder:(MMTrailsHolder *)trailsHolder {
    self = [super init];
    if (self) {
        self->trailsHolder = trailsHolder;
    }
    
    return self;
}
                
- (MMTrail *)createWithAppId:(NSString *)appId
                  entryScope:(NSString *)entryScope
                   entryType:(NSString *)entryType
           entryAppIdTrigger:(NSString *)entryAppIdTrigger
             entryScreenName:(NSString *)entryScreenName
                      exitBy:(NSString *)exitBy
                  exitScreen:(NSString *)exitScreen {
    MMTrail *parentTrail = [self->trailsHolder getCurrentTrail];
    MMTrail *newTrail = [MMTrail new];
    
    BOOL isRootTrail = parentTrail == nil;
    newTrail.level = isRootTrail ? 0 : (parentTrail.level + 1);
    newTrail.trailId = [self createNewId];
    newTrail.trailSession = [MMAppSession getCurrentAppSession];
    newTrail.entryParentTrailId = isRootTrail ? nil : parentTrail.trailId;
    // TODO: get TrackingSessionKey from KMM
    newTrail.trackingSessionId = @"";
    newTrail.appId = appId;
    newTrail.entryScope = entryScope;
    newTrail.entryType = entryType;
    newTrail.entryAppIdTrigger = entryAppIdTrigger;
    newTrail.entryScreenName = entryScreenName;
    newTrail.exitBy = exitBy;
    newTrail.exitScreen = exitScreen;
 
    return newTrail;
    
}

# pragma mark -
- (NSString *)createNewId {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return [NSString stringWithFormat:@"trail-id-%@", uuid];
}




@end
