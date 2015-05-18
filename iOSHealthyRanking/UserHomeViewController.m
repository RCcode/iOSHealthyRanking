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
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:_userHomeView];
    scrollView.contentSize = CGSizeMake(ScreenWidth, 567);
    
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.mainurl] placeholderImage:nil];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.headurl] placeholderImage:nil];
    [_lblName setText:_userInfo.facebookname];
    [_lblStepCount setText:[NSString stringWithFormat:@"%d",(int)_userInfo.steps]];
    [_lblStepCount setTextColor:colorWithHexString(@"#ff912c")];
    [_lblTotalSteps setText:[NSString stringWithFormat:@"%d",(int)_userInfo.totalSteps]];
    [_lblTotalSteps setTextColor:colorWithHexString(@"#3ddcc4")];
    [_lblMaxSteps setText:[NSString stringWithFormat:@"%d",(int)_userInfo.maxSteps]];
    [_lblMaxSteps setTextColor:colorWithHexString(@"#3ddcc4")];
    [_lblDescriptionTotalSteps setText:@"The cumulative number of steps"];
    [_lblDescriptionTotalSteps setTextColor:colorWithHexString(@"#acadab")];
    [_lblDescriptionMaxSteps setText:@"On record"];
    [_lblDescriptionMaxSteps setTextColor:colorWithHexString(@"#acadab")];
    [_shareButton setBackgroundColor:colorWithHexString(@"#3ddcc4")];
    
    // Do any additional setup after loading the view from its nib.
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
