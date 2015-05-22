//
//  SetUpViewController.m
//  Instagram
//
//  Created by zhao liang on 15/4/1.
//  Copyright (c) 2015年 zhao liang. All rights reserved.
//

#import "SetUpViewController.h"
#import "CMethods.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "LoginViewController.h"

#define FEEDBACK_EMAIL @"rcplatform.help@gmail.com"
#define appleID @"983479439"

@interface SetUpViewController ()<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong)UITableView *tableView;

@end
@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"set_back"] andHighlightedImage:nil];
}

-(void)returnBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)setUI
{
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:colorWithHexString(@"#e6e6e6")];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = colorWithHexString(@"#080808");
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"Settings", nil);
    self.navigationItem.titleView = titleLabel;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 165) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = colorWithHexString(@"#f2f2f2");
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"set-share"]];
            cell.textLabel.text = @"Share";
        } else if (indexPath.row == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"set-feedback"]];
            cell.textLabel.text = @"Feedback";
        } else if (indexPath.row == 2) {
            [cell.imageView setImage:[UIImage imageNamed:@"set-rate"]];
            cell.textLabel.text = @"Rate";
        }
    } else if (indexPath.section == 1){
        [cell.imageView setImage:[UIImage imageNamed:@"set-quit"]];
        cell.textLabel.text = @"Quit";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            NSString *shareContent = @"I ran the 10,000 steps today, Ranked No.5 in my friends.If you want to competition me，Please download http://apple.co/1FHbWOS";
            NSArray *activityItems = @[shareContent];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            __weak UIActivityViewController *blockActivityVC = activityVC;
            
            activityVC.completionHandler = ^(NSString *activityType,BOOL completed)
            {
                [blockActivityVC dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:activityVC animated:YES completion:nil];
            
        }
        else if (indexPath.row == 1){
            // app名称 版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
//            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
            
            //设备型号 系统版本
            NSString *deviceName = doDevicePlatform();
            NSString *deviceSystemName = [[UIDevice currentDevice] systemName];
            NSString *deviceSystemVer = [[UIDevice currentDevice] systemVersion];
            
            //设备分辨率
            CGFloat scale = [UIScreen mainScreen].scale;
            CGFloat resolutionW = [UIScreen mainScreen].bounds.size.width * scale;
            CGFloat resolutionH = [UIScreen mainScreen].bounds.size.height * scale;
            NSString *resolution = [NSString stringWithFormat:@"%.f * %.f", resolutionW, resolutionH];
            
            //本地语言
            NSString *language = [[NSLocale preferredLanguages] firstObject];
            
            //NSString *diveceInfo = @"app版本号 手机型号 手机系统版本 分辨率 语言";
            NSString *diveceInfo = [NSString stringWithFormat:@"Sports for Facebook %@, %@, %@ %@, %@, %@", app_Version, deviceName, deviceSystemName, deviceSystemVer,  resolution, language];
            
            //直接发邮件
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            if(!picker){
                return;
            }
            picker.mailComposeDelegate =self;
            NSString *subject = [NSString stringWithFormat:@"Sports for Facebook %@ (iOS)", @"Feedback"];
            [picker setSubject:subject];
            [picker setToRecipients:@[FEEDBACK_EMAIL]];
            [picker setMessageBody:diveceInfo isHTML:NO];
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];

        } else if (indexPath.row == 2) {
            [self gotoAppStorePageRaisal];
        }
    }else if (indexPath.section == 1){
        [self logOut];
    }
}

-(void)logOut
{
    [[FacebookManager shareManager]logOut];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"successLogin"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoAppStorePageRaisal
{
    NSString * nsStringToOpen = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appleID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
