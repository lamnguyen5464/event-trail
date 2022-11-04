//
//  MMTrailOpenMeta.m
//
//  Created by lam.nguyen5 on 11/4/22.
//

#import "MMTrailOpenMeta.h"

@implementation MMTrailOpenMeta

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_appId = @"";
        self->_entryScope = @"";
        self->_entryType = @"";
        self->_entryAppIdTrigger = @"";
        self->_entryScreenName = @"";
    }
    return self;
}

@end
