//
//  HUD.m
//  MobileHospital
//
//  Created by ZY on 2019/6/17.
//  Copyright © 2019 ZY. All rights reserved.
//

#import "HUD.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"

@implementation HUD

#pragma mark -
#pragma mark Prompt MaskView Prompt

// 添加自定义提示框(图片+文字)
+ (void)showPromptViewWithString:(NSString*)string background:(UIImage*)image timeDuration:(int)duration {
    
    MBProgressHUD *hud;
    hud.tag = 90000;
    
    if(image != nil)
    {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        hud.color = [UIColor colorWithRed:0.863 green:0.875 blue:0.875 alpha:1.000];
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDModeCustomView;
        //        hud.square = YES;
        // Set an image view with a checkmark.
        UIImage *hudImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:hudImage];
        // Looks a bit nicer if we make it square.
        // Optional label text.
        hud.detailsLabelText = string;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:13]; //Johnkui - added
        hud.detailsLabelColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        [hud hide:YES afterDelay:duration];
    }
    else
    {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        hud.color = [UIColor colorWithRed:0.863 green:0.875 blue:0.875 alpha:1.000];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 15.f;
        hud.yOffset = 15.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.detailsLabelText = string;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:13]; //Johnkui - added
        hud.detailsLabelColor = [UIColor colorWithWhite:0.333 alpha:1.000];
        [hud hide:YES afterDelay:duration];
    }
}

// 请求提示窗
+ (void)showHttpPromptView:(UIView *)view
{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.929 alpha:1.000]];
    [SVProgressHUD setForegroundColor:[UIColor lightGrayColor]];
    
    if(view != nil)
    {
        [SVProgressHUD setContainerView:view];
    }
    else
    {
        [SVProgressHUD setContainerView:[UIApplication sharedApplication].delegate.window];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
}

// 请求提示窗
+ (void)showHttpPromptView:(UIView *)view withStr:(NSString *)str
{
    [SVProgressHUD showWithStatus:str];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.929 alpha:1.000]];
    [SVProgressHUD setForegroundColor:[UIColor lightGrayColor]];
    
    if(view != nil)
    {
        [SVProgressHUD setContainerView:view];
    }
    else
    {
        [SVProgressHUD setContainerView:[UIApplication sharedApplication].delegate.window];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
}

// 隐藏请求提示窗
+ (void)hideHttpPromptView:(UIView *)view
{
    [SVProgressHUD dismiss];
}

// 延迟隐藏请求提示窗
+ (void)hideHttpPromptView:(UIView *)view withDelay:(NSTimeInterval)delay
{
    [SVProgressHUD dismissWithDelay:1];
}

@end
