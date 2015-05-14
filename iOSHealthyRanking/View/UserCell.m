//
//  UserCell.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "UserCell.h"

@interface UserCell ()


@end

@implementation UserCell

- (void)awakeFromNib {
    [_lineView setBackgroundColor:colorWithHexString(@"#ececec")];
    [_lblUserName setFont:[UIFont systemFontOfSize:18]];
    [_lblUserName setTextColor:colorWithHexString(@"#626460")];
    [_lblStepCount setFont:[UIFont systemFontOfSize:15]];
    [_lblStepCount setTextColor:colorWithHexString(@"#b9b8b6")];
    _userIconImageView.layer.cornerRadius = CGRectGetHeight(_userIconImageView.frame)/2;
    _userIconImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
