//
//  FingerVerification.h
//  MobileHospital
//
//  Created by 扬张 on 2019/2/13.
//  Copyright © 2019 ZY. All rights reserved.
//  指纹识别

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VerificationSuccessBlock)(void);
typedef void(^VerificationFailureBlock)(void);

@interface FingerVerification : NSObject

@property(nonatomic, strong) LAContext *context;

// 单例类
+ (instancetype)sharedFingerVerification;

//开启指纹验证  生物指纹识别
-(void)startVerification:(VerificationSuccessBlock)block failure:(VerificationFailureBlock)failureBlock;

//开启指纹验证  生物指纹识别或系统密码验证（推荐）
-(void)startVerificationNoCheck:(VerificationSuccessBlock)block failure:(VerificationFailureBlock)failureBlock;

//关闭指纹验证
-(void)closeFingerVerification;

@end

NS_ASSUME_NONNULL_END
