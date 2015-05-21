//
//  UserHomeViewController.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "UserHomeViewController.h"

@interface UserHomeViewController ()

@property (strong, nonatomic) IBOutlet UIView *userHomeView;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStepCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSteps;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxSteps;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionTotalSteps;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionMaxSteps;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIView *lineH1;
@property (weak, nonatomic) IBOutlet UIView *lineH2;
@property (weak, nonatomic) IBOutlet UIView *lineH3;
@property (weak, nonatomic) IBOutlet UIView *lineV1;

@property (weak, nonatomic) IBOutlet UIButton *btnToday;

@end

@implementation UserHomeViewController

-(void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:_userHomeView];
    scrollView.contentSize = CGSizeMake(ScreenWidth, 569);
    
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.mainurl] placeholderImage:[UIImage imageNamed:@"pic_top"]];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.headurl] placeholderImage:[UIImage imageNamed:@"people"]];
    _headImageView.layer.cornerRadius = CGRectGetWidth(_headImageView.frame)/2;
    _headImageView.clipsToBounds = YES;
    [_lblName setText:_userInfo.facebookname];
    [_lblName setTextColor:colorWithHexString(@"#367920")];
    [_lblName setFont:[UIFont boldSystemFontOfSize:18]];
    [_lblStepCount setText:[NSString stringWithFormat:@"%d",(int)_userInfo.steps]];
    [_lblStepCount setTextColor:colorWithHexString(@"#ff912c")];
    [_lblStepCount setFont:[UIFont boldSystemFontOfSize:30]];
    [_lblTotalSteps setText:[NSString stringWithFormat:@"%d",(int)_userInfo.totalSteps]];
    [_lblTotalSteps setTextColor:colorWithHexString(@"#3ddcc4")];
    [_lblTotalSteps setFont:[UIFont boldSystemFontOfSize:25]];
    [_lblMaxSteps setText:[NSString stringWithFormat:@"%d",(int)_userInfo.maxSteps]];
    [_lblMaxSteps setTextColor:colorWithHexString(@"#3ddcc4")];
    [_lblMaxSteps setFont:[UIFont boldSystemFontOfSize:25]];
    [_lblDescriptionTotalSteps setText:@"Step count"];
    [_lblDescriptionTotalSteps setTextColor:colorWithHexString(@"#626460")];
    [_lblDescriptionTotalSteps setFont:[UIFont boldSystemFontOfSize:14]];
    [_lblDescriptionTotalSteps setNumberOfLines:0];
    [_lblDescriptionMaxSteps setText:@"The highest in a week"];
    [_lblDescriptionMaxSteps setTextColor:colorWithHexString(@"#626460")];
    [_lblDescriptionMaxSteps setFont:[UIFont boldSystemFontOfSize:14]];
    
    
    [_shareButton setBackgroundColor:colorWithHexString(@"#3ddcc4")];
    [_shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    if (_canShare) {
        _shareButton.hidden = NO;
    }
    else
    {
        _shareButton.hidden = YES;
    }
    [_lineH1 setBackgroundColor:colorWithHexString(@"#ebebeb")];
    [_lineH2 setBackgroundColor:colorWithHexString(@"#ebebeb")];
    [_lineH3 setBackgroundColor:colorWithHexString(@"#ebebeb")];
    [_lineV1 setBackgroundColor:colorWithHexString(@"#ebebeb")];
    [_btnToday setTitleColor:colorWithHexString(@"626460") forState:UIControlStateNormal];
    _btnToday.titleLabel.font = [UIFont systemFontOfSize:13];
    // Do any additional setup after loading the view from its nib.
}

-(void)share
{
    NSString *desc = [NSString stringWithFormat:@"我今天跑了%d步,如果想和我一起比赛的话，下载地址",(int)_userInfo.steps];
    [[FacebookManager shareManager]shareToFacebookWithName:@"快来和我比拼" caption:@"Sports for Facebook" desc:desc link:@"http://bit.ly/1uYvgiC" picture:@""];
}

- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
