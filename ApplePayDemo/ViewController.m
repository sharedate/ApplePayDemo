//
//  ViewController.m
//  ApplePayDemo
//
//  Created by Teddy Lin on 2/19/16.
//  Copyright © 2016 Zhimei Inc. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController () <PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PKPaymentButton *payButton = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypeBuy paymentButtonStyle:PKPaymentButtonStyleBlack];
    payButton.frame = CGRectMake(0, 0, 100, 44);
    payButton.center = self.view.center;
    [self.view addSubview:payButton];
    
    [payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pay:(id)sender {
    
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        NSLog(@"PKPayment can make payments");
    }
    
    PKPaymentRequest *payment = [[PKPaymentRequest alloc] init];
    
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Total" amount:[NSDecimalNumber decimalNumberWithString:@"1.99"]];
    
    payment.paymentSummaryItems = @[total];
    
    // 人民币
    payment.currencyCode = @"CNY";
    
    // 中国
    payment.countryCode = @"CN";
    
    // 在 developer.apple.com member center 里设置的 merchantID
    payment.merchantIdentifier = @"merchant.com.zhimei360.applepaydemo";
    
    // 支持哪种卡类型，这里表示信用卡
    payment.merchantCapabilities = PKMerchantCapabilityCredit;
    
    // 支持哪种结算网关
    payment.supportedNetworks = @[PKPaymentNetworkChinaUnionPay];
    
    NSLog(@"payment: %@", payment);
    
    PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:payment];
    vc.delegate = self;

    [self presentViewController:vc animated:YES completion:NULL];
    
}

#pragma mark - Payment delegate

//- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
//    NSLog(@"didSelectPaymentMethod");
//    completion(@[]);
//}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingContact:(PKContact *)contact completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    NSLog(@"didSelectShippingContact");
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    NSLog(@"didSelectShippingMethod");
}

- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"paymentAuthorizationViewControllerWillAuthorizePayment");
    
    
}


//@required

// Sent to the delegate after the user has acted on the payment request.  The application
// should inspect the payment to determine whether the payment request was authorized.
//
// If the application requested a shipping address then the full addresses is now part of the payment.
//
// The delegate must call completion with an appropriate authorization status, as may be determined
// by submitting the payment credential to a processing gateway for payment authorization.

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSLog(@"did authorize payment token: %@, %@", payment.token, payment.token.transactionIdentifier);
    
    
    
    completion(PKPaymentAuthorizationStatusSuccess);
}

// Sent to the delegate when payment authorization is finished.  This may occur when
// the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
// paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//
// The delegate is responsible for dismissing the view controller in this method.
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"finish");
    [controller dismissViewControllerAnimated:controller completion:NULL];
}

@end
