//
//  RRCoreDataTests.m
//  RRStreamTests
//
//  Created by Brandon Askea on 11/6/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RRCoreData.h"
#import "RRConstants.h"

@interface RRCoreDataTests : XCTestCase
@property (strong, nonatomic) NSURL *streamURL;
@property (strong, nonatomic) NSString *identifier;
@end

@implementation RRCoreDataTests

- (void)setUp {
    self.streamURL = [NSURL URLWithString:kRRTestURL];
    self.identifier = @"000";
    [RRCoreData clear];
}

- (void)tearDown {
    self.streamURL = nil;
    [RRCoreData clear];
}

- (void)testCreation {
    [RRCoreData createStreamWith:self.streamURL andIdentifier:self.identifier];
    
    NSArray *all = [RRCoreData fetchCachedStreams];
    XCTAssertNotNil(all);
    XCTAssert(all.count > 0);
    
    RRStream *stream = [RRCoreData fetchStreamWith:self.streamURL];
    XCTAssert(stream.url == self.streamURL.absoluteString);
}

- (void)testFetchPerformance {
    [self measureBlock:^{
        [RRCoreData fetchStreamWith: self.streamURL];
    }];
}

@end
