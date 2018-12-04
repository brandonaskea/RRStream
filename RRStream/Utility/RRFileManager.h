//
//  RRFileManager.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRStream+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRFileManager : NSObject
+(void)moveFileFrom:(NSURL *)fromURL to:(NSURL *)toURL;
+(NSURL *)cachePathForStream:(RRStream *)stream;
+(BOOL)deleteDownloadedStream:(RRStream *)stream;
@end

NS_ASSUME_NONNULL_END
