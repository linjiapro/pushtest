//
//  AppDelegate.m
//  pushtest
//
//  Created by Lin Jia on 11/25/14.
//  Copyright (c) 2014 Lin Jia. All rights reserved.
//

#import "AppDelegate.h"
#import "Requester.h"
#import "ViewController.h"

#define TURN_ON_BACKGROUNDTASK YES

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    Requester *_rq;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       // Override point for customization after application launch.
  NSLog(@"application did finish launching");
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    [application registerForRemoteNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController * rootViewController = [[ViewController alloc] init];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    _rq = [Requester sharedInstance];
    [_rq setBackgroundFetchHandler:handler];
    [_rq sendRequest];
    NSLog(@" application receive remote notification");
}
- (void)applicationWillResignActive:(UIApplication *)application {
  NSLog(@"application will resign active");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
 /* _rq = [Requester sharedInstance];
  [_rq sendRequest];*/
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"application did enter background");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  if(TURN_ON_BACKGROUNDTASK) {
    UIBackgroundTaskIdentifier __block token;
    token = [application beginBackgroundTaskWithExpirationHandler:^{
      NSLog(@"no time left, going to be terminated");
      [application endBackgroundTask:token];
      token = UIBackgroundTaskInvalid;
    }];
    
    _rq = [Requester sharedInstance];
    [_rq sendRequestWithTaskIdentifier:token];
  }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  NSLog(@"application will enter foreground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"application did become active");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  NSLog(@"application will terminate");
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    //NSLog(@"Failed to get token, error: %@", error);
}
@end
