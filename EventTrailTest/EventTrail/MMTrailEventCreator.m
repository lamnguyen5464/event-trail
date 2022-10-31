//
//  MMTrailEventCreator.m
//
//  Created by lam.nguyen5 on 10/24/22.
//

#import "MMTrailEventCreator.h"

@implementation MMTrailEventCreator

- (instancetype)initWithTrailsHolder:(MMTrailsHolder *)trailsHolder {
    self = [super init];
    if (self) {
        self ->trailsHolder = trailsHolder;
        self->previousEventId = @"";
    }
    return self;
}

- (MMTrailEvent *)createWithName:(NSString *)eventName
                     eventParams:(NSDictionary *)eventParams {

    MMTrail *currentTrail = [self->trailsHolder getCurrentTrail];

    
    NSString *trailId = currentTrail == nil ? nil : [currentTrail trailId];
    NSString *eventId = [self createNewId];
    
    NSMutableDictionary *handledEventParams = [NSMutableDictionary dictionaryWithDictionary:eventParams];
    [handledEventParams setValue:trailId forKey:@"trail_id"];
    [handledEventParams setValue:eventId forKey:@"event_id"];
    [handledEventParams setValue:self->previousEventId forKey:@"prev_event_id"];
    
    
    self->previousEventId = eventId;
    
    MMTrailEvent *event = [MMTrailEvent new];
    event.eventName = eventName;
    event.eventParams = handledEventParams;
    event.trailId = trailId;
    
    return event;
}

# pragma mark -
- (NSString *)createNewId {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return [NSString stringWithFormat:@"trail-event-id-%@", uuid];
}

@end
