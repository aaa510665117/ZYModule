//
//  SEHttpAPI.m
//  SkyEmergency
//
//  Created by ZY on 15/9/17.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

#import "ZYHttpAPI.h"

@implementation ZYHttpAPI

static ZYHttpAPI *_sharedClient = nil;
static dispatch_once_t onceToken;

+ (ZYHttpAPI *)sharedUpDownAPI {
    dispatch_once(&onceToken, ^{
        //_sharedClient = [[SEUpDownAPI alloc] initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
        _sharedClient = [[ZYHttpAPI alloc] initWithBase];
    });
    return _sharedClient;
}

- (id)initWithBase{
    self = [super initWithBaseURL:nil];
    if (!self) {
        return nil;
    }

    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.securityPolicy.allowInvalidCertificates = YES;
    
//    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    // 是否在证书域字段中验证域名
//    self.securityPolicy.validatesDomainName = NO;
    
    return self;
}

//JSON解析
+(NSDictionary *)ZYHttpJSON:(NSData *)dataStr
{
    if(dataStr.length == 0 || dataStr == nil || [dataStr isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    NSString *result =  [[NSString alloc]initWithData:dataStr encoding:NSUTF8StringEncoding];
    NSData *returnData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonParsingError = nil;
    NSDictionary *returnArray = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:&jsonParsingError];
    return returnArray;
}

//String-->JSON解析
+(id)ZYHttpStrToJSON:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"string-->json解析失败：%@",err);
        return nil;
    }
    
    if (dic != nil){
        return dic;
    }else{
        // 解析错误
        return nil;
    }
}

//取消所有请求
-(void)canelRequestAll
{
    [self.operationQueue cancelAllOperations];
}

//Post普通请求
-(void)requestOrdinary:(NSString *)ApiName withParams:(NSDictionary *)params withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(NSDictionary *))failure
{
//    if (kNetworkNotReachability)
//    {
//        [ToolsFunction showPromptViewWithString:@"无法连接网络，请检查你的数据网络连接。" background:nil timeDuration:1];
//        return;
//    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@",ApiName];

    NSLog(@"\nAPI: requestOrdinary Address :: %@",requestUrl);
    
    [params setValue:@"phone" forKey:@"device"];      //设备类型
    
    [self POST:requestUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dictReturn = [ZYHttpAPI ZYHttpJSON:responseObject];
        (success)? success(dictReturn):nil;
        NSLog(@"\nAPI: %@  Info:: %@",requestUrl,dictReturn);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"\nAPI: requestOrdinary ERROR :: %@", error);
        (failure)? failure(nil):nil;
        
    }];
}

//Get普通请求
-(void)requestGetOrdinary:(NSString *)ApiName withParams:(NSDictionary *)params withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(NSDictionary *))failure
{
    //    if (kNetworkNotReachability)
    //    {
    //        [ToolsFunction showPromptViewWithString:@"无法连接网络，请检查你的数据网络连接。" background:nil timeDuration:1];
    //        return;
    //    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@",ApiName];
    
    NSLog(@"\nAPI: requestOrdinary Address :: %@",requestUrl);
    
    [params setValue:@"phone" forKey:@"device"];      //设备类型

    [self GET:requestUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSDictionary * dictReturn = [ZYHttpAPI ZYHttpJSON:responseObject];
        (success)? success(dictReturn):nil;
        NSLog(@"\nAPI: %@  Info:: %@",requestUrl,dictReturn);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"\nAPI: requestOrdinary ERROR :: %@", error);
        (failure)? failure(nil):nil;
    }];
}

// POST上传单文件文件
- (NSURLSessionDataTask *)uploadFile:(NSString *)apiurl
          withFile:(id)file
          withParam:(NSMutableDictionary *)param
               name:(NSString *)name
           fileName:(NSString *)fileName
       successBlock:(void(^)(NSDictionary *success))success
       failureBlock:(void(^)(NSDictionary *failure))failure;
{
    //请求地址
    NSString *requestUrl = [NSString stringWithFormat:@"%@",apiurl];
    [param setValue:@"phone" forKey:@"device"];      //设备类型

    NSURLSessionDataTask *operation = [self POST:requestUrl parameters:param  headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //有文件再上传
        if(file != nil && [file isKindOfClass:[UIImage class]])
        {
            UIImage * image = (UIImage *)file;
            //图片
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            if ((float)imageData.length/1024 > 1000) {
                imageData = UIImageJPEGRepresentation(image, 1024*1000.0/(float)imageData.length);
            }
            if (imageData) {
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        else if(file != nil)
        {
            //file文件
            NSData *fileData = file;
            if (fileData) {
                [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:@"file"];
            }
        }
        
    }
    progress:nil
    success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"\n===========response===========\n%@:\n%@", apiurl, responseObject);
        if(success)
        {
            NSDictionary * dictReturn = [ZYHttpAPI ZYHttpJSON:responseObject];
            (success)? success(dictReturn):nil;
            NSLog(@"\nAPI: %@  Info:: %@",requestUrl,dictReturn);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"\nAPI: requestOrdinary ERROR :: %@", error);
        (failure)? failure(nil):nil;
    }];
    
    return operation;
}

-(NSURLSessionDataTask *)uploadMultipartFile:(NSString *)apiurl withFile:(NSArray *)fileAry withParam:(NSMutableDictionary *)param name:(NSArray *)name fileName:(NSArray *)fileNameAry successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSDictionary *))failure
{
    //请求地址
    NSString *requestUrl = [NSString stringWithFormat:@"%@",apiurl];
    [param setValue:@"phone" forKey:@"device"];      //设备类型
    
    NSURLSessionDataTask *operation = [self POST:requestUrl parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        for (int i=0; i<fileAry.count; i++) {
            
            id file = [fileAry objectAtIndex:i];
            if(file != nil && [file isKindOfClass:[UIImage class]])
            {
                UIImage * image = [fileAry objectAtIndex:i];
                //图片
                NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                if ((float)imageData.length/1024 > 1000) {
                    imageData = UIImageJPEGRepresentation(image, 1024*1000.0/(float)imageData.length);
                }
                NSString *names =  [name objectAtIndex:i];
                NSString *fileName = [fileNameAry objectAtIndex:i];
                
                if (imageData != NULL) {
                    
                    [formData appendPartWithFileData:imageData name:names fileName:fileName mimeType:@"image/jpeg"];
                }
            }
            else if(file != nil)
            {
                //file文件
                NSData *fileData = file;
                NSString *names =  [name objectAtIndex:i];
                NSString *fileName = [fileNameAry objectAtIndex:i];
                if (fileData) {
                    [formData appendPartWithFileData:fileData name:names fileName:fileName mimeType:@"file"];
                }
            }
        }
    }
    progress:nil
    success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"\n===========response===========\n%@:\n%@", apiurl, responseObject);
        if(success)
        {
            NSDictionary * dictReturn = [ZYHttpAPI ZYHttpJSON:responseObject];
            (success)? success(dictReturn):nil;
            NSLog(@"\nAPI: %@  Info:: %@",requestUrl,dictReturn);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"\nAPI: requestOrdinary ERROR :: %@", error);
        (failure)? failure(nil):nil;
    }];
    
    return operation;
}

//基本错误码分析
//+(void)analysisErrorCode:(NSDictionary *)code withRequestAdd:(NSString *)requestAdd
//{
//    NSString * codeStr = [code ac_stringForKey:HTTP_RETURN_KEY];
//    NSString * msgStr = [code ac_stringForKey:HTTP_RETURN_MSG];
//
//    if(msgStr.length == 0 || [msgStr class] == [NSNull null])
//    {
//        return;
//    }
//    switch ([codeStr integerValue]) {
//        case 1011:
//        {
//            //处理用户信息失效
//            [[AppDelegate appDelegate].userProfile resetUserIDThread];
////            kTipAlert(@"你已被迫下线,请重新登录");
//        }
//            break;
//        case 9998:
//        {
//            //系统错误
//            [ToolsFunction showPromptViewWithString:@"服务器异常，请稍后再试" background:nil timeDuration:1];
//            NSLog(@"DEBUG: ***** 9998--系统错误 *****");
//        }
//            break;
//        case 9999:
//        {
//            //参数错误
//            [ToolsFunction showPromptViewWithString:@"服务器异常，请稍后再试" background:nil timeDuration:1];
//            NSLog(@"DEBUG: ***** 9999--参数错误 *****");
//        }
//            break;
//        default:
//        {
//            [ToolsFunction showPromptViewWithString:[code objectForKey:HTTP_RETURN_MSG] background:nil timeDuration:1];
//            NSLog(@"DEBUG: ***** %@ --- %@-%@ *****",requestAdd,[code objectForKey:HTTP_RETURN_KEY],[code objectForKey:HTTP_RETURN_MSG]);
//        }
//            break;
//    }
//}

@end
