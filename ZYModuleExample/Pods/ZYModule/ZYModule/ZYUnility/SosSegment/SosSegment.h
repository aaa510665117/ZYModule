//
//  SosSegment.h
//  SkyEmergency
//
//  Created by ZY on 15/10/28.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChangeIndex)(long index);

@interface SosSegment : UIView

/**
 *  初始化方法 1
 *
 *  @param title segment标题
 *  @param frame segmentFrame
 *
 */
-(id)initWithTitle:(NSArray *)title withFrame:(CGRect)frame;

/**
 *  初始化方法 2
 *
 *  @param image segment图片标题
 *  @param frame segmentFrame
 *
 */
-(id)initWithImage:(NSArray *)image selectImage:(NSArray *)selectImage withFrame:(CGRect)frame;

/**
 *  视图Array
 */
@property(nonatomic, strong)NSMutableArray * viewArray;

/**
 *  titleArray---用于进行修改title
 */
@property(nonatomic, strong)NSArray * titleArray;

/**
 *  segment是否可以滑动       no-不可滑动  （默认可滑动）
 */
@property(nonatomic, assign)BOOL isSegScroolEnable;

/**
 *  初始化选择index  默认 0
 */
@property(nonatomic) IBInspectable NSInteger selectIndex;

@property(nonatomic, copy)ChangeIndex changIndex;

@end
