//
//  MMUtils.h
//  ReactNativeAnalytics
//
//  Created by Nguyễn Văn Thuận on 18/10/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMUtils : NSObject

+ (NSString*) getTimestamp;
+ (const char *) getDatabsePath;
+ (long) getTimeStampLong;
+ (NSString*) getUniqueId;
+ (NSString*) getLocale;
+ (NSString*) getDateString: (NSDate*) date;
+ (unsigned int) getUTF8Length: (NSString*) message;
+ (NSDictionary<NSString*, id>*) serializeDict: (nullable NSDictionary<NSString*, id>*) dict;
+ (NSArray*) serializeArray: (NSArray*) array;

+ (NSString*) encodeToBase64:(NSString*) stringToEncode;
+ (NSString*) decodeFromBase64:(NSString*) stringToDecode;
+ (NSString*) convertToJsonString:(NSDictionary<NSString*, NSObject*>*) dict;

+ (dispatch_source_t)startTimer:(dispatch_queue_t)queue
                   withInterval:(double)interval /* in seconds */
                          block:(dispatch_block_t)block;

+ (void)stopTimer:(dispatch_source_t)timer;

@end

NS_ASSUME_NONNULL_END
