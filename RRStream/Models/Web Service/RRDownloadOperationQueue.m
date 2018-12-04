//
//  RRDownloadOperationQueue.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import "RRDownloadOperationQueue.h"
#import "RRDownloadOperation.h"
#import "RRConstants.h"

@interface RRDownloadOperationQueue() <RRDownloadOperationDelegate>
@property (strong, nonatomic) NSMutableArray *streams;
@property (strong, nonatomic) NSMutableArray *streamOperations;
@property (strong, nonatomic) NSMutableArray *downloadedStreams;
@property (weak, nonatomic) id<RRDownloadOperationQueueDelegate>delegate;
@property (strong, nonatomic) NSMutableString *resultMessage;
@property (strong, nonatomic) RRStream *currentDownloadingStream;
@end

@implementation RRDownloadOperationQueue

-(id)initWithDelegate:(id<RRDownloadOperationQueueDelegate>)delegate {
    self = [super init];
    if (self) {
        self.streams = [NSMutableArray array];
        self.streamOperations = [NSMutableArray array];
        self.downloadedStreams = [NSMutableArray array];
        self.delegate = delegate;
    }
    return self;
}

-(void)addStream:(RRStream *)stream {
    if ([self.streams containsObject:stream]) {
        return;
    }
    [self.streams addObject:stream];
    if (self.operations.count == 0) {
        [self startDownload];
    }
}

-(void)startDownload {
    [self downloadNextStream];
}

-(void)downloadNextStream {
    RRStream *stream = [self nextStream];
    if (stream) {
        [self downloadStream:stream];
    }
    else {
        [self finishedQueue];
    }
}

-(RRStream *)nextStream {
    RRStream *nextStream = self.streams.lastObject;
    return nextStream;
}

-(void)downloadStream:(RRStream *)stream {
    RRDownloadOperation *opertation = [[RRDownloadOperation alloc] initWithStream:stream andDelegate:self];
    self.currentDownloadingStream = stream;
    [self.streamOperations addObject:opertation];
    [self addOperation:opertation];
}

-(void)cancelDownloading:(RRStream *)stream {
    [self.downloadedStreams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RRStream *s = (RRStream *)obj;
        if ([s.identifier isEqualToString:stream.identifier]) {
            [self.downloadedStreams removeObjectAtIndex:idx];
        }
    }];
    [self.streamOperations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RRDownloadOperation *operation = obj;
        if ([operation.stream.identifier isEqualToString:stream.identifier]) {
            [operation cancelDownload];
            [self.streams removeLastObject];
            [self.streamOperations removeObjectAtIndex:idx];
        }
    }];
}

-(void)cancelAllDownloads {
    [self finishedQueue];
}

-(void)finishedQueue {
    [self cancelAllOperations];
    [self.streams removeAllObjects];
    if (self.delegate) {
        [self.delegate didFinishQueueStreams:self.downloadedStreams withMessage:self.resultMessage];
    }
    [self.downloadedStreams removeAllObjects];
    self.currentDownloadingStream = nil;
    self.resultMessage = nil;
}

-(BOOL)hasStream:(RRStream *)stream {
    for (RRStream *s in self.streams) {
        if (s.identifier == stream.identifier) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - RRDownloadOperationDelegate

-(void)didFinishWithStream:(RRStream *)stream withSuccess:(BOOL)success didCancel:(BOOL)didCancel {
    if (!didCancel) {
        NSString *prefix;
        if (success) {
            prefix = kRRDownloadSuccessPrefix;
        }
        else {
            prefix = kRRDownloadFailurePrefix;
        }
        NSString *message = [NSString stringWithFormat:@"%@ %@", prefix, stream.identifier];
        if (self.resultMessage) {
            [self.resultMessage appendString:[NSString stringWithFormat:@"\n%@", message]];
        }
        else {
            self.resultMessage = [NSMutableString stringWithString:message];
        }
        if (success) {
            [self.downloadedStreams addObject:stream];
        }
        [self.streams removeLastObject];
    }
    [self downloadNextStream];
}

@end
