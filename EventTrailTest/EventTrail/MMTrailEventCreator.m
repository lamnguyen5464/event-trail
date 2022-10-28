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
                     eventParams:(NSString *)eventParams {
    MMTrailEvent *event = [MMTrailEvent new];
    MMTrail *currentTrail = [self->trailsHolder getCurrentTrail];
    event.eventName = eventName;
    event.eventParams = eventParams;
    event.trailId = currentTrail == nil ? nil : [currentTrail trailId];
    event.eventId = [self createNewId];
    event.previousEventId = self->previousEventId;
    
    self->previousEventId = event.eventId;
    return event;
}

# pragma mark -
- (NSString *)createNewId {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return [NSString stringWithFormat:@"trail-event-id-%@", uuid];
}

@end
