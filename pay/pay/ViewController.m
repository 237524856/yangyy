//
//  ViewController.m
//  pay
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import "MyPayHeader.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UIKit/UIKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 30)];
    lb.text = @"点击按钮 支付100块 购iPhone6 Plus";
    lb.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lb];
    
    UIButton * b = [UIButton buttonWithType:UIButtonTypeSystem];
    [b setFrame:CGRectMake(0, 130, 100, 30)];
    [b addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [b setTitle:@"支付" forState:UIControlStateNormal];
    [self.view addSubview:b];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)click
{
    Order *order = [[Order alloc] init];
    // 签约成功后 支付宝自动分配
    order.partner = PartnerID;
    order.seller = SellerID;
    // 订单ID（由商家自行制定）
    order.tradeNO = @"123321";
    order.productName = @"商品标题";
    order.productDescription = @"商品描述";
    // 商品价格
    order.amount = @"0.01";
    // 支付宝服务器主动通知商户网站里指定的页面http路径
    order.notifyURL =  @"http://www.baidu.com";
    // 固定值
    order.service = @"mobile.securitypay.pay";
    // 默认为1 商品购买
    order.paymentType = @"1";
    // 字符编码
    order.inputCharset = @"utf-8";
    // 未付款交易的超时时间 超时交易自动关闭 m分 h时 d天
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    // 支付宝回调App
    NSString *appScheme = @"PayDemo";
    
    // 将商品信息拼接成字符串
    /*
     orderSpec = partner="2088511933544308"&seller_id="yingtehua8@sina.com"&out_trade_no="123321"&subject="商品标题"&body="商品描述"&total_fee="0.01"&notify_url="http://www.baidu.com"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&show_url="m.alipay.com"
     */
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }
    
}

@end
