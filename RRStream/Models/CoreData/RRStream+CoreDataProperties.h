//
//  RRStream+CoreDataProperties.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//
//

#import "RRStream+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RRStream (CoreDataProperties)

+ (NSFetchRequest<RRStream *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *cacheURL;
@property (nullable, nonatomic, copy) NSString *identifier;
@property (nonatomic) BOOL isDownloaded;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
