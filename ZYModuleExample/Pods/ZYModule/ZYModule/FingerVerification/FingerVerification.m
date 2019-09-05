//
//  FingerVerification.m
//  MobileHospital
//
//  Created by 扬张 on 2019/2/13.
//  Copyright © 2019 ZY. All rights reserved.
//

#import "FingerVerification.h"

@implementation FingerVerification

static FingerVerification* fingerVerification =nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedFingerVerification{
    dispatch_once(&onceToken, ^{
        if (fingerVerification == nil) {
            fingerVerification = [[FingerVerification alloc] init];
        }
    });
    return fingerVerification;
}

- (instancetype)init {
    self= [super init];
    if(self) {
        self.context = [[LAContext alloc] init];
    }
    return self;
}

-(void)startVerification:(VerificationSuccessBlock)block failure:(VerificationFailureBlock)failureBlock
{
    NSError *error = nil;
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        //NSLog(@"支持指纹识别");
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"请按home键指纹登录" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(block)
                        block();
                });
                
            }else{
                if(failureBlock)
                    failureBlock();
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
        if(failureBlock)
            failureBlock();
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                [self showAlertWithStr:@"TouchID没有注册"];
                NSLog(@"TouchID没有注册");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                [self showAlertWithStr:@"TouchID没有设置密码"];
                NSLog(@"TouchID没有设置密码");
                break;
            }
            default:
            {
                [self showAlertWithStr:@"TouchID不可用"];
                NSLog(@"TouchID不可用");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}

-(void)startVerificationNoCheck:(VerificationSuccessBlock)block failure:(VerificationFailureBlock)failureBlock
{
    NSError *error = nil;
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //NSLog(@"支持指纹识别");
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按home键指纹登录" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(block)
                        block();
                });
                
            }else{
                if(failureBlock)
                    failureBlock();
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
        if(failureBlock)
            failureBlock();
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                [self showAlertWithStr:@"TouchID没有注册"];
                NSLog(@"TouchID没有注册");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                [self showAlertWithStr:@"TouchID没有设置密码"];
                NSLog(@"TouchID没有设置密码");
                break;
            }
            default:
            {
                if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]){
                    [_context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证密码" reply:^(BOOL success, NSError * _Nullable error) {
                        if (success) {
                            self.context = [[LAContext alloc] init];
                            NSLog(@"验证成功");
                        }else{
                            NSLog(@"验证失败");
                        }
                    }];
                }else{
                    [self showAlertWithStr:@"TouchID不可用"];
                    NSLog(@"TouchID不可用");
                }
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}

-(void)closeFingerVerification
{
    self.context = [[LAContext alloc] init];
}

-(void)showAlertWithStr:(NSString *)str
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [[self getCurrentRootViewController] presentViewController:alert animated:YES completion:nil];
}

- (UIViewController *)getCurrentRootViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        //多层present
        while (appRootVC.presentedViewController) {
            appRootVC = appRootVC.presentedViewController;
            if (appRootVC) {
                nextResponder = appRootVC;
            }else{
                break;
            }
        }
        //        nextResponder = appRootVC.presentedViewController;
    }else{
        
        //        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

@end
