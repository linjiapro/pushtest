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
}
-(void) setHandler:(void(^)(UIBackgroundFetchResult result))handler
{
    _handler = handler;
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
    }
    return self;
};
-(void)sendRequest
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *nowTime = [NSDate date];
    
    [userDefaults setObject:nowTime forKey:@"last time respond to the push notification"];
    
    [userDefaults synchronize];
    
    _responseData = [[NSMutableData alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://upload.wikimedia.org/wikipedia/commons/2/2f/Cape_Cod_-_Landsat_7.jpg"]];
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
    
    NSLog(@"total size report");
    float result = [userDefaults floatForKey:@"total data downloaded"];
    if(!result){
        result = 0;
    }
    result += _responseData.length;
    [userDefaults setFloat:result forKey:@"total data downloaded"];
    
    NSDate *nowTime = [NSDate date];
    [userDefaults setObject:nowTime forKey:@"last time finish the push notification"];
   
    NSLog(@"%f", result);
    NSLog(@"%@", nowTime);
    NSLog(@"finished");
    [userDefaults synchronize];
    _handler(UIBackgroundFetchResultNewData);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error");
    _handler(UIBackgroundFetchResultFailed);
}
@end
