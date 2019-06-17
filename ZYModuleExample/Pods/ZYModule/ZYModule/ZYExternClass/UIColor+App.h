//
//  UIColor+App.h
//
//
//  Created by ZY on 2016/10/17.
//  Copyright © 2016年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (App)


+ (UIColor *)appNavigationColor;
+ (UIColor *)appNavigationTextColor;
+ (UIColor *)appNavigationTintColor;
+ (UIColor *)appViewBackColor;
//tabbar
+ (UIColor *)appTabBarColor;
//标题颜色
+ (UIColor *)appHeaderColor;

/**
 色值转换

 @param hexColor 色值
 @param opacity 透明度
 @return 颜色
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

/**
 色值转换
 
 @param color 色值
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
