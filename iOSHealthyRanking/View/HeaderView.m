//
//  HeaderView.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

+ (id)instanceHeaderView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
