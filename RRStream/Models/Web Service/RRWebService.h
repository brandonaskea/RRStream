//
//  RRWebService.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRStream+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RRStreamsBlock)(BOOL success, NSArray *streams);

@protocol RRWebServiceDowloadDelegate <NSObject>

-(void)didDownloadStreams:(NSArray *)downloadedStreams withMessage:(NSString *)message;

@end

@interface RRWebService : NSObject
@property (weak, nonatomic) id<RRWebServiceDowloadDelegate> delegate;
+(id)instance;
-(void)getStreamsWithCompletion:(RRStreamsBlock)completion;
-(void)downloadStream:(RRStream *)stream withDelegate:(id<RRWebServiceDowloadDelegate>)delegate;
-(void)cancelDownloading:(RRStream *)stream;
-(void)cancelAllDownloads;
-(BOOL)isDownloadingStream:(RRStream *)stream;
@end

NS_ASSUME_NONNULL_END
