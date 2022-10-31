//
//  MMEventTrailPusher.m
//
//  Created by lam.nguyen5 on 10/31/22.
//

#import "MMEventTrailPusher.h"

@implementation MMEventTrailPusher

typedef enum {
    NETWORK_SUCCESS       = 0,
    NETWORK_ERROR         = 1,
    NETWORK_INVALID_TOKEN = 2,
} NETWORK_STATE;

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}


- (BOOL)pushEvents:(NSArray<MMStorePersistedTrailEvent *> *)events {
    NSMutableArray<NSString *> *parsedEvents = [NSMutableArray new];
    for (MMStorePersistedTrailEvent *event in events) {
        [parsedEvents addObject:event.eventBundle];
    }
    
    NSString *payload = [NSString stringWithFormat:@"[%@]", [parsedEvents componentsJoinedByString:@","]];
    
    NSLog(@"[TrailEvent] push events: %@", payload);
    
    [self __sendsEventsToServerInternal:payload];
    
    return YES;
}

- (void)sendEventsToServer
{

    NSString* payload = @""; // [self buildPayload:persistedEvents.events];
  if (payload && payload.length > 0 && ![payload isEqualToString:@"[]"]) {
    int status = [self __sendsEventsToServerInternal:payload];
    if (status == NETWORK_SUCCESS) {
//      [MMLogger logDebug:@"MMEventPusher sendEventsToServer: SUCCEEDED"];
    } else {
//      [MMLogger logDebug:@"MMEventPusher sendEventsToServer: FAILED"];
    }
  }
}

- (int) __sendsEventsToServerInternal:(NSString*)payload
{
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
//  NSString* endpointURL = [_configs.baseURL stringByAppendingString:@"/v2/send"];
    NSString* endpointURL = @"https://miniapp.dev.mservice.io/rigver-appversion/v1/features?last_update=0";// _configs.apiEndpoint;
//  [MMLogger logDebug:[[NSString alloc] initWithFormat:@"endPointToFlush %@", endpointURL]];
  
  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:endpointURL]];
  [urlRequest setHTTPMethod:@"GET"];
  [urlRequest addValue:@"Application/json" forHTTPHeaderField:@"Content-Type"];
  [urlRequest addValue:@"Application/json" forHTTPHeaderField:@"Accept"];
//  [urlRequest addValue:[[NSString alloc] initWithFormat:@"Bearer %@", _configs.apiToken] forHTTPHeaderField:@"Authorization"];
//  [urlRequest setTimeoutInterval:(_configs.requestTimeoutMillis/1000)];
  [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  // Accept GZIP content from server response.
  [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"]; // Compress GZIP content to server
  
  NSData *httpBody = [payload dataUsingEncoding:NSUTF8StringEncoding];
  [urlRequest setHTTPBody:httpBody];
  
  int __block respStatus = NETWORK_SUCCESS;
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
      NSLog(@"statusCode %ld", (long)httpResponse.statusCode);
      if (200 == httpResponse.statusCode) {
          respStatus = NETWORK_SUCCESS;
      } else {
//        NSString *errorResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        respStatus = NETWORK_ERROR;
//        [MMLogger logError:[[NSString alloc] initWithFormat:@"ServerError: %@", errorResponse]];
      }
      dispatch_semaphore_signal(semaphore);
  }];
  [dataTask resume];
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  
#if !__has_feature(objc_arc)
  dispatch_release(semaphore);
#endif
  
  return respStatus;
}

@end
