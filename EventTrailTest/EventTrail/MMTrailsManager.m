//
//  MMTrailsManager.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMTrailsManager.h"

#pragma mark - MMTrailItem
@interface MMTrailItem: NSObject
@property (nonatomic) MMTrail *value;
@property (nonatomic) MMTrailItem *parentTrail;
@end

@implementation MMTrailItem

@end


 
#pragma mark - MMTrailsManager implementation
@implementation MMTrailsManager {
    MMTrailItem *currentTrailItem;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self->currentTrailItem = nil;
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
    MMTrail *parentTrail = [self getLatestTrail];
    MMTrail *newTrail = [MMTrail new];
    
    BOOL isRootTrail = parentTrail == nil;
    newTrail.level = isRootTrail ? 0 : (parentTrail.level + 1);
    newTrail.trailId = [self createNewId];
    newTrail.trailSession = [MMAppSession getCurrentAppSession];
    newTrail.entryParentTrailId = isRootTrail ? @"" : parentTrail.trailId;
    // TODO: get TrackingSessionKey from KMM
    newTrail.trackingSessionId = @"";
    newTrail.appId = appId;
    newTrail.entryScope = entryScope;
    newTrail.entryType = entryType;
    newTrail.entryAppIdTrigger = entryAppIdTrigger;
    newTrail.entryScreenName = entryScreenName;
    newTrail.exitBy = exitBy;
    newTrail.exitScreen = exitScreen;
    
    [self addTrail:newTrail];
 
    return newTrail;
    
}


- (MMTrail *)getLatestTrail {
    return self->currentTrailItem ? self->currentTrailItem.value : nil;
}

- (MMTrail *)removeLatestTrail {
    if (self->currentTrailItem == nil) {
        return nil;
    }
    MMTrailItem *parentItem = self->currentTrailItem.parentTrail;
//    NSLog(@"[trail] remove trail: %@ level: %ld", self->currentTrailItem.value.trailId, (long)self->currentTrailItem.value.level);
    self->currentTrailItem = parentItem;
    
    return self->currentTrailItem ? self->currentTrailItem.value : nil;
}

# pragma mark -


- (void)addTrail:(MMTrail *)trail {
    MMTrailItem *item = [MMTrailItem new];
    item.value = trail;
    item.parentTrail = self->currentTrailItem;
    self->currentTrailItem = item;
}


- (NSString *)createNewId {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return [NSString stringWithFormat:@"trail-id-%@", uuid];
}




@end
