//
//  MMTrailEvent.m
//
//  Created by lam.nguyen5 on 10/20/22.
//

#import "MMTrailEvent.h"

@implementation MMTrailEvent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_eventId = @"";
        self->_trailId = @"";
        self->_previousEventId = @"";
        self->_eventName = @"";
        self->_eventParams = @"";
    }
    return self;
}


@end
