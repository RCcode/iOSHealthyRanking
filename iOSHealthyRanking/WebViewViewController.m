//
//  WebViewViewController.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/6/5.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewViewController

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.webView.delegate = self;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString: _url]];
    
    [self.webView loadRequest:request];
    
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
