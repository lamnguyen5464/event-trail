//
//  MMStorePersistedTrailEvent.m
//
//  Created by lam.nguyen5 on 10/31/22.
//

#import "MMStorePersistedTrailEvent.h"

@implementation MMStorePersistedTrailEvent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_eventId = @"";
        self->_eventName = @"";
        self->_trailId = @"";
        self->_eventBundle = @"";
    }
    return self;
}

@end
