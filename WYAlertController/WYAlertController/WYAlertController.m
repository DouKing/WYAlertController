//
//  WYAlertView.m
//  MyTest
//
//  Created by WuYikai on 16/2/3.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "WYAlertController.h"

#define _WY_SYSTEM_VERSION_   [[[UIDevice currentDevice] systemVersion] floatValue]
#define _WY_IOS_8_LATER_      (_WY_SYSTEM_VERSION_ >= 8.0)

typedef void(^AlertActionHandler)(UIAlertAction *action);

#pragma mark - WYAlertAction -

typedef void(^WYAlertActionHandler)(WYAlertAction *action);

@interface WYAlertAction ()

@property (nonatomic, copy) WYAlertActionHandler handler;

@end

@implementation WYAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(WYAlertActionStyle)style handler:(void (^)(WYAlertAction * _Nonnull))handler {
  return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(WYAlertActionStyle)style handler:(void (^)(WYAlertAction * _Nonnull action))handler {
  if (self = [super init]) {
    _title = title;
    _style = style;
    _handler = handler;
  }
  return self;
}

@end

#pragma mark - WYAlertController -

@interface WYAlertController ()<UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic, weak) UIAlertController *alertController;
@property (nonatomic, weak) UIAlertView *alertView;
@property (nonatomic, weak) UIActionSheet *actionSheet;
@end

@implementation WYAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)alertTitle message:(NSString *)alertMessage preferredStyle:(WYAlertControllerStyle)preferredStyle {
  return [[self alloc] initWithTitle:alertTitle message:alertMessage preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)alertTitle message:(NSString *)alertMessage preferredStyle:(WYAlertControllerStyle)preferredStyle {
  if (self = [super init]) {
    _alertTitle = alertTitle;
    _alertMessage = alertMessage;
    _preferredStyle = preferredStyle;
    _actions = [NSArray array];
    if (_WY_IOS_8_LATER_) {
      self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
  }
  return self;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
  if (_WY_IOS_8_LATER_) {
    [self.alertController dismissViewControllerAnimated:flag completion:nil];
  } else {
    [self.alertView dismissWithClickedButtonIndex:0 animated:flag];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:flag];
  }
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [super dismissViewControllerAnimated:NO completion:completion];
  });
}

- (void)addAction:(WYAlertAction *)action {
  NSMutableArray<WYAlertAction *> *tempArray = [NSMutableArray arrayWithArray:self.actions];
  [tempArray addObject:action];
  _actions = [NSArray arrayWithArray:tempArray];
}

- (void)showWithCompletion:(void (^)(void))completion {
  __weak typeof(self) weakSelf = self;
  UIViewController *rootVC = [self _stackTopViewController];
  if (!_WY_IOS_8_LATER_) {
    rootVC.modalPresentationStyle = UIModalPresentationCurrentContext;
  }
  [rootVC presentViewController:self animated:NO completion:^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (_WY_IOS_8_LATER_) {
      [strongSelf _showAlertControllerCompletion:completion];
    } else {
      rootVC.modalPresentationStyle = UIModalPresentationFullScreen;
      [strongSelf _showAlertViewCompletion:completion];
    }
  }];
}

#pragma mark - Private Methods

- (void)_showAlertControllerCompletion:(void (^)(void))completion {
  if (self.alertController) { return; }
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.alertTitle
                                                                           message:self.alertMessage
                                                                    preferredStyle:[self _controllerStyleWithStyle:self.preferredStyle]];
  for (WYAlertAction *wy_action in self.actions) {
    __weak typeof(self) weakSelf = self;
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:wy_action.title style:[self _actionStyleWithStyle:wy_action.style] handler:^(UIAlertAction * _Nonnull action) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (wy_action.handler) { wy_action.handler(wy_action); }
      [strongSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    [alertController addAction:alertAction];
  }
  self.alertController = alertController;
  [self presentViewController:alertController animated:YES completion:completion];
}

- (void)_showAlertViewCompletion:(void (^)(void))completion {
  if (WYAlertControllerStyleAlert == self.preferredStyle) {
    //UIAlertView
    if (self.alertView) { return; }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.alertTitle message:self.alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    for (WYAlertAction *action in self.actions) {
      [alertView addButtonWithTitle:action.title];
    }
    self.alertView = alertView;
    [alertView show];
    return;
  }
  
  //UIActionSheet
  if (self.actionSheet) { return; }
  //暂存cancel、destrutive
  WYAlertAction *cancelAction = nil;
  WYAlertAction *destructiveAction = nil;
  NSMutableArray<WYAlertAction *> *defaultActions = [NSMutableArray array];
  for (WYAlertAction *action in self.actions) {
    if (WYAlertActionStyleCancel == action.style) {
      cancelAction = action;
    } else if (WYAlertActionStyleDestructive == action.style) {
      destructiveAction = action;
    } else {
      [defaultActions addObject:action];
    }
  }
  
  //对self.actions重新排序
  NSMutableArray<WYAlertAction *> *temp = [NSMutableArray array];
  if (destructiveAction) {
    [temp addObject:destructiveAction];
  }
  if (defaultActions.count) {
    [temp addObjectsFromArray:defaultActions];
  }
  if (cancelAction) {
    [temp addObject:cancelAction];
  }
  _actions = [NSArray arrayWithArray:temp];
  
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:self.alertTitle delegate:self cancelButtonTitle:cancelAction.title destructiveButtonTitle:destructiveAction.title otherButtonTitles:defaultActions.firstObject.title, nil];
  for (NSInteger i = 1; i < defaultActions.count; ++i) {
    [sheet addButtonWithTitle:defaultActions[i].title];
  }
  self.actionSheet = sheet;
  [sheet showInView:self.view];
}

- (UIAlertControllerStyle)_controllerStyleWithStyle:(WYAlertControllerStyle)style {
  switch (style) {
    case WYAlertControllerStyleActionSheet:
      return UIAlertControllerStyleActionSheet;
      break;
    case WYAlertControllerStyleAlert:
      return UIAlertControllerStyleAlert;
      break;
    default:
      break;
  }
}

- (UIAlertActionStyle)_actionStyleWithStyle:(WYAlertActionStyle)style {
  switch (style) {
    case WYAlertActionStyleCancel:
      return UIAlertActionStyleCancel;
      break;
    case WYAlertActionStyleDefault:
      return UIAlertActionStyleDefault;
      break;
    case WYAlertActionStyleDestructive:
      return UIAlertActionStyleDestructive;
      break;
    default:
      break;
  }
}

- (UIViewController *)_stackTopViewController {
  UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  UIViewController *topVC = rootVC;
  while (topVC.presentedViewController) {
    topVC = topVC.presentedViewController;
  }
  return topVC;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  WYAlertAction *action = self.actions[buttonIndex];
  if (action.handler) {
    action.handler(action);
  }
  [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  WYAlertAction *action = self.actions[buttonIndex];
  if (action.handler) {
    action.handler(action);
  }
  [self dismissViewControllerAnimated:NO completion:nil];
}

@end
