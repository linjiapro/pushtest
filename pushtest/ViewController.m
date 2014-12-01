//
//  ViewController.m
//  pushtest
//
//  Created by Lin Jia on 11/25/14.
//  Copyright (c) 2014 Lin Jia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault synchronize];
    
    self.totalDataDownloaded = [[UILabel alloc] initWithFrame:CGRectMake(11.0f, 50.0f, 300.0f, 80.0f)];
    if([userdefault floatForKey:@"total data downloaded"]){
        self.totalDataDownloaded.text = [NSString stringWithFormat:@"total data download:%f", [userdefault floatForKey:@"total data downloaded"]];
    } else {
        self.totalDataDownloaded.text = [NSString stringWithFormat:@"%f", 0.0];
        self.lastTimeDataDownload.numberOfLines = 0;
    }
    [self.view addSubview: self.totalDataDownloaded];
    
    self.lastTimeDataDownload = [[UILabel alloc] initWithFrame:CGRectMake(11.0f, 150.0f, 300.0f, 80.0f)];
    if([userdefault objectForKey:@"last time respond to the push notification"] ){
        self.lastTimeDataDownload.text = [NSString stringWithFormat:@"%@", [userdefault objectForKey:@"last time respond to the push notification"]];
    } else {
        self.lastTimeDataDownload.text = @"no download yet";
        self.lastTimeDataDownload.numberOfLines = 0;
    }
    [self.view addSubview:self.lastTimeDataDownload];
    
    
    self.lastTimeDataDownloadFinish = [[UILabel alloc] initWithFrame:CGRectMake(11.0f, 250.0f, 300.0f, 80.0f)];
    if([userdefault objectForKey:@"last time finish the push notification"] ){
        self.lastTimeDataDownloadFinish.text = [NSString stringWithFormat:@"%@", [userdefault objectForKey:@"last time finish the push notification"]];
    } else {
        self.lastTimeDataDownloadFinish.text = @"no download yet";
        self.lastTimeDataDownloadFinish.numberOfLines = 0;
    }
    [self.view addSubview:self.lastTimeDataDownloadFinish];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
