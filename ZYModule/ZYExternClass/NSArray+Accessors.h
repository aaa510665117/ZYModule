//
//  NSArray+Accessors.h
//  MobileHospital
//
//  Created by 扬张 on 2018/10/9.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Accessors)

/*!
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */
- (id)ac_objectAtIndex:(NSUInteger)index;

@end
