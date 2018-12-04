//
//  RRStreamsTableViewCell.h
//  RRStream
//
//  Created by Brandon Askea on 11/5/18.
//  Copyright © 2018 Brandon Askea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRStream+CoreDataClass.h"
#import "RRConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRStreamsTableViewCell : UITableViewCell
-(void)configureWithStream:(RRStream *)stream;
-(void)updateForAction:(RRDownloadAction)action;
@end

NS_ASSUME_NONNULL_END
