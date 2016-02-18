//
//  ViewController.m
//  WYAlertController
//
//  Created by WuYikai on 16/2/14.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "ViewController.h"
#import "WYAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(_shareAction:)];
  self.navigationItem.rightBarButtonItem = share;
}

- (void)_shareAction:(UIBarButtonItem *)sender {
  WYAlertAction *cancelAction = [WYAlertAction actionWithTitle:@"Cancel" style:WYAlertActionStyleCancel handler:^(WYAlertAction * _Nonnull action) {
    NSLog(@"cancel");
  }];
  WYAlertAction *sureAction = [WYAlertAction actionWithTitle:@"Sure" style:WYAlertActionStyleDefault handler:^(WYAlertAction * _Nonnull action) {
    NSLog(@"Sure");
  }];
  WYAlertAction *desAction = [WYAlertAction actionWithTitle:@"Destructive" style:WYAlertActionStyleDefault handler:^(WYAlertAction * _Nonnull action) {
    NSLog(@"Destructive");
  }];
  WYAlertController *controller = [WYAlertController alertControllerWithTitle:@"Title" message:@"message" preferredStyle:WYAlertControllerStyleAlert];
  [controller addAction:cancelAction];
  [controller addAction:sureAction];
  [controller addAction:desAction];
  [controller showWithCompletion:nil];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [controller dismissViewControllerAnimated:YES completion:nil];
  });
}

@end
