//
//  RRDownloadOperationQueue.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRStream+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RRDownloadOperationQueueDelegate <NSObject>
-(void)didFinishQueueStreams:(NSArray *) streams withMessage:(NSString *)message;
@end

@interface RRDownloadOperationQueue : NSOperationQueue
-(id)initWithDelegate:(id<RRDownloadOperationQueueDelegate>)delegate;
-(void)cancelDownloading:(RRStream *)stream;
-(void)cancelAllDownloads;
-(void)addStream:(RRStream *)stream;
-(BOOL)hasStream:(RRStream *)stream;
-(void)startDownload;
@end

NS_ASSUME_NONNULL_END
