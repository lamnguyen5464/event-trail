//
//  MMTrailManager.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMTrailManager.h"

#pragma mark - MMTrailItem
@interface MMTrailItem: NSObject
@property (nonatomic) MMTrail *value;
@property (nonatomic) MMTrailItem *parentTrail;
@end

@implementation MMTrailItem

@end


#pragma mark - MMTrailManager implementation
@implementation MMTrailManager {
    MMTrailItem *currentTrailItem;
    id<MMEventTrailStore> store;
}

- (instancetype)initWithEventTrailStore:(id<MMEventTrailStore>)store {
    self = [super init];
    if (self) {
        self->store = store;
        self->currentTrailItem = nil;
    }
    
    return self;
}
                


- (MMTrail *)getCurrentTrail {
    return self->currentTrailItem ? self->currentTrailItem.value : nil;
}

- (MMTrail *)createNewTrail {
    MMTrailItem *item = [MMTrailItem new];

    MMTrail *newTrail = [MMTrail new];
    BOOL isRootTrail = self->currentTrailItem == nil || self->currentTrailItem.value == nil;
    newTrail.level = isRootTrail ? 0 : (self->currentTrailItem.value.level + 1);
    newTrail.trailId = [[NSUUID UUID] UUIDString];
    
    item.value = newTrail;
    item.parentTrail = self->currentTrailItem;
    self->currentTrailItem = item;
    
    
//    NSLog(@"[trail] created trail: %@ level: %ld", newTrail.trailId, (long)newTrail.level);
    
    return self->currentTrailItem.value;
    
}

- (MMTrail *)removeCurrentTrail {
    if (self->currentTrailItem == nil) {
        return nil;
    }
    MMTrailItem *parentItem = self->currentTrailItem.parentTrail;
//    NSLog(@"[trail] remove trail: %@ level: %ld", self->currentTrailItem.value.trailId, (long)self->currentTrailItem.value.level);
    self->currentTrailItem = parentItem;
    
    return self->currentTrailItem ? self->currentTrailItem.value : nil;
}



@end
