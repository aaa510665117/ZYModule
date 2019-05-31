//
//  ToolsFunction.m
//  SkyEmergency
//
//  Created by ZY on 15/9/8.
//  Copyright (c) 2015年 ZY. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ToolsFunction.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import <MessageUI/MessageUI.h>

@implementation ToolsFunction

#pragma mark -
#pragma mark Network

// 检查并提示用户开启推送通知
+ (void)checkAndShowPushNotificationDisableAlert
{
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationSettings *userNotificationSettings = [application currentUserNotificationSettings];
        UIUserNotificationType notifyType = userNotificationSettings.types;
        
        // 判断Push推送功能是否开启
        NSLog(@"TOOLS: [application enabledRemoteNotificationTypes] = %d", (int)notifyType);
        
        // 判断系统的Notifications是否开启
        if ((notifyType & UIUserNotificationTypeAlert) == NO)
        {
            // 提示用户开启Push通知
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TITLE_PUSH_NOTIFICATIONS_DISABLED", nil)
                                                                           message:NSLocalizedString(@"PROMPT_PUSH_NOTIFICATIONS_DISABLED", nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
            [vc presentViewController:alert animated:YES completion:nil];
        }
    }
}

+ (UIViewController *)getCurrentRootViewController
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

+ (UIViewController *)getSignViewController
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

+ (void)exitApp
{
    exit(0);
}

// 读取plist资源数据 (注意：在外部释放返回值)
+ (NSMutableDictionary *)loadResourceFromPlist:(NSString *)fileName
                            withDictionaryPath:(NSString *)dictionaryPath
{
    NSMutableDictionary *contactPhonePlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", dictionaryPath, fileName]];
    return contactPhonePlist;
}

// 保存plist文件数据
+ (void)saveResourceToPlist:(NSMutableDictionary *)contactPhoneDic
               withFileName:(NSString *)fileName
         withDictionaryPath:(NSString *)dictionaryPath
{
    if(contactPhoneDic==nil)
        return;  // 异常保护
    
    NSMutableDictionary *contactDic = [[NSMutableDictionary alloc] initWithDictionary:contactPhoneDic];
    if (contactDic!=nil )
    {
        if([contactDic count] > 0)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isDirectory = NO;
            
            if(NO == [fileManager fileExistsAtPath:dictionaryPath isDirectory:&isDirectory])
            {
                [fileManager createDirectoryAtPath:dictionaryPath
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:nil];
            }
            
            [contactDic writeToFile:[NSString stringWithFormat:@"%@/%@", dictionaryPath, fileName] atomically:YES];
        }
    }
}

// 判断是否只含有字母、数字
+ (BOOL)isOnlyAbcAndNum:(NSString *)string
{
    if ([string length]==0) {
        return NO;
    }
    
    NSString *phoneRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return ![phoneTest evaluateWithObject:string];
}

// 对文本进行UTF8+URL编码
// stringText: 编码的文本字符串
+ (NSString *)urlEncodeUTF8String:(NSString *)stringText
{
    if (stringText == nil) {
        return nil;
    }
    
    // 启用Url编码
    NSString *urlStr = [stringText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return urlStr;
}

// 对文本进行UTF8+URL解码
+ (NSString *)urlDecodeUTF8String:(NSString *)stringText
{
    if (stringText == nil) {
        return nil;
    }
    
    NSString *urlStr = [stringText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return urlStr;
}


// 获取字符串的长度
+ (CGSize)getSizeFromString:(NSString *)stringText withFont:(UIFont *)font constrainedToSize:(CGSize)maxSize
{
    if (stringText == nil || font == nil)
    {
        return CGSizeZero;
    }
    CGSize size = CGSizeZero;
    
    if ([stringText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGRect rect = [stringText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName] context:nil];
        size = CGSizeMake(rect.size.width, rect.size.height);
    }
    else
    {
        //        size = [stringText sizeWithFont:font constrainedToSize:maxSize];
        CGRect rect = [stringText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        size = CGSizeMake(rect.size.width, rect.size.height);
    }
    
    return size;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 把image缩放到给定的size
+ (UIImage *)scaleImageSize:(UIImage *)sourceImage toSize:(CGSize)imageSize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(imageSize);
    // 绘制改变大小的图片
    [sourceImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

// 把image缩放到给定的比例
+ (UIImage *)scaleImageSize:(UIImage *)sourceImage toProportion:(float)proportion
{
    CGRect rect = CGRectMake(0, 0, sourceImage.size.width*proportion, sourceImage.size.height*proportion);
    UIGraphicsBeginImageContext(rect.size);
    [sourceImage drawInRect:rect];
    UIImage *scalingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scalingImage;
}

//裁剪成圆形
+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

// Animation
+ (void)moveUpTransition:(BOOL)bUp forLayer:(CALayer*)layer {
    CATransition *transition = [CATransition animation];
    if (bUp) {
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
    } else {
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
    }
    [layer addAnimation:transition forKey:nil];
}

//设置cell的右边箭头
+ (void)setCellAccessoryView:(UITableViewCell *)cell
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView * imageAccessory = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageAccessory.image = [UIImage imageNamed:@"roleApplyRight"];
    cell.accessoryView = imageAccessory;
}

/* Get Local iOS language
 zh-Hans = 简体中文
 zh-Hant = 繁体中文
 en = 英文（其他国家默认语言）
 ja = 日语
 ar = 阿拉伯语言
 */
+ (NSString *)getOSLanguage {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *systemlanguage = nil;
    
    if (languages)
    {
        systemlanguage = [languages objectAtIndex:0];
    }
    
    return systemlanguage;
}

/**
 *  保存数组至plist
 */
+ (void)saveArrayData:(NSArray *)dataArray withPlistFileName:(NSString *)fileName
{
    if (dataArray != nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        
        if (NO == [fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"] isDirectory:&isDirectory]) {
            [fileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"]
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        
        [dataArray writeToFile:[NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"], fileName] atomically:YES];
    }
}

/**
 *  保存字典至plist
 */
+ (void)saveDictionaryData:(NSDictionary *)dataDictionary withPlistFileName:(NSString *)fileName
{
    if (dataDictionary != nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        
        if (NO == [fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"] isDirectory:&isDirectory]) {
            [fileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"]
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        
        [dataDictionary writeToFile:[NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"], fileName] atomically:YES];
    }
}
/**
 *  读取plist 数组
 *
 */
+ (NSArray *)loadPlistArrayData:(NSString *)fileName
{
    if (!fileName.length) {
        return nil;
    }
    
    return [[NSArray alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"], fileName]];
}
/**
 *  读取plist 字典
 *
 */
+ (NSDictionary *)loadPlistDictionaryData:(NSString *)fileName
{
    if (!fileName.length) {
        return nil;
    }
    
    return [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"], fileName]];
}

/**
 *  获取文件大小
 *
 */
+ (NSString *)getFileSizePath:(NSString *)filePath
{
    NSString *strFileSize = @"0";
    NSError *error = nil;
    
    if ([ToolsFunction isFileExistsAtPath:filePath]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        
        if (fileAttributes != nil) {
            float fileSize = [[fileAttributes objectForKey:NSFileSize] floatValue];
            
            strFileSize = [NSString stringWithFormat:@"%.0f", fileSize];
        }
    }
    
    return strFileSize;
}


/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
    
}

/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

// 判断是否为纯数字的字符串
+ (BOOL)isPureDigit:(NSString *)stringNumber
{    
    int val = 0;
    NSScanner * scan = [NSScanner scannerWithString:stringNumber];
    
    BOOL bPureDigit = [scan scanInt:&val] && [scan isAtEnd];
    //    /DDLogVerbose(@"TOOLS: isPureDigit: stringNumber = %@, return bPureDigit = %d", stringNumber, bPureDigit);
    return bPureDigit;
}

// 判断是否为浮点形的字符串
+ (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//去掉字符串首尾空格
+ (NSString *)replaceStrForeAndaftApace:(NSString *)str{
    NSString * result = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName:(NSString *)userName
{
    if (![userName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString *pattern = @"^[a-zA-Z一-龥]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    
    return isMatch;
}

//判断是否是ip地址
+ (BOOL)isValidIP:(NSString *)ipStr {
    if (nil == ipStr) {
        return NO;
    }
    
    NSArray *ipArray = [ipStr componentsSeparatedByString:@"."];
    if (ipArray.count == 4) {
        for (NSString *ipnumberStr in ipArray) {
            int ipnumber = [ipnumberStr intValue];
            if (!(ipnumber>=0 && ipnumber<=255)) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

// 使用原生的电话切换到GSM呼叫
+ (void)callToGSM:(NSString *)phoneNumber
{
    // 去掉号码中的空格/-/(/)/ (ios7)
    NSString * phone = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 使用原生的Phone打电话("tel"－电话结束后停留在原生电话页面
    // "telprompt"－电话结束后回到自己的程序(但是这种方法可能是私有的不能上app store))
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
    
    // 跳转到其它应用执行GSM呼叫
    NSLog(@"TOOLS: callToGSM:%@", phoneNumberURL);
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
}

//// 通过iOS SMS接口发送短信
//+ (BOOL)sendSMSMessage:(NSString *)contentString toPhone:(NSArray *)numberArray
//{
//    DDLogInfo(@"TOOLS: sendSMSMessage: contentString = %@", contentString);
//
//    AppDelegate * appDelegate = [AppDelegate appDelegate];
//
//    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
//    if (canSendSMS)
//    {
//        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
//        picker.messageComposeDelegate = appDelegate;
//        picker.navigationBar.tintColor = [UIColor blackColor];
//        if (numberArray.count != 0) {
//            picker.recipients = numberArray;
//        }
//        picker.body = contentString;
//        //        [appDelegate.mainTabController presentModalViewController:picker animated:YES];
//        [appDelegate.mainTabController presentViewController:picker animated:YES completion:^{
//        }];
//    }
//    else {
//        // 不支持则弹出Alert
//        [ToolsFunction showPromptViewWithString:@"该设备无法发送短信" background:nil timeDuration:1];
//    }
//    return canSendSMS;
//}

+ (BOOL)isUserID:(NSString *)userID
{
    //uid暂时为8位
    NSString *phoneRegex = @"^.{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:userID];
}

+ (BOOL)isOrderID:(NSString *)orderID
{
    //判断是否为腰酸背痛订单id
    NSString * first = [[orderID componentsSeparatedByString:@"_"] firstObject];
    if([first isEqualToString:@"YSBTDDID"])
    {
        return YES;
    }
    else
        return NO;
}

#pragma mark -
#pragma mark Image Operate Function

// 旋转拍照后的图片
+ (UIImage *)rotateImage:(UIImage *)image oritation:(UIImageOrientation)theOritation
{
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),
                                  CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    
    switch(theOritation) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width,
                                                         imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height,
                                                         imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (theOritation == UIImageOrientationRight || theOritation ==
        UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//将图片处理成大小不超过1024
+ (CGSize)imageSizeFix:(CGSize)sourceImageSize{
    
    float imageHeight = sourceImageSize.height;
    float imageWidth = sourceImageSize.width;
    float rate = 0.0;
    
    float max = 1024.0f;
    
    if ((imageWidth > max) ||
        (imageHeight > max))
    {
        if (imageWidth > imageHeight)
        {
            rate = max / imageWidth;
            imageWidth = max;
            imageHeight = imageHeight * rate;
        }
        else {
            rate = max / imageHeight;
            imageHeight = max;
            imageWidth = imageWidth * rate;
        }
    }
    return CGSizeMake(imageWidth, imageHeight);
}

+ (NSString *)getCurrentSysDateSecond
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSince1970];
    NSString *strTimeInterval = @(floor(timeInterval)).stringValue;
    return strTimeInterval;
}

//将int型秒数转换为00：00格式
+(NSString *)secondToOOOO:(NSInteger)second
{
    NSString *tmpmm = [NSString stringWithFormat:@"%ld",(second/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%ld",second%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    NSString * resultStr = [NSString stringWithFormat:@"%@:%@",tmpmm,tmpss];
    return resultStr;
}

//将int型秒数转换为00：00格式
+(NSString *)secondToOOOOOO:(NSInteger)second
{
    NSString *tmphh = [NSString stringWithFormat:@"%ld",second/3600];
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%ld",(second/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%ld",second%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    NSString * resultStr = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    return resultStr;
}

+(NSString *)secondToCircleTime:(NSString *)second
{
    if ([second intValue]/60>=24) {
        return [NSString stringWithFormat:@"%d天前",[second intValue]/60/24];
    }else if ([second intValue]>=60) {
        return [NSString stringWithFormat:@"%d小时前",[second intValue]/60];
    }else if([second intValue]>0){
        return [NSString stringWithFormat:@"%d分钟前",[second intValue]];
    }else{
        return @"刚刚";
    }
}

+(float)timeToFloatWithTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:time];
    return [destDate timeIntervalSince1970];
}

+ (NSString *)getStandardTime:(NSString *)dateSecond withFormat:(NSString *)format
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dateSecond longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *temp = [formatter stringFromDate:confromTimesp];
    
    return temp;
}

+ (NSString *)getFormatTime:(NSString *)dateStr withFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fromFormat];
    NSDate *destDate= [dateFormatter dateFromString:dateStr];
//    destDate = [NSDate dateWithTimeIntervalSince1970:destDate];
    [dateFormatter setDateFormat:toFormat];
    NSString *temp = [dateFormatter stringFromDate:destDate];
    return temp;
}

+(NSString *)getCurrentTimesTamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

+(NSDate *)getOldDayDataWithNum:(long)num
{    
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(num!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*num ];
    }
    else
    {
        theDate = nowDate;
    }
    return theDate;
}

//当前时间往前某个月
+(NSDate *)getPriousorLaterDateFromDate:(int)month{
    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:currentDate options:0];
    return mDate;
    
}

+(NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month
{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

// 判断是否只含有汉字、字母、数字
+ (BOOL)isOnlyChineseAndAbcAndNum:(NSString *)string
{
    if ([string length]==0) {
        return NO;
    }
    
    NSString *phoneRegex = @"^[\u4E00-\u9FA5A-Za-z0-9]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return ![phoneTest evaluateWithObject:string];
}

// 获取每通电话的CallID（格式：user id -unix epoch time(s)-2 digits random number，如：24000001-1307516199-83）
+ (NSString *)getCurrentCallID:(NSString *)userID
{
    // 得到当前的系统时间(秒)
    NSString *strTimeInterval = [ToolsFunction getCurrentSysDateSecond];
    
    // 得到两位的随机数
    NSString *strRandom = [NSString stringWithFormat:@"%02ld", random()%99 + 1];
    //NSLog(@"TOOLS: getCurrentCallID: timeInterval=%@, strRandom=%@", strTimeInterval, strRandom);
    
    NSString *stringCallID = [NSString stringWithFormat:@"%@-%@-%@", userID, strTimeInterval, strRandom];
    // NSLog(@"TOOLS: getCurrentCallID: stringCallID = %@", stringCallID);
    
    return stringCallID;
}

//路径是否存在
+ (BOOL)isFileExistsAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL)isImageFileAtPath:(NSString *)filePath
{
    BOOL file = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    file = [fileManager fileExistsAtPath:filePath];
    
    if (file) {
        
        //文件小于57byte 则不会是图片
        if ([[fileManager attributesOfItemAtPath:filePath error:nil] fileSize] <= 57) {
            
            return NO;
            
        }
        
    }
    
    return file;
}

//toJSONData
+ (NSString *)toJSONData:(id)data
{
    if (!data) {
        return @"";
    }
    if ([data isKindOfClass:[NSString class]]) {
        return data;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}

+ (void)clearPathFile:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:filePath isDirectory:&isDirectory])
    {
        [manager createDirectoryAtPath:filePath  withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        NSArray *filesArray = [manager contentsOfDirectoryAtPath:filePath  error:nil];
        if ([filesArray count] > 0)
        {
            NSString *fileName = nil;
            for (int i = 0; i < [filesArray count]; i++)
            {
                fileName = [filesArray objectAtIndex: i];
                [manager removeItemAtPath:[filePath  stringByAppendingPathComponent: fileName] error:nil];
            }
        }
    }
}

//检查语音权限
//+ (BOOL)checkVoicePermission{
//
//    //    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
//    //    return permission == AVAudioSessionRecordPermissionGranted;
//    __block BOOL bCanRecord = YES;
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
//        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
//        if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {// 未询问用户是否授权
//            bCanRecord = NO;
//            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//            if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
//                [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//                    if (granted) {
//                        bCanRecord = YES;
//                    } else {
//                        bCanRecord = NO;
//                    }
//                }];
//            }
//        } else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
//            // 未授权
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启"
//                                                                           message:@"麦克风权限未开启,请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            }]];
//
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //跳入当前App设置界面
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//            }]];
//            UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
//            [vc presentViewController:alert animated:YES completion:nil];
//            bCanRecord = NO;
//
//        } else{
//            // 已授权
//            NSLog(@"已授权");
//            bCanRecord = YES;
//        }
//    }
//    return bCanRecord;
//}

////音频格式转换
//+ (NSString *)SEAudioFilePath:(NSString *)filePath
//{
//    NSString *subType = [[NSString alloc] initWithString:[[filePath componentsSeparatedByString:@"/"] lastObject]];
//
//    NSString *tempPlayVoiceFilePath = filePath;
//
//    if (![filePath hasSuffix:@".xxx"] && [subType hasSuffix:@".amr"]) {
//        filePath = [[NSString alloc] initWithFormat:@"%@.wav", filePath];
//    }
//    else if (![filePath hasSuffix:@".xxx"] && [subType hasSuffix:@".wav"]) {
//        filePath = [[NSString alloc] initWithFormat:@"%@.amr", filePath];
//    }
//
//    if ([JSQMessageTools isFilePath:filePath]) {
//        return filePath;
//    }
//
//    if ([subType hasSuffix:@".amr"] && ![filePath hasSuffix:@".xxx"]) {
//        [VoiceConverter ConvertAmrToWav:tempPlayVoiceFilePath wavSavePath:filePath];
//    }
//    else if ([subType hasSuffix:@".wav"] && ![filePath hasSuffix:@".xxx"]) {
//        [VoiceConverter ConvertWavToAmr:tempPlayVoiceFilePath amrSavePath:filePath];
//    }
//
//    return filePath;
//}
//
//+ (void)SETTSWithStr:(NSString *)textStr
//{
//    //语音播报
//    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:textStr];
//    utterance.pitchMultiplier=0.8;
//    //中式发音
//    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
//    //英式发音
//    // AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
//    utterance.voice = voice;
//    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
//    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
//    [synth speakUtterance:utterance];
//}

@end
