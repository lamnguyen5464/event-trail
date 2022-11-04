//
//  MMTrailFinishMeta.m
//
//  Created by lam.nguyen5 on 11/4/22.
//

#import "MMTrailFinishMeta.h"

@implementation MMTrailFinishMeta

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_appId = @"";
        self->_exitBy = @"";
        self->_exitScreen = @"";
    }
    return self;
}


@end
