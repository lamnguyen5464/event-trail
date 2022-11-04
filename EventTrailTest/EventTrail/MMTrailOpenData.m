//
//  MMTrailOpenData.m
//
//  Created by lam.nguyen5 on 11/4/22.
//

#import "MMTrailOpenData.h"

@implementation MMTrailOpenData


- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_trailData = nil;
        self->_appId = @"";
        self->_entryScope = @"";
        self->_entryType = @"";
        self->_entryAppIdTrigger = @"";
        self->_entryScreenName = @"";
    }
    return self;
}

@end
