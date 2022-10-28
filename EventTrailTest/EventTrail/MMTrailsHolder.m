//
//  MMTrailsHolder.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMTrailsHolder.h"

#pragma mark - MMTrailItem
@interface MMTrailItem: NSObject
@property (nonatomic) MMTrail *value;
@property (nonatomic) MMTrailItem *parentTrail;
@end

@implementation MMTrailItem

@end


#pragma mark - MMTrailManager implementation
@implementation MMTrailsHolder {
    MMTrailItem *currentTrailItem;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self->currentTrailItem = nil;
    }
    
    return self;
}
                


- (MMTrail *)getCurrentTrail {
    return self->currentTrailItem ? self->currentTrailItem.value : nil;
}


- (void)addTrail:(MMTrail *)trail {
    MMTrailItem *item = [MMTrailItem new];
    item.value = trail;
    item.parentTrail = self->currentTrailItem;
    self->currentTrailItem = item;

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
