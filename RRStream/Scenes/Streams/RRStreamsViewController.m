//
//  RRStreamsViewController.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "RRStreamsViewController.h"
#import "RRConstants.h"
#import "RRWebService.h"
#import "RRStreamsTableViewCell.h"
#import "RRCoreData.h"
#import "RRFileManager.h"

@interface RRStreamsViewController () <RRWebServiceDowloadDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *streams;
@end

@implementation RRStreamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self loadData];
}

-(void)presentAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:kRROKTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SetUp

-(void)setUpUI {
    // Set Title
    self.title = kRRStreamsTitle;
    // Place Gesture
    UILongPressGestureRecognizer *gest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewLongPressed:)];
    gest.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:gest];
}

-(void)loadData {
    
    BOOL hasInternet = YES;
    
    // Clear Streams
    if (self.streams) {
        [self.streams removeAllObjects];
    }
    else {
        self.streams = [NSMutableArray array];
    }
    
    if (hasInternet) {
        // Get Streams
        [RRWebService.instance getStreamsWithCompletion:^(BOOL success, NSArray * _Nonnull streams) {
            if (success) {
                self.streams = [NSMutableArray arrayWithArray:streams];
                [self.tableView reloadData];
            }
            else {
                [self presentAlertWithMessage:kRRErrorMessageStreams];
            }
        }];
    }
    else {
        // Retreive Any Stored
        self.streams = [NSMutableArray arrayWithArray:[RRCoreData fetchCachedStreams]];
    }
}

-(NSIndexPath *)indexPathForStream:(RRStream *)stream {
    NSUInteger index = [self.streams indexOfObject:stream];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return indexPath;
}

#pragma mark - UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.streams.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRStream *stream = self.streams[indexPath.row];
    RRStreamsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRRStreamCellID];
    [cell configureWithStream:stream];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RRStream *stream = self.streams[indexPath.row];
    AVPlayer *player;
    if (stream.isDownloaded && stream.cacheURL) {
        NSURL *path = [RRFileManager cachePathForStream:stream];
        AVURLAsset *asset = [AVURLAsset assetWithURL:path];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        player = [AVPlayer playerWithPlayerItem:item];
    }
    else {
        player = [AVPlayer playerWithURL:[NSURL URLWithString:stream.url]];
    }
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:^{
        [player play];
    }];
}

-(void)tableViewLongPressed:(UILongPressGestureRecognizer *)gest {
    CGPoint press = [gest locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:press];
    if (indexPath == nil) {
        NSLog(@"Missed Row!");
    } else if (gest.state == UIGestureRecognizerStateBegan) {
        RRStream *stream = self.streams[indexPath.row];
        NSString *message = @"";
        RRDownloadAction downloadAction = kRRDownloadingActionDownload;
        if ([RRWebService.instance isDownloadingStream:stream]) {
            downloadAction = kRRDownloadingActionCancel;
            message = kRRDownloadCancelMessage;
        }
        else if (stream.isDownloaded) {
            downloadAction = kRRDownloadingActionDelete;
            message = kRRDownloadDeleteMessage;
        }
        else {
            downloadAction = kRRDownloadingActionDownload;
            message = kRRDownloadMessage;
        }
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:kRROKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            RRStreamsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[self indexPathForStream:stream]];
            switch (downloadAction) {
                case kRRDownloadingActionCancel:
                    stream.cacheURL = nil;
                    stream.isDownloaded = NO;
                    [RRWebService.instance cancelDownloading:stream];
                    [cell configureWithStream:stream];
                    break;
                case kRRDownloadingActionDownload:
                    [cell updateForAction:kRRDownloadingActionCancel];
                    [RRWebService.instance downloadStream:stream withDelegate:self];
                    break;
                case kRRDownloadingActionDelete:
                    if ([RRFileManager deleteDownloadedStream:stream]) {
                        stream.cacheURL = nil;
                        stream.isDownloaded = NO;
                        for (RRStream *s in self.streams) {
                            if ([s.identifier isEqualToString:stream.identifier]) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (cell) {
                                        [cell updateForAction:kRRDownloadingActionDownload];
                                    }
                                });
                                break;
                            }
                        }
                    }
                    else {
                        [self presentAlertWithMessage:kRRDeleteErrorMessage];
                    }
                    break;
                default:
                    break;
            }
            [RRCoreData save];
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:kRRCancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [actionSheet dismissViewControllerAnimated:true completion:nil];
        }]];
        [self presentViewController:actionSheet animated:true completion:nil];
    } else {
        NSLog(@"gest state = %ld", (long)gest.state);
    }
}

#pragma mark - RRWebServiceDownloadDelegate

-(void)didDownloadStreams:(NSArray *)downloadedStreams withMessage:(NSString *)message {
    
    BOOL hasDownloaded = YES;
    if (downloadedStreams.count == 0) {
        hasDownloaded = NO;
    }
    // Update UITableView
    for (RRStream *stream in downloadedStreams) {
        NSIndexPath *indexPath = [self indexPathForStream:stream];
        RRStreamsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            if (hasDownloaded) {
                [cell updateForAction:kRRDownloadingActionDelete];
            }
            else {
                [cell updateForAction:kRRDownloadingActionDownload];
            }
        }
    }
    
    // Display Message
    if (hasDownloaded) {
        [self presentAlertWithMessage:message];
    }
}

@end
