//
//  RRStream.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import "RRStream.h"

@interface RRStream()


@end

@implementation RRStream
-(id)initWithURL:(NSURL *)url {
    self = [super init];
    if(self) {
        self.url = url;
    }
    return self;
}
@end
