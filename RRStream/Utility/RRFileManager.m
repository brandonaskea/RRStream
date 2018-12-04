//
//  RRFileManager.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import "RRFileManager.h"

@implementation RRFileManager
+(NSURL *)getDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSURL URLWithString:documentsDirectory];
}
+(NSURL *)cachePathForStream:(RRStream *)stream {
    NSURL *baseURL = [NSURL fileURLWithPath:NSHomeDirectory()];
    NSURL *path = [baseURL URLByAppendingPathComponent:stream.cacheURL];
    return path;
}
+(void)moveFileFrom:(NSURL *)fromURL to:(NSURL *)toURL {
//    NSString *url = [[NSString stringWithString:fromURL.absoluteString] substringFromIndex:15];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtURL:fromURL toURL:[NSURL fileURLWithPath:toURL.absoluteString] error:&error];
        if (error) {
            NSLog(@"Error Moving File %@", error.localizedDescription);
        }
    });
}
+(BOOL)deleteDownloadedStream:(RRStream *)stream {
    NSError *error = nil;
    NSURL *cacheURL = [RRFileManager cachePathForStream:stream];
    [[NSFileManager defaultManager] removeItemAtURL:cacheURL error:&error];
    if (error) {
        NSLog(@"Failed to delete stream %@", error.localizedDescription);
        return NO;
    }
    return YES;
}
@end
