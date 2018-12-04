//
//  RRDownloadOperation.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RRDownloadOperation.h"
#import "RRFileManager.h"
#import "RRConstants.h"
#import "RRCoreData.h"

@interface RRDownloadOperation() <AVAssetDownloadDelegate>
@property (strong, nonatomic) AVAssetDownloadURLSession *session;
@property (strong, nonatomic) AVAssetDownloadTask *task;
@property (weak, nonatomic) id<RRDownloadOperationDelegate> delegate;
@property (nonatomic, assign) BOOL hasCancelled;
@end

@implementation RRDownloadOperation

-(id)initWithStream:(RRStream *)stream andDelegate:(id<RRDownloadOperationDelegate>)delegate {
    self = [super init];
    if (self) {
        self.stream = stream;
        self.delegate = delegate;
        self.hasCancelled = NO;
    }
    return self;
}

-(void)main {
    [self cacheStream:self.stream];
}

-(void)cacheStream:(RRStream *)stream {
    NSURL *url = [NSURL URLWithString:stream.url];
    NSString *identifier = stream.identifier;
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    self.session = [AVAssetDownloadURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier] assetDownloadDelegate:self delegateQueue:nil];
    self.task = [self.session assetDownloadTaskWithURLAsset:asset assetTitle:identifier assetArtworkData:nil options:nil];
    [self.task resume];
}

-(void)cancelDownload {
    self.hasCancelled = YES;
    [self closeOut];
}

-(void)closeOut {
    [self cancel];
    [self.task cancel];
    self.task = nil;
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark - AVAssetDownloadDelegate

-(void)URLSession:(NSURLSession *)session assetDownloadTask:(AVAssetDownloadTask *)assetDownloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"didFinishDownloadingToURL");
    if (!self.hasCancelled) {
        [RRCoreData updateStream:self.stream withDownload:location];
        [self.delegate didFinishWithStream:self.stream withSuccess:YES didCancel:self.hasCancelled];
        [self closeOut];
    }
}
@end
