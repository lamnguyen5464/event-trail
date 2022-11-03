//
//  MMTrailsHolder.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMTrailsHolder.h"


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
                



@end
