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
        self->_eventName = @"";
        self->_trailId = @"";
        self->_eventParams = [NSDictionary dictionary];
    }
    return self;
}

- (MMStorePersistedTrailEvent *)toPersistModel {
    MMStorePersistedTrailEvent *persistedData = [MMStorePersistedTrailEvent new];
    persistedData.eventId = self->_eventId;
    persistedData.trailId = self->_trailId;
    persistedData.eventName = self->_eventName;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self->_eventName forKey:@"event_name"];
    [dict setValue:self->_eventParams forKey:@"event_params"];
    
    
    persistedData.eventBundle = [MMUtils convertToJsonString:dict];
    
    return persistedData;
}


@end
