//
//  WYAlertView.h
//  MyTest
//
//  Created by WuYikai on 16/2/3.
//  Copyright © 2016年 secoo. All rights reserved.
//  https://github.com/DouKing/WYAlertController

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  统一UIAlertView、UIActionSheet、UIAlertController
 */

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WYAlertActionStyle) {
  WYAlertActionStyleDefault = 0,
  WYAlertActionStyleCancel,
  WYAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, WYAlertControllerStyle) {
  WYAlertControllerStyleActionSheet = 0,
  WYAlertControllerStyleAlert
};

@interface WYAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(WYAlertActionStyle)style handler:(void (^ __nullable)(WYAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) WYAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface WYAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)alertTitle message:(nullable NSString *)alertMessage preferredStyle:(WYAlertControllerStyle)preferredStyle;

- (void)addAction:(WYAlertAction *)action;
@property (nonatomic, readonly) NSArray<WYAlertAction *> *actions;

@property (nullable, nonatomic, copy) NSString *alertTitle;
@property (nullable, nonatomic, copy) NSString *alertMessage;
@property (nonatomic, readonly) WYAlertControllerStyle preferredStyle;

- (void)showWithCompletion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
