//
//  MMTrail.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMTrail.h"

@implementation MMTrail

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_trailId = @"";
        self->_trailSession = @"";
        self->_trackingSessionId = @"";
        self->_parentTrailId = @"";
        self->_level = 0;
    }
    return self;
}


@end
