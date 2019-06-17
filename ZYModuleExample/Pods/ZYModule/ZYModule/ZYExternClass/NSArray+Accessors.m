//
//  NSArray+Accessors.m
//  MobileHospital
//
//  Created by 扬张 on 2018/10/9.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "NSArray+Accessors.h"

@implementation NSArray (Accessors)

- (id)ac_objectAtIndex:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
