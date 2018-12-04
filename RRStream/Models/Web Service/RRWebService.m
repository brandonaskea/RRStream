//
//  RRWebService.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RRDownloadOperationQueue.h"
#import "RRFileManager.h"
#import "RRWebService.h"
#import "RRConstants.h"
#import "RRCoreData.h"

@interface RRWebService() <RRDownloadOperationQueueDelegate>
@property (strong, nonatomic) RRDownloadOperationQueue *queue;
@property (strong, nonatomic) NSMutableArray *downloadedStreams;
@end

@implementation RRWebService

+(id)instance {
    static RRWebService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.queue = [[RRDownloadOperationQueue alloc] initWithDelegate:instance];
    });
    return instance;
}

-(void)getStreamsWithCompletion:(RRStreamsBlock)completion {
    // Do Webservice call to download list of streams, Dummy for assignment
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger increment = 1;
    for (NSString *urlString in kRRStreamURLs) {
        NSURL *url = [NSURL URLWithString:urlString];
        RRStream *stream = [RRCoreData fetchStreamWith:url];
        if (!stream) {
            stream = [RRCoreData createStreamWith:url andIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)increment]];
        }
        [result addObject:stream];
        increment ++;
    }
    completion(YES, result);
}

-(void)downloadStream:(RRStream *)stream withDelegate:(id<RRWebServiceDowloadDelegate>)delegate {
    self.delegate = delegate;
    [self.queue addStream:stream];
}

-(void)cancelDownloading:(RRStream *)stream {
    if (self.queue) {
        [self.queue cancelDownloading:stream];
    }
}

-(void)cancelAllDownloads {
    if (self.queue) {
        [self.queue cancelAllDownloads];
    }
}

-(BOOL)isDownloadingStream:(RRStream *)stream {
    if (self.queue) {
        if ([self.queue hasStream:stream]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - RRDownloadOperationQueueDelegate
-(void)didFinishQueueStreams:(NSArray *)streams withMessage:(NSString *)message {
    self.downloadedStreams = [NSMutableArray arrayWithArray:streams];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didDownloadStreams:self.downloadedStreams withMessage:message];
    });
}

@end
