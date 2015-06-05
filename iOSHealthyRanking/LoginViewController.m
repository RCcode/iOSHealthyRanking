//
//  LoginViewController.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "LoginViewController.h"
#import "RankingViewController.h"
#import "WebViewViewController.h"
#import "GuideViewController.h"

@interface LoginViewController ()
{
    BOOL m_isLogined;
    BOOL showGuideThisTime;
}

@property (weak, nonatomic) IBOutlet UIImageView *home_bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(iPhone4)
    {
        [_home_bgImageView setImage:[UIImage imageNamed:@"home_bg960"]];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_btnSignIn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-88];
        [self.view addConstraint:constraint];
    }
    else
    {
        [_home_bgImageView setImage:[UIImage imageNamed:@"home_bg"]];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_btnSignIn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-116];
        [self.view addConstraint:constraint];

    }
    
    showGuideThisTime = NO;
    //    [self fbResync];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
//-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"firstLunch"] && !showGuideThisTime) {
        GuideViewController *guideViewController = [[GuideViewController alloc]init];
        [self presentViewController:guideViewController animated:YES completion:nil];
        showGuideThisTime = YES;
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"firstLunch"];
    }
    
    NSString *isLogin = [[NSUserDefaults standardUserDefaults]objectForKey:@"successLogin"];
    
    if (isLogin && [isLogin integerValue] == 1) {
        
        [[FacebookManager shareManager]loginSuccess:^{
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"successLogin"];
        } andFailed:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        UserInfo *userInfo = [[UserInfo alloc]init];
        NSString *facebookid = [[NSUserDefaults standardUserDefaults]objectForKey:@"facebookid"];
        NSString *facebookname = [[NSUserDefaults standardUserDefaults]objectForKey:@"facebookname"];
        NSString *mainurl = [[NSUserDefaults standardUserDefaults]objectForKey:@"mainurl"];
        NSString *headurl = [[NSUserDefaults standardUserDefaults]objectForKey:@"headurl"];
        if (facebookid) {
            userInfo.facebookid = facebookid;
        }
        if (facebookname) {
            userInfo.facebookname = facebookname;
        }
        if (mainurl) {
            userInfo.mainurl = mainurl;
        }
        if (headurl) {
            userInfo.headurl = headurl;
        }
        
        RankingViewController *rankingViewController = [[RankingViewController alloc]init];
        rankingViewController.userInfo = userInfo;
        RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:rankingViewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (IBAction)loginFacebook:(id)sender {
    [IS_MobAndAnalyticsManager event:@"sign for Facebook" label:nil];
     __weak LoginViewController *weakSelf = self;
    [[FacebookManager shareManager]loginSuccess:^{
        [weakSelf successLogin];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"successLogin"];
    } andFailed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)successLogin
{    
    RankingViewController *rankingViewController = [[RankingViewController alloc]init];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:rankingViewController];
    rankingViewController.userInfo = [[UserInfo alloc]init];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)showTermsOfService:(id)sender {
    WebViewViewController *webViewController = [[WebViewViewController alloc]init];
    webViewController.url = @"http://privacy.rcplatformhk.com/policy/SportsForFacebooks_TermsofService.html";
    [self presentViewController:webViewController animated:YES completion:nil];
}

- (IBAction)showPrivacyPolicy:(id)sender {
    WebViewViewController *webViewController = [[WebViewViewController alloc]init];
    webViewController.url = @"http://privacy.rcplatformhk.com/policy/SportsForFacebook.html";
    [self presentViewController:webViewController animated:YES completion:nil];
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
