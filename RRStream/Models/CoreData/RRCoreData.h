//
//  RRCoreData.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRStream+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRCoreData : NSObject
+(RRStream *)createStreamWith:(NSURL *)url andIdentifier:(NSString *)identifier;
+(void)updateStream:(RRStream *)stream withDownload:(NSURL *)url;
+(RRStream *)fetchStreamWith:(NSURL *)url;
+(NSArray *)fetchCachedStreams;
+(void)save;
+(void)clear;
// For test
+(RRStream *)randomStream;
@end

NS_ASSUME_NONNULL_END
