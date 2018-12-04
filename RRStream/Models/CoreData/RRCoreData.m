//
//  RRCoreData.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import "AppDelegate.h"
#import "RRCoreData.h"

@implementation RRCoreData

+(RRStream *)createStreamWith:(NSURL *)url andIdentifier:(NSString *)identifier {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RRStream *stream = (RRStream *)[NSEntityDescription insertNewObjectForEntityForName:@"RRStream" inManagedObjectContext:[appDelegate.persistentContainer viewContext]];
    stream.url = url.absoluteString;
    stream.identifier = identifier;
    [RRCoreData save];
    return stream;
}

+(RRStream *)fetchStreamWith:(NSURL *)url {
    // Why does predicate not work in ObjC?
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RRStream"];
//    request.predicate = [NSPredicate predicateWithFormat:@"url ==[c] '@%'", url.absoluteString];
//    NSError *error = nil;
//    NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&error];
//    if (!results) {
//        NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
//        return nil;
//    }
    for (RRStream *stream in [RRCoreData fetchCachedStreams]) {
        if ([stream.url  isEqualToString: url.absoluteString]) {
            return stream;
        }
    }
    return nil;
}

+(NSArray *)fetchCachedStreams {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RRStream"];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES]];
    NSError *error = nil;
    NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    return results;
}

+(void)updateStream:(RRStream *)stream withDownload:(NSURL *)url {
    stream.isDownloaded = YES;
    stream.cacheURL = url.relativePath;
    [RRCoreData save];
}

+(void)save {
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate saveContext];
    });
}

+(void)clear {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RRStream"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError = nil;
    [appDelegate.persistentContainer.persistentStoreCoordinator executeRequest:delete withContext:appDelegate.persistentContainer.viewContext error:&deleteError];
}

+(RRStream *)randomStream {
    return [RRCoreData fetchCachedStreams].firstObject;
}

@end
