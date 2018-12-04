//
//  RRStreamsTableViewCell.m
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import "RRStreamsTableViewCell.h"
#import "RRWebService.h"

@interface RRStreamsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation RRStreamsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
    [self.activityIndicator setHidden:NO];
}

-(void)configureWithStream:(RRStream *)stream {
    self.cellLabel.text = stream.identifier;
    self.urlLabel.text = stream.url;
    if ([RRWebService.instance isDownloadingStream:stream]) {
        [self updateForAction:kRRDownloadingActionCancel];
    }
    else if (stream.isDownloaded) {
        [self updateForAction:kRRDownloadingActionDelete];
    }
    else {
        [self updateForAction:kRRDownloadingActionDownload];
    }
}

-(void)updateForAction:(RRDownloadAction)action {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (action) {
            case kRRDownloadingActionCancel:
                // Cancel is downloading
                [self.activityIndicator setHidden:NO];
                [self.activityIndicator startAnimating];
                self.accessoryType = UITableViewCellAccessoryNone;
                break;
            case kRRDownloadingActionDelete:
                // Ready for delete is downloaded
                [self.activityIndicator setHidden:YES];
                self.accessoryType = UITableViewCellAccessoryCheckmark;
                break;
            case kRRDownloadingActionDownload:
                // Download is none
                [self.activityIndicator setHidden:YES];
                self.accessoryType = UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    });
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.cellLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
    [self.activityIndicator setHidden:NO];
}

@end
