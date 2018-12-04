//
//  RRStream.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRStream : NSObject
@property (strong, nonatomic) NSURL *url;
-(id)initWithURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
