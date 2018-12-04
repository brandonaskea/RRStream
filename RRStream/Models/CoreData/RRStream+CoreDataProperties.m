//
//  RRStream+CoreDataProperties.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//
//

#import "RRStream+CoreDataProperties.h"

@implementation RRStream (CoreDataProperties)

+ (NSFetchRequest<RRStream *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RRStream"];
}

@dynamic cacheURL;
@dynamic identifier;
@dynamic isDownloaded;
@dynamic url;

@end
