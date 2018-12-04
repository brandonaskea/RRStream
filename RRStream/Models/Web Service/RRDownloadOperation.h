//
//  RRDownloadOperation.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRStream+CoreDataClass.h"

@protocol RRDownloadOperationDelegate <NSObject>
-(void)didFinishWithStream:(RRStream *_Nullable)stream withSuccess:(BOOL)success didCancel:(BOOL)didCancel;
@end

NS_ASSUME_NONNULL_BEGIN

@interface RRDownloadOperation : NSOperation
@property (strong, nonatomic) RRStream *stream;
-(id)initWithStream:(RRStream *)stream andDelegate:(id<RRDownloadOperationDelegate>)delegate;
-(void)cancelDownload;
@end

NS_ASSUME_NONNULL_END
