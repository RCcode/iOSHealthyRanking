//
//  UserCell.h
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *lblRankingId;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblStepCount;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@end
