//
//  RRConstants.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//


#pragma mark - Stream URLS

#define kRRStreamURLs  [NSArray arrayWithObjects: @"https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",@"http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8",nil]

static NSString* const kRRTestURL = @"http://www.streambox.fr/playlists/test_001/stream.m3u8";

#pragma mark - Titles

static NSString* const kRRStreamsTitle = @"Available Streams";
static NSString* const kRROKTitle = @"OK";
static NSString* const kRRCancelTitle = @"Cancel";

#pragma mark - Messages

typedef enum {
    kRRDownloadingActionCancel, // Downloading
    kRRDownloadingActionDelete, // Downloaded
    kRRDownloadingActionDownload // Download
} RRDownloadAction;

static NSString* const kRRErrorMessageStreams = @"There was an error downloading the streams.";
static NSString* const kRRDownloadMessage = @"Download video?\n(This may take a few minutes)";
static NSString* const kRRDownloadCancelMessage = @"Cancel download?";
static NSString* const kRRDownloadDeleteMessage = @"Delete download?";
static NSString* const kRRDownloadErrorMessage = @"Download was cancelled.";
static NSString* const kRRDeleteErrorMessage = @"Could not delete.";
static NSString* const kRRDownloadSuccessPrefix = @"Downloaded";
static NSString* const kRRDownloadFailurePrefix = @"Did not download";

#pragma mark - Identifiers

static NSString* const kRRStreamCellID = @"StreamCell";
static NSString* const kRRTestDownloadingID = @"DownloadingStream";
static NSString* const kRRTestGettingID = @"GettingStreams";

