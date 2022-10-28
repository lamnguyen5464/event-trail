//
//  MMPersister.h
//
//  Created by lam.nguyen5 on 10/28/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MMPersister <NSObject>

- (void)persist:(id<NSObject>)data;

@end



NS_ASSUME_NONNULL_END
