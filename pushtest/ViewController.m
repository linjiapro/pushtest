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
- (instancetype) init
{
  self = [super init];
  if(self) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.totalDataDownloaded = [[UILabel alloc] initWithFrame:CGRectMake(11.0f, 50.0f, 300.0f, 80.0f)];
    [self.view addSubview: self.totalDataDownloaded];
    
    self.lastTimeDataDownload = [[UILabel alloc] initWithFrame:CGRectMake(11.0f, 150.0f, 300.0f, 80.0f)];
    self.lastTimeDataDownload.numberOfLines = 2;
    
    [self.view addSubview:self.lastTimeDataDownload];
    
    
    self.lastTimeDataDownloadFinish = [[UILabel alloc] initWithFrame:CGRectMake(11.0f, 250.0f, 300.0f, 80.0f)];
    self.lastTimeDataDownloadFinish.numberOfLines = 2;
    [self.view addSubview:self.lastTimeDataDownloadFinish];
  }
  return self;
}
-(void) refreshData
{
  
  NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
  [userdefault synchronize];
  
  
  if([userdefault floatForKey:@"total data downloaded"]){
    self.totalDataDownloaded.text = [NSString stringWithFormat:@"total data download:%f", [userdefault floatForKey:@"total data downloaded"]];
  } else {
    self.totalDataDownloaded.text = [NSString stringWithFormat:@"%f", 0.0];
  }
  
  if([userdefault objectForKey:@"requestSendTime"] ){
    self.lastTimeDataDownload.text = [NSString stringWithFormat:@"%@%@", @"last request send time: ", [userdefault objectForKey:@"requestSendTime"]];
  } else {
    self.lastTimeDataDownload.text = @"no download yet";
    self.lastTimeDataDownload.numberOfLines = 0;
  }
  if([userdefault objectForKey:@"responseTime"] ){
    self.lastTimeDataDownloadFinish.text = [NSString stringWithFormat:@"%@%@", @"response receive time:", [userdefault objectForKey:@"responseTime"]];
  } else {
    self.lastTimeDataDownloadFinish.text = @"no download yet";
  }

}
- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"view did load called");
  
}
-(void) viewDidAppear:(BOOL)animated
{
  NSLog(@"view did appear");
  [super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
