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
#import "HealthManager.h"
#import "SetUpViewController.h"

@interface RankingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *serversFriends;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RankingViewController

-(void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBarHidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    
    _serversFriends = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _friends = [[NSUserDefaults standardUserDefaults]objectForKey:@"friends"];
    [self getFacebookUserInfo];
    [self getHealthInfo];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getHealthInfo
{
    __weak RankingViewController *weakSelf = self;
    if ([HKHealthStore isHealthDataAvailable]) {
        //        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [[HealthManager shareManager] dataTypesToRead];
        
        [[HealthManager shareManager].healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                
                return;
            }
            [[HealthManager shareManager]getAllData:^(double allStepCount, double todayStepCount, double todayDistanceWalkingRunning, double todayFlightsClimbed,double weekMaxStepCount) {
                weakSelf.userInfo.totalSteps = allStepCount;
                weakSelf.userInfo.steps = todayStepCount;
                weakSelf.userInfo.distance = todayDistanceWalkingRunning;
                weakSelf.userInfo.floors = todayFlightsClimbed;
                weakSelf.userInfo.maxSteps = weekMaxStepCount;
                [weakSelf updateUserInfo];
                if (weakSelf.friends) {
                    [weakSelf getRanking];
                }
            }];
        }];
    }
}

-(void)getFacebookUserInfo
{
    __weak RankingViewController *weakSelf = self;
    [[FacebookManager shareManager] getUserInfoSuccess:^(NSDictionary *userInfo) {
        NSLog(@"userInfo:%@",userInfo);
        weakSelf.userInfo.facebookid = [userInfo objectForKey:@"id"];
        weakSelf.userInfo.facebookname = [userInfo objectForKey:@"name"];
        [[NSUserDefaults standardUserDefaults]setObject:[userInfo objectForKey:@"id"] forKey:@"facebookid"];
        [[NSUserDefaults standardUserDefaults]setObject:[userInfo objectForKey:@"name"] forKey:@"facebookname"];
        [weakSelf updateUserInfo];
    } andFailed:^(NSError *error) {
        
    }];
    [[FacebookManager shareManager] getCoverGraphPathSuccess:^(NSDictionary *dic) {
        NSLog(@"headurl:%@",dic);
        weakSelf.userInfo.mainurl = [[dic objectForKey:@"cover"]objectForKey:@"source"];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"cover"]objectForKey:@"source"] forKey:@"mainurl"];
        [weakSelf updateUserInfo];
    } andFailed:^(NSError *error) {
        
    }];
    [[FacebookManager shareManager] getHeadPicturePathSuccess:^(NSDictionary *dic) {
        NSLog(@"headurl:%@",dic);
        weakSelf.userInfo.headurl = [[[dic objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"];
        [[NSUserDefaults standardUserDefaults]setObject:[[[dic objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"] forKey:@"headurl"];
        [weakSelf updateUserInfo];
    } andFailed:^(NSError *error) {
        
    }];
    [[FacebookManager shareManager] loadfriendsSuccess:^(NSArray *friends) {
        NSLog(@"friends：%@",friends);
        [[NSUserDefaults standardUserDefaults]setObject:friends forKey:@"friends"];
        weakSelf.friends = friends;
        [weakSelf getRanking];
    } andFailed:^(NSError *error) {
        
    }];
}

-(void)updateUserInfo
{
    if (!_userInfo.facebookid) {
        return;
    }
    [_tableView reloadData];
    NSString *date = stringFromDate([NSDate date]);
    NSString *headURL;
    NSString *mainURL;
    if (_userInfo.headurl) {
        headURL = _userInfo.headurl;
    }
    else
    {
        headURL = @"";
    }
    if (_userInfo.mainurl) {
        mainURL = _userInfo.mainurl;
    }
    else
    {
        mainURL = @"";
    }
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc]initWithObjects:@[_userInfo.facebookid,date,[NSString stringWithFormat:@"%d",(int)_userInfo.steps],[NSString stringWithFormat:@"%d",(int)_userInfo.floors],[NSString stringWithFormat:@"%d",(int)_userInfo.distance],[NSString stringWithFormat:@"%d",(int)_userInfo.maxSteps],[NSString stringWithFormat:@"%d",(int)_userInfo.totalSteps],_userInfo.facebookname,headURL,mainURL] forKeys:@[@"facebookid",@"dateid",@"steps",@"floors",@"distance",@"maxSteps",@"totalSteps",@"facebookname",@"headurl",@"mainurl"]];
    [[RC_RequestManager shareInstance]postUserDate:userInfoDic success:^(id responseObject) {
        NSLog(@"responseUserInfo:%@",responseObject);
    } andFailed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjects:@[@"1000009",date,@"560",@"6",@"1980",@"5000",@"549001",@"usename8",@"http://8",@"http://28"] forKeys:@[@"facebookid",@"dateid",@"steps",@"floors",@"distance",@"maxSteps",@"totalSteps",@"facebookname",@"headurl",@"mainurl"]];
//    [[RC_RequestManager shareInstance]postUserDate:dic success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } andFailed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSArray arrayWithObjects:_userInfo.facebookid, nil],@"facebookid",date,@"dateid", nil];
    [[RC_RequestManager shareInstance]getRanking:dic2 success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } andFailed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
//    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@[@"1000013",@"1000012"],@"facebookid",@"20150515",@"dateid", nil];
//    [[RC_RequestManager shareInstance]getRanking:dic1 success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } andFailed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];

}

-(void)getRanking
{
    
    if (_friends && _friends.count > 0) {
        NSMutableArray *friendsId = [[NSMutableArray alloc]init];
        for (NSDictionary *friend_ in _friends) {
//            NSLog(@"I have a friend named %@ with id %@", friend_.name, friend_.id);
            [friendsId addObject:[friend_ objectForKey:@"id"]];
        }
        NSString *date = stringFromDate([NSDate date]);
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:friendsId,@"facebookid",date,@"dateid", nil];
        __weak RankingViewController *weakSelf = self;
        [[RC_RequestManager shareInstance]getRanking:dic1 success:^(id responseObject) {
            NSLog(@"responseRanking%@",responseObject);
            NSDictionary *dic = responseObject;
            if([[dic objectForKey:@"status"]intValue ] == 0)
            {
                NSArray *arr = [dic objectForKey:@"list"];
                [weakSelf getRankingSuccess:arr];
            }
        } andFailed:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    else
    {
        [self getRankingSuccess:[NSArray array]];
    }
//    __weak RankingViewController *weakSelf = self;
//    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@[@"1000013",@"1000012"],@"facebookid",@"20150515",@"dateid", nil];
//    [[RC_RequestManager shareInstance]getRanking:dic1 success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSDictionary *dic = responseObject;
//        if([[dic objectForKey:@"status"]intValue ] == 0)
//        {
//            NSArray *arr = [dic objectForKey:@"list"];
//            [weakSelf getRankingSuccess:arr];
//        }
//    } andFailed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];

}

-(void)getRankingSuccess:(NSArray *)rangingArr
{
    [_serversFriends removeAllObjects];
    [_dataArray removeAllObjects];
    BOOL find = NO;
    for (int i =0; i<rangingArr.count; i++) {
        NSDictionary *dic = [rangingArr objectAtIndex:i];
        if (find == NO) {
            if ([[dic objectForKey:@"steps"]integerValue]<_userInfo.steps) {
                NSDictionary *user = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_userInfo.facebookid],@"facebookid",[NSString stringWithFormat:@"%@",_userInfo.facebookname],@"facebookname",[NSString stringWithFormat:@"%@",_userInfo.headurl],@"headurl",[NSString stringWithFormat:@"%@",_userInfo.mainurl],@"mainurl",[NSString stringWithFormat:@"%d",(int)_userInfo.steps],@"steps", nil];
                [_serversFriends addObject:user];
                [_dataArray addObject:user];
                find = YES;
            }
        }
        [_serversFriends addObject:dic];
        [_dataArray addObject:dic];
        if (find == NO && i== (rangingArr.count-1)) {
            NSDictionary *user = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_userInfo.facebookid],@"facebookid",[NSString stringWithFormat:@"%@",_userInfo.facebookname],@"facebookname",[NSString stringWithFormat:@"%@",_userInfo.headurl],@"headurl",[NSString stringWithFormat:@"%@",_userInfo.mainurl],@"mainurl",[NSString stringWithFormat:@"%d",(int)_userInfo.steps],@"steps", nil];
            [_serversFriends addObject:user];
            [_dataArray addObject:user];
        }
    }

    NSMutableArray *userFriends = [[NSMutableArray alloc]initWithArray:_friends];
    for (int i=0;i<userFriends.count;i++) {
        for (int j=0; j<rangingArr.count; j++) {
            NSString *facebookid = [NSString stringWithFormat:@"%@",[[rangingArr objectAtIndex:j]objectForKey:@"facebookid"]];
            NSString *strId =  [NSString stringWithFormat:@"%@",[[userFriends objectAtIndex:i]objectForKey:@"id"]];
            if ([facebookid isEqualToString:strId]) {
                break;
            }
            if (j == rangingArr.count-1) {
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:strId,@"facebookid",[[userFriends objectAtIndex:i]objectForKey:@"name"],@"facebookname", nil];
                [_serversFriends addObject:dic];
                [_dataArray addObject:dic];
            }
        }
    }
    
    if (rangingArr.count == 0) {
        NSDictionary *user = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_userInfo.facebookid],@"facebookid",[NSString stringWithFormat:@"%@",_userInfo.facebookname],@"facebookname",[NSString stringWithFormat:@"%@",_userInfo.headurl],@"headurl",[NSString stringWithFormat:@"%@",_userInfo.mainurl],@"mainurl",[NSString stringWithFormat:@"%d",(int)_userInfo.steps],@"steps", nil];
        [_serversFriends addObject:user];
        [_dataArray addObject:user];
        
        for (int i=0;i<userFriends.count;i++) {
            NSString *strId =  [NSString stringWithFormat:@"%@",[[userFriends objectAtIndex:i]objectForKey:@"id"]];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:strId,@"facebookid",[[userFriends objectAtIndex:i]objectForKey:@"name"],@"facebookname", nil];
            [_serversFriends addObject:dic];
            [_dataArray addObject:dic];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
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
//        [((HeaderCell *)cell).coverImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.mainurl] placeholderImage:[UIImage imageNamed:@"pic_top"]];
//        [((HeaderCell *)cell).userIconImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.headurl] placeholderImage:[UIImage imageNamed:@"people"]];
        [((HeaderCell *)cell).coverImageView setImage:[UIImage imageNamed:@"pic_top"]];
        [((HeaderCell *)cell).userIconImageView setImage:[UIImage imageNamed:@"people"]];
        if (_dataArray.count >=1)
        {
            NSString *userId = [[_dataArray objectAtIndex:0] objectForKey:@"facebookid"];
            
            if ([userId isEqualToString:_userInfo.facebookid]) {
//                ((HeaderCell *)cell).winnerImageView.hidden = NO;
                [((HeaderCell *)cell).coverImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.mainurl] placeholderImage:[UIImage imageNamed:@"pic_top"]];
                [((HeaderCell *)cell).userIconImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.headurl] placeholderImage:[UIImage imageNamed:@"people"]];
            }
            else
            {
//                ((HeaderCell *)cell).winnerImageView.hidden = YES;
                NSString *mainurl = [[_dataArray objectAtIndex:0] objectForKey:@"mainurl"];
                NSString *headurl = [[_dataArray objectAtIndex:0] objectForKey:@"headurl"];
                [((HeaderCell *)cell).coverImageView sd_setImageWithURL:[NSURL URLWithString:mainurl] placeholderImage:[UIImage imageNamed:@"pic_top"]];
                [((UserCell *)cell).userIconImageView sd_setImageWithURL:[NSURL URLWithString:headurl]placeholderImage:[UIImage imageNamed:@"people"]];
            }
        }
        
    }
    else
    {
        static NSString *cellIdentifier = @"UserCell";
        cell = (UserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserCell" owner:self options:nil]lastObject];
        }
        
        NSString *userId = [[_dataArray objectAtIndex:indexPath.row-1] objectForKey:@"facebookid"];
        if ([userId isEqualToString:_userInfo.facebookid]) {
            ((UserCell *)cell).shareInviteBtn.hidden = NO;
            [((UserCell *)cell).shareInviteBtn setImage:[UIImage imageNamed:@"Ranking_share"] forState:UIControlStateNormal];
            [((UserCell *)cell).shareInviteBtn addTarget:self action:@selector(shareFacebook:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            ((UserCell *)cell).shareInviteBtn.hidden = YES;
        }
        
        [((UserCell *)cell).lblUserName setText:[[_dataArray objectAtIndex:indexPath.row-1] objectForKey:@"facebookname"]];
        NSString *steps;
        if ([[_dataArray objectAtIndex:indexPath.row-1] objectForKey:@"steps"]) {
            steps = [NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row-1] objectForKey:@"steps"]];
        }
        else
        {
            steps = @"0";
            ((UserCell *)cell).hidden = NO;
//            if(![userId isEqualToString:_userInfo.facebookid])
//            {
//                [((UserCell *)cell).shareInviteBtn setImage:[UIImage imageNamed:@"Ranking_invite"] forState:UIControlStateNormal];
//                [((UserCell *)cell).shareInviteBtn addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
//            }
        }
        ((UserCell *)cell).shareInviteBtn.tag = indexPath.row;
        [((UserCell *)cell).lblStepCount setText:steps];
        float process = [steps floatValue]/10000;
        [((UserCell *)cell) setProcess:process];
        [((UserCell *)cell).lblRankingId setText:[NSString stringWithFormat:@"%d",indexPath.row]];
        [((UserCell *)cell).userIconImageView sd_setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row-1] objectForKey:@"headurl"]]placeholderImage:[UIImage imageNamed:@"people"]];
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
    return _dataArray.count+1;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row-1];
    UserInfo *uInfo = [[UserInfo alloc]init];
    uInfo.facebookid = [dic objectForKey:@"facebookid"];
    uInfo.facebookname = [dic objectForKey:@"facebookname"];
    uInfo.headurl = [dic objectForKey:@"headurl"];
    uInfo.mainurl = [dic objectForKey:@"mainurl"];
    uInfo.steps = [[dic objectForKey:@"steps"]intValue];
    uInfo.maxSteps = [[dic objectForKey:@"maxSteps"]intValue];
    uInfo.totalSteps = [[dic objectForKey:@"totalSteps"]intValue];
    UserHomeViewController *userHomeViewController = [[UserHomeViewController alloc]init];
    if ([uInfo.facebookid isEqualToString:_userInfo.facebookid]) {
        userHomeViewController.userInfo = _userInfo;
        userHomeViewController.canShare = YES;
        userHomeViewController.rankingNo = indexPath.row;
    }
    else
    {
        userHomeViewController.userInfo = uInfo;
        userHomeViewController.canShare = NO;
    }
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

- (IBAction)pressUserHome:(id)sender {
//    UserHomeViewController *userHomeViewController = [[UserHomeViewController alloc]init];
//    userHomeViewController.userInfo = _userInfo;
//    [self.navigationController pushViewController:userHomeViewController animated:YES];
    SetUpViewController *setUpViewController = [[SetUpViewController alloc]init];
    [self.navigationController pushViewController:setUpViewController animated:YES];
}

-(void)shareFacebook:(id)sender
{
//    [[FacebookManager shareManager]shareToFacebookWithName:@"快来和我比拼" caption:@"Sports for Facebook" desc:@"我今天跑了xxx步，排名xx,如果想和我一起比赛的话，下载地址" link:@"http://bit.ly/1uYvgiC" picture:@""];
    NSString *desc = [NSString stringWithFormat:@"I ran the %d steps today, Ranked No.%ld in my friends.If you want to competition me，Please download http://apple.co/1FHbWOS",(int)_userInfo.steps,(long)((UIButton *)sender).tag];
//    [[FacebookManager shareManager]shareToFacebookWithName:@"challenge with me" caption:@"Sports for Facebook" desc:desc link:@"http://apple.co/1FHbWOS" picture:@""];
    [[FacebookManager shareManager]shareToFacebookWithName:desc caption:@"Sports for Facebook" desc:@"" link:@"http://apple.co/1FHbWOS" picture:@""];
}

-(void)inviteFriend
{
    
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
