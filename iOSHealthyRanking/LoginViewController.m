//
//  LoginViewController.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "LoginViewController.h"
#import "RankingViewController.h"

@interface LoginViewController ()
{
    BOOL m_isLogined;
}

@property (weak, nonatomic) IBOutlet UILabel *lblInterFaceExplain;
@property (weak, nonatomic) IBOutlet UILabel *lblRCplatformTM;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblInterFaceExplain setText:@"This product uses Facebook API but is not endorsed or certified by Facebook"];
    [_lblInterFaceExplain setTextColor:colorWithHexString(@"#838079")];
    _lblInterFaceExplain.numberOfLines = 0;
    
    [_lblRCplatformTM setText:@"RCPLATFORM TM"];
    [_lblRCplatformTM setTextColor:colorWithHexString(@"#838079")];
//    [self fbResync];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)loginFacebook:(id)sender {
//    [self login];
     __weak LoginViewController *weakSelf = self;
    [[FacebookManager shareManager]loginSuccess:^{
        [weakSelf successLogin1];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"successLogin"];
    } andFailed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)successLogin1
{
//    [[FacebookManager shareManager] getUserInfoSuccess:^(NSDictionary *userInfo) {
//        NSLog(@"%@",userInfo);
//    } andFailed:^(NSError *error) {
//        
//    }];
//    [[FacebookManager shareManager] loadfriendsSuccess:^(NSArray *friends) {
//        NSLog(@"%@",friends);
//    } andFailed:^(NSError *error) {
//        
//    }];
//    [[FacebookManager shareManager] getCoverGraphPathSuccess:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//    } andFailed:^(NSError *error) {
//        
//    }];
//    [[FacebookManager shareManager] getHeadPicturePathSuccess:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//    } andFailed:^(NSError *error) {
//        
//    }];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjects:@[@"1000009",@"20150514",@"560",@"6",@"1980",@"5000",@"549001",@"usename8",@"http://8",@"http://28"] forKeys:@[@"facebookid",@"dateid",@"steps",@"floors",@"distance",@"maxSteps",@"totalSteps",@"facebookname",@"headurl",@"mainurl"]];
//    [[RC_RequestManager shareInstance]postUserDate:dic success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } andFailed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    
//    
//    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@[@"1000007",@"1000006"],@"facebookid",@"20150513",@"dateid", nil];
//    [[RC_RequestManager shareInstance]getRanking:dic1 success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } andFailed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    RankingViewController *rankingViewController = [[RankingViewController alloc]init];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:rankingViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////


-(void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                }
            }];
        }
    }
}

-(void)login
{
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here
        
//        NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
//        [FBSession openActiveSessionWithPublishPermissions:permissions
//                                                  defaultAudience:FBSessionDefaultAudienceFriends
//                                                     allowLoginUI:YES
//                                                completionHandler:^(FBSession *session,
//                                                                    FBSessionState state,
//                                                                    NSError *error) {
//                                                    
//                                                }];
        __weak LoginViewController *weakSelf = self;
        [FBSession.activeSession openWithCompletionHandler:^(
                                                             FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
            NSLog(@"aaaaa");
            
            switch (state) {
                case FBSessionStateClosedLoginFailed:
                    //TODO handle here.
                    m_isLogined = false;
                    break;
                default:
                    [weakSelf successLogin];
                    break;
            }
        }];
        
    }
    else
    {
        
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjects:@[@"1000009",@"20150514",@"560",@"6",@"1980",@"5000",@"549001",@"usename8",@"http://8",@"http://28"] forKeys:@[@"facebookid",@"dateid",@"steps",@"floors",@"distance",@"maxSteps",@"totalSteps",@"facebookname",@"headurl",@"mainurl"]];
    
    [[RC_RequestManager shareInstance]postUserDate:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } andFailed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@[@"1000007",@"1000006"],@"facebookid",@"20150513",@"dateid", nil];
    [[RC_RequestManager shareInstance]getRanking:dic1 success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } andFailed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)successLogin
{
    m_isLogined = true;
    [self getUserInfo];
    [self loadfriends];
    [self getCoverGraphPath];
    [self getHeadPicturePath];
    RankingViewController *rankingViewController = [[RankingViewController alloc]init];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:rankingViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)logOut
{
    if (m_isLogined){
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

-(void)getUserInfo
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             NSLog(@"%@",user);
         }
     }];
}

-(void)loadfriends
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
        NSLog(@"%@ Found: %ld friends",friends, friends.count);
        for (NSDictionary<FBGraphUser>* friend_ in friends) {
            NSLog(@"I have a friend named %@ with id %@", friend_.name, friend_.id);
        }
    }];
}

-(void)getCoverGraphPath
{
    [FBRequestConnection startWithGraphPath:@"me?fields=cover"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@"user events: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

-(void)getHeadPicturePath
{
    [FBRequestConnection startWithGraphPath:@"me?fields=picture"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@"user events: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
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
