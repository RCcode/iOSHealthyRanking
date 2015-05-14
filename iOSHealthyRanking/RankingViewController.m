//
//  RankingViewController.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RankingViewController.h"
#import "HeaderView.h"
#import "UserCell.h"
#import "HeaderCell.h"

@interface RankingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        [((HeaderCell *)cell).coverImageView setImage:[UIImage imageNamed:@"74B10FBCB7E8.jpg"]];
        [((HeaderCell *)cell).userIconImageView setImage:[UIImage imageNamed:@"74B10FBCB7E8.jpg"]];
    }
    else
    {
        static NSString *cellIdentifier = @"UserCell";
        cell = (UserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserCell" owner:self options:nil]lastObject];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView *headerView = [HeaderView instanceHeaderView];
    return headerView;
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
