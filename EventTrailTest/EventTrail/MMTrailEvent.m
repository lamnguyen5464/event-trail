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

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self->_eventId forKey:@"event_id"];
    [dict setValue:self->_trailId forKey:@"trail_id"];
    [dict setValue:self->_previousEventId forKey:@"prev_event_id"];
    [dict setValue:self->_eventName forKey:@"event_name"];
    [dict setValue:self->_eventParams forKey:@"event_params"];
    return dict;
}


@end
