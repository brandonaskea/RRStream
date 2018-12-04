//
//  RRWebServiceTests.m
//  RRStreamTests
//
//  Created by Brandon Askea on 11/6/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RRWebService.h"
#import "RRConstants.h"
#import "RRStream+CoreDataClass.h"
#import "RRCoreData.h"

@interface RRWebServiceTests : XCTestCase <RRWebServiceDowloadDelegate>
@property (strong, nonatomic) RRWebService *webService;
@property (strong, nonatomic) NSMutableArray *downloadedStreams;
@property (strong, nonatomic) XCTestExpectation *downloadCompleteExpectation;
@end

@implementation RRWebServiceTests

- (void)setUp {
    self.webService = [[RRWebService alloc] init];
    self.downloadedStreams = [NSMutableArray array];
}

- (void)tearDown {
    [self.webService cancelAllDownloads];
    [self.downloadedStreams removeAllObjects];
    self.downloadCompleteExpectation = nil;
}

#pragma mark - Getting Streams

- (void)testGettingStreams {
    XCTestExpectation *fetchCompleteExpectation = [self expectationWithDescription:kRRTestGettingID];
    [self.webService getStreamsWithCompletion:^(BOOL success, NSArray * _Nonnull streams) {
        XCTAssert(success);
        [fetchCompleteExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        self.webService = nil;
    }];
}

#pragma mark - Downloading Streams

- (void)testDownloadingStream {
    self.downloadCompleteExpectation = [self expectationWithDescription:kRRTestDownloadingID];
    RRStream *stream = [RRCoreData randomStream];
    [RRWebService.instance downloadStream:stream withDelegate:self];
    [self waitForExpectationsWithTimeout:500 handler:^(NSError *error) {
        self.webService = nil;
        XCTAssert(self.downloadedStreams.count == 0);
    }];
}

-(void)didDownloadStreams:(NSArray *)downloadedStreams withMessage:(NSString *)message {
    self.downloadedStreams = [NSMutableArray arrayWithArray:_downloadedStreams];
    [self.downloadCompleteExpectation fulfill];
}

@end
