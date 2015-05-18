//
//  RankingViewController.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RankingViewController.h"
#import "UserCell.h"
#import "HeaderCell.h"
#import "UserHomeViewController.h"

@interface RankingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RankingViewController

-(void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBarHidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableView DataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row == 0)
    {
        static NSString *cellIdentifier = @"HeaderCell";
        cell = (HeaderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"HeaderCell" owner:self options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        [((HeaderCell *)cell).coverImageView setImage:[UIImage imageNamed:@"74B10FBCB7E8.jpg"]];
//        [((HeaderCell *)cell).userIconImageView setImage:[UIImage imageNamed:@"74B10FBCB7E8.jpg"]];
        [((HeaderCell *)cell).coverImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.mainurl] placeholderImage:nil];
        [((HeaderCell *)cell).userIconImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.headurl] placeholderImage:nil];
    }
    else
    {
        static NSString *cellIdentifier = @"UserCell";
        cell = (UserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserCell" owner:self options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [((UserCell *)cell).lblUserName setText:[NSString stringWithFormat:@"userName%d",indexPath.row]];
        [((UserCell *)cell).lblStepCount setText:@"23456"];
        [((UserCell *)cell).lblRankingId setText:[NSString stringWithFormat:@"%d",indexPath.row]];
        [((UserCell *)cell).userIconImageView setImage:[UIImage imageNamed:@"74B10FBCB7E8.jpg"]];
        if (indexPath.row == 1) {
            [((UserCell *)cell).lblRankingId setFont:[UIFont systemFontOfSize:50]];
            [((UserCell *)cell).lblRankingId setTextColor:colorWithHexString(@"#ffc43c")];
        }else if (indexPath.row == 2){
            [((UserCell *)cell).lblRankingId setFont:[UIFont systemFontOfSize:50]];
            [((UserCell *)cell).lblRankingId setTextColor:colorWithHexString(@"#22e8ce")];
        }else if (indexPath.row == 3){
            [((UserCell *)cell).lblRankingId setFont:[UIFont systemFontOfSize:50]];
            [((UserCell *)cell).lblRankingId setTextColor:colorWithHexString(@"#ff7a38")];
        }else
        {
            [((UserCell *)cell).lblRankingId setFont:[UIFont systemFontOfSize:36]];
            [((UserCell *)cell).lblRankingId setTextColor:colorWithHexString(@"#6b6b6b")];
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    UserHomeViewController *userHomeViewController = [[UserHomeViewController alloc]init];
    userHomeViewController.userInfo = _userInfo;
    [self.navigationController pushViewController:userHomeViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
    {
        return 300;
    }
    return 80;
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
