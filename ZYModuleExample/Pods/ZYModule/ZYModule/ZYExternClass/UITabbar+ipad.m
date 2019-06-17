//
//  UITabbar+ipad.m
//  MobileHospital
//
//  Created by 扬张 on 2018/9/12.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "UITabbar+ipad.h"

@implementation UITabBar (ipad)

-(UITraitCollection *)traitCollection
{
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
        return [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact];
    }
    
    return [super traitCollection];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
