//
//  GuideViewController.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/6/5.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GuideViewController

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (iPhone4) {
//        _im
//    }
    // Do any additional setup after loading the view from its nib.
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
