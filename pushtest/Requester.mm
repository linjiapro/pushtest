//
//  Requester.m
//  pushtest
//
//  Created by Lin Jia on 11/25/14.
//  Copyright (c) 2014 Lin Jia. All rights reserved.
//

#import "Requester.h"

@implementation Requester
{
  NSMutableData *_responseData;
  void(^_handler)(UIBackgroundFetchResult result);
  int _i;
  BOOL _pushNotificationMode;
}
-(void) setBackgroundFetchHandler:(void(^)(UIBackgroundFetchResult result))handler
{
  _handler = handler;
  _pushNotificationMode = YES;
}

+(instancetype) sharedInstance
{
  static Requester* sharedOne = nil;
  static dispatch_once_t token ;
  dispatch_once(&token, ^{
      sharedOne = [[self alloc] init];
  });
  return sharedOne;
}
-(instancetype) init
{
  self = [super init];
  if(self){
    _i = 0;
    _pushNotificationMode = NO;
    self.taskToken = UIBackgroundTaskInvalid;
  }
  return self;
};
-(void)sendRequest
{
  [self sendRequestWithTaskIdentifier:UIBackgroundTaskInvalid];
}


-(void) sendRequestWithTaskIdentifier:(UIBackgroundTaskIdentifier) taskToken
{
  self.taskToken = taskToken;
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  
  NSDate *nowTime = [NSDate date];
  
  [userDefaults setObject:nowTime forKey:@"requestSendTime"];
  
  [userDefaults synchronize];
  
  _responseData = [[NSMutableData alloc] init];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://upload.wikimedia.org/wikipedia/commons/b/bc/Cape_Cod_Landsat_7.jpg"]];
  [request setAllowsCellularAccess:YES];
  [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  //NSLog(@"server tell me size");
 // NSLog(@"%lld", [response expectedContentLength]);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  //NSLog(@"receiving data");
  //NSLog(@"%lu", data.length);
  [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  
  float result = [userDefaults floatForKey:@"total data downloaded"];
  if(!result){
      result = 0;
  }
  result += _responseData.length;
  [userDefaults setFloat:result forKey:@"total data downloaded"];
  
  NSDate *nowTime = [NSDate date];
  [userDefaults setObject:nowTime forKey:@"responseTime"];
 
  NSLog(@"%f", result);
  NSLog(@"%@", nowTime);
  NSLog(@"NSConnection finished");
  [userDefaults synchronize];
  if(_pushNotificationMode) {
    _handler(UIBackgroundFetchResultNewData);
  }
  if(self.taskToken != UIBackgroundTaskInvalid) {
    NSLog(@"finish background Task");
    [[UIApplication sharedApplication] endBackgroundTask:self.taskToken];
    self.taskToken = UIBackgroundTaskInvalid;
  }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
  return nil;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"connection did failed");
  NSLog(@"%@", error);
  if(_pushNotificationMode){
    _handler(UIBackgroundFetchResultFailed);
  }
  if(self.taskToken != UIBackgroundTaskInvalid) {
    NSLog(@"finish background Task, connection failed");
    [[UIApplication sharedApplication] endBackgroundTask:self.taskToken];
    self.taskToken = UIBackgroundTaskInvalid;
  }
}
@end
