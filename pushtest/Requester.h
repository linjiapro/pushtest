//
//  Requester.h
//  pushtest
//
//  Created by Lin Jia on 11/25/14.
//  Copyright (c) 2014 Lin Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Requester : NSObject<NSURLConnectionDelegate>
-(void) setHandler:(void(^)(UIBackgroundFetchResult result))handler;
-(void) sendRequest;
+(instancetype) sharedInstance;
@end
