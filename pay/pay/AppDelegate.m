//
//  AppDelegate.m
//  pay
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.rootViewController = nav;
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSString * temp = [[NSString stringWithFormat:@"%@",url] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"application is %@",temp);
    /*
     PayDemo://safepay/?{"memo":{"ResultStatus":"9000","memo":"","result":"partner=\"2088511933544308\"&seller_id=\"yingtehua8@sina.com\"&out_trade_no=\"123321\"&subject=\"商品标题\"&body=\"商品描述\"&total_fee=\"0.01\"&notify_url=\"http:\/\/www.baidu.com\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"cPvT5c10kIRqe97J8CIbzxl5cNZGNCNyPFIeNKOa79OdPUvdov78Sp3x45n0q\/Bi11rbMxEE4MphYNCAMD3ngS\/2ObmmGE1jVQirOdSdwcFUlFFwWo+XPM+5UIiewLKQq3zKqTMVm61KbcdTnw5PtrQ87iYvxzJnUgzU8F0uwts=\""},"requestType":"safepay"}
     */
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             __unused NSString *resultStr = resultDic[@"result"];
                                         }];
        
    }
    
    return YES;
}



@end
