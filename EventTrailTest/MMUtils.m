//
//  MMUtils.m
//  ReactNativeAnalytics
//
//  Created by Nguyễn Văn Thuận on 18/10/2021.
//

#import "MMUtils.h"

@implementation MMUtils

+ (NSString*) getDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"UTC"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) getTimestamp
{
    return [MMUtils getDateString:[[NSDate alloc] init]];
}

+ (const char *) getDatabsePath
{
    NSURL *urlDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask][0];
    NSURL *fileUrl = [urlDirectory URLByAppendingPathComponent:@"events.sqlite"];
    return [[fileUrl path] UTF8String];
}

+ (long) getTimeStampLong
{
    NSDate *date = [[NSDate alloc] init];
    return [date timeIntervalSince1970];
}

+ (NSString *) getUniqueId
{
    NSUUID *uuid = [NSUUID UUID];
    return [[uuid UUIDString] lowercaseString];
}

+ (NSString*) getLocale
{
    NSLocale *locale = [NSLocale currentLocale];
    if (@available(iOS 10.0, *)) {
        return [[NSString alloc] initWithFormat:@"%@-%@", [locale languageCode], [locale countryCode]];
    } else {
        // Fallback on earlier versions
        return @"NA";
    }
}

+ (unsigned int) getUTF8Length:(NSString *)message
{
    return (unsigned int)[[message dataUsingEncoding:NSUTF8StringEncoding] length];
}

+ (id) serializeValue: (id) val
{
    if ([val isKindOfClass:[NSString class]] ||
        [val isKindOfClass:[NSNumber class]] ||
        [val isKindOfClass:[NSNull class]]
        ) {
        return val;
    } else if ([val isKindOfClass:[NSArray class]]) {
        // handle array
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (id i in val) {
            [array addObject:[self serializeValue:i]];
        }
        return [array copy];
    } else if ([val isKindOfClass:[NSDictionary class]] ||
               [val isKindOfClass:[NSMutableDictionary class]]
               ) {
        // handle dictionary
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSArray *keys = [val allKeys];
        for (NSString *key in keys) {
            id value = [val objectForKey:key];
            if (![key isKindOfClass:[NSString class]]) {
//                [MMLogger logDebug:@"key should be string. changing it to its description"];
            }
            [dict setValue:[self serializeValue:value] forKey:[key description]];
        }
        return [dict copy];
    } else if ([val isKindOfClass:[NSDate class]]) {
        // handle date // isofy
        return [self getDateString:val];
    } else if ([val isKindOfClass:[NSURL class]]) {
        // handle url
        return [val absoluteString];
    }
//    [MMLogger logDebug:@"properties value is not serializable. using description"];
    return [val description];
}

+ (NSDictionary<NSString *,id> *)serializeDict:(NSDictionary<NSString*, id>*)dict
{
    // if dict is not null
    if (dict) {
        NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] initWithCapacity:dict.count];
        NSArray *keys = [dict allKeys];
        for (NSString* key in keys) {
            id val = [self serializeValue: [dict objectForKey:key]];
            [returnDict setValue:val forKey:key];
        }
        
        return [returnDict copy];
    }
    return dict;
}

+ (NSArray*) serializeArray:(NSArray*) array
{
    if (array) {
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        for (id i in array) {
            [returnArray addObject:[self serializeValue:i]];
        }
        return [returnArray copy];
    }
    return array;
}

+ (NSString*) encodeToBase64:(NSString*)stringToEncode
{
  NSData* dataToEncode = [stringToEncode dataUsingEncoding:NSUTF8StringEncoding];
  NSString* base64EncodedString = [dataToEncode base64EncodedStringWithOptions:0];
  return base64EncodedString;
}

+ (NSString*) decodeFromBase64:(NSString*)stringToDecode
{
  NSData* dataToDecode = [[NSData alloc]initWithBase64EncodedString:stringToDecode options:0];
  NSString* base64Decoded = [[NSString alloc] initWithData:dataToDecode encoding:NSUTF8StringEncoding];
  return base64Decoded;
}

+ (NSString*) convertToJsonString:(NSDictionary<NSString*, NSObject*>*) dict
{
  if (dict) {
    @try {
      NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
      NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
      return jsonString;
    } @catch (NSException *exception) {
      return @"{}";
    }
  }
  return @"{}";
}

+ (dispatch_source_t)startTimer:(dispatch_queue_t)queue
                   withInterval:(double)interval /* in seconds */
                          block:(dispatch_block_t)block
{
  dispatch_source_t timer = dispatch_source_create(
    DISPATCH_SOURCE_TYPE_TIMER, // source type
    0, // handle
    0, // mask
    queue
  ); // queue

  dispatch_source_set_timer(
    timer, // dispatch source
    dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), // start
    interval * NSEC_PER_SEC, // interval
    0 * NSEC_PER_SEC
  ); // leeway

  dispatch_source_set_event_handler(timer, block);

  dispatch_resume(timer);

  return timer;
}

+ (void)stopTimer:(dispatch_source_t)timer
{
  if (timer) {
    dispatch_source_cancel(timer);
  }
}

@end
