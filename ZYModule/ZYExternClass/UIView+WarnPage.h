//
//  UIView+WarnPage.h
//  MobileHospital
//
//  Created by 扬张 on 2018/12/14.
//  Copyright © 2018 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(WarnPage)

/**
 *  展示请求错误背景
 */
- (void)loadErrorBackViewTitle:(NSString *)title reload:(void (^)(void))reloadData;

/**
 *  展示无数据背景
 */
- (void)loadNoDataBackViewTitle:(NSString *)title;

/**
 *  展示
 *
 *  @param image     居中图片
 *  @param title     正文
 *  @param describe  描述
 *  @param operation 点击操作
 */
- (void)loadBackView:(UIImage *)image withTitle:(NSString *)title withDescribe:(NSString *)describe operation:(void (^)(void))operation;

/**
 *  移除
 */
- (void)removeBackView;

@end
