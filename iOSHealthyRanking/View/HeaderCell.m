//
//  HeaderCell.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "HeaderCell.h"

@interface HeaderCell ()

@end


@implementation HeaderCell

- (void)awakeFromNib {
    _userIconImageView.layer.cornerRadius = CGRectGetHeight(_userIconImageView.frame)/2;
    _userIconImageView.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
