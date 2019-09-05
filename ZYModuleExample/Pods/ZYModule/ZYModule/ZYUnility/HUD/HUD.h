//
//  HUD.h
//  MobileHospital
//
//  Created by ZY on 2019/6/17.
//  Copyright © 2019 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUD : NSObject

// 添加自定义提示框(图片+文字)
+ (void)showPromptViewWithString:(NSString*)string background:(UIImage*)image timeDuration:(int)duration;

// 显示请求提示窗
+ (void)showHttpPromptView:(UIView *)view;

// 显示请求提示窗str
+ (void)showHttpPromptView:(UIView *)view withStr:(NSString *)str;

// 隐藏请求提示窗f
+ (void)hideHttpPromptView:(UIView *)view;

// 延迟隐藏请求提示窗
+ (void)hideHttpPromptView:(UIView *)view withDelay:(NSTimeInterval)delay;

@end
