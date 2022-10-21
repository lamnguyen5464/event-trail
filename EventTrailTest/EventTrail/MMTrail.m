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
        self->_appId = @"";
        self->_level = 0;
        self->_entryScope = @"";
        self->_entryType = @"";
        self->_entryAppIdTrigger = @"";
        self->_entryScreenName = @"";
        self->_entryParentTrailId = @"";
        self->_exitBy = @"";
        self->_exitScreen = @"";
    }
    return self;
}


@end
