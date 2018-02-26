//
//  SEHttpAPI.m
//  SkyEmergency
//
//  Created by ZY on 15/9/17.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

#import "SEHttpAPI.h"

@implementation SEHttpAPI

static SEHttpAPI *_sharedClient = nil;
static dispatch_once_t onceToken;

+ (SEHttpAPI *)sharedUpDownAPI {
    dispatch_once(&onceToken, ^{
        //_sharedClient = [[SEUpDownAPI alloc] initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
        _sharedClient = [[SEHttpAPI alloc] initWithBase];
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
    
    return self;
}

+ (NSString *)baseURLStr
{
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
//    //接口地址，上线修改为服务器获取
//    NSString * baseURLStr;
//    if(appDelegate.userProfile.firstaidAPIServer && ![appDelegate.userProfile.firstaidAPIServer isEqualToString:@""])
//    {
//        baseURLStr = [NSString stringWithFormat:@"http://%@:%@/%@/%@/",appDelegate.userProfile.firstaidAPIServer,appDelegate.userProfile.firstaidAPIServerPort,SEHTTP_REALM,SEHTTP_VERSION];
//    }
//    else
//    {
//        //@"http://192.168.20.13:80/firstaid/1.0/"];
//        baseURLStr = [NSString stringWithFormat:@"%@:%@/%@/%@/", DEFAULT_SEHTTP_ADDRESS,SEHTTP_PORT,SEHTTP_REALM,SEHTTP_VERSION];
//    }
    
    return baseURLStr;
}

//JSON解析
+(NSDictionary *)SEHttpJSON:(NSData *)dataStr
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
+(NSDictionary *)SEHttpStrToJSON:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        DDLogError(@"string-->json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSArray *)SEHttpJSONStrToArray:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        DDLogError(@"string-->json解析失败：%@",err);
        return nil;
    }
    return jsonArray;
}

//取消所有请求
-(void)canelRequestAll
{
    [self.operationQueue cancelAllOperations];
}

//普通POST请求
-(void)requestOrdinary:(NSString *)ApiName withParams:(NSDictionary *)params withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(NSDictionary *))failure
{
//    if (kNetworkNotReachability)
//    {
//        [ToolsFunction showPromptViewWithString:@"无法连接网络，请检查你的数据网络连接。" background:nil timeDuration:1];
//        return;
//    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",[SEHttpAPI baseURLStr],ApiName];
    
    DDLogInfo(@"\nAPI: requestOrdinary Address :: %@",requestUrl);
    
    [self POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSDictionary * dictReturn = [SEHttpAPI SEHttpJSON:responseObject];
        (success)? success(dictReturn):nil;
        DDLogInfo(@"\nAPI: %@  Info:: %@",requestUrl,dictReturn);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        DDLogError(@"\nAPI: requestOrdinary ERROR :: %@", error);
        (failure)? failure(nil):nil;
    }];
}

//普通GET请求
-(void)requestGETOrdinary:(NSString *)ApiUrl withParams:(NSDictionary *)params withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(NSDictionary *))failure
{
    NSString *requestUrl = ApiUrl;
    
    DDLogInfo(@"\nAPI: requestGET Address :: %@",requestUrl);
    
    [self GET:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dictReturn = [SEHttpAPI SEHttpJSON:responseObject];
        (success)? success(dictReturn):nil;
        DDLogInfo(@"\nAPI: %@  Info:: %@",requestUrl,dictReturn);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogError(@"\nAPI: requestGET ERROR :: %@", error);
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
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",[SEHttpAPI baseURLStr],apiurl];
    
    NSURLSessionDataTask *operation = [self POST:requestUrl parameters:param  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
        DDLogInfo(@"\n===========response===========\n%@:\n%@", apiurl, responseObject);
        if(success)
        {
            NSDictionary * dictReturn = [SEHttpAPI SEHttpJSON:responseObject];
            (success)? success(dictReturn):nil;
            DDLogInfo(@"\nAPI: %@  Info:: %@",requestUrl,dictReturn);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        DDLogError(@"\nAPI: requestOrdinary ERROR :: %@", error);
        (failure)? failure(nil):nil;
    }];
    
    return operation;
}

-(NSURLSessionDataTask *)uploadMultipartFile:(NSString *)apiurl withFile:(NSArray *)fileAry withParam:(NSMutableDictionary *)param name:(NSArray *)name fileName:(NSArray *)fileNameAry successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSDictionary *))failure
{
    //请求地址
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",[SEHttpAPI baseURLStr],apiurl];
    
    NSURLSessionDataTask *operation = [self POST:requestUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        for (int i=0; i<fileAry.count; i++) {
            
            //有文件再上传
            id file = [fileAry objectAtIndex:i];
            NSString *names =  [name objectAtIndex:i];
            NSString *fileName = [fileNameAry objectAtIndex:i];
            if(file != nil && [file isKindOfClass:[UIImage class]])
            {
                UIImage * image = (UIImage *)file;
                //图片
                NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                if ((float)imageData.length/1024 > 1000) {
                    imageData = UIImageJPEGRepresentation(image, 1024*1000.0/(float)imageData.length);
                }
                if (imageData) {
                    [formData appendPartWithFileData:imageData name:names fileName:fileName mimeType:@"image/jpeg"];
                }
            }
            else if(file != nil)
            {
                //file文件
                NSData *fileData = file;
                if (fileData) {
                    [formData appendPartWithFileData:fileData name:names fileName:fileName mimeType:@"file"];
                }
            }
        }
    }
    progress:nil
    success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDLogInfo(@"\n===========response===========\n%@:\n%@", apiurl, responseObject);
        if(success)
        {
            NSDictionary * dictReturn = [SEHttpAPI SEHttpJSON:responseObject];
            (success)? success(dictReturn):nil;
            DDLogInfo(@"\nAPI: %@  Info:: %@",requestUrl,dictReturn);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        DDLogError(@"\nAPI: requestOrdinary ERROR :: %@", error);
        (failure)? failure(nil):nil;
    }];
    
    return operation;
}

//基本错误码分析
+(void)analysisErrorCode:(NSDictionary *)code withRequestAdd:(NSString *)requestAdd
{
    NSString * codeStr = [code objectForKey:HTTP_RETURN_KEY];
    NSString * msgStr = [code objectForKey:HTTP_RETURN_MSG];

    if(msgStr.length == 0 || [msgStr class] == [NSNull null])
    {
        return;
    }
    switch ([codeStr integerValue]) {
        case 1011:
        {
            //处理用户信息失效
            [[AppDelegate appDelegate].userProfile resetUserIDThread];
            kTipAlert(@"你已被迫下线,请重新登录");
        }
            break;
        case 9998:
        {
            //系统错误
            [ToolsFunction showPromptViewWithString:@"服务器异常，请稍后再试" background:nil timeDuration:1];
            DDLogWarn(@"DEBUG: ***** 9998--系统错误 *****");
        }
            break;
        case 9999:
        {
            //参数错误
            [ToolsFunction showPromptViewWithString:@"服务器异常，请稍后再试" background:nil timeDuration:1];
            DDLogWarn(@"DEBUG: ***** 9999--参数错误 *****");
        }
            break;
        default:
        {
            [ToolsFunction showPromptViewWithString:[code objectForKey:HTTP_RETURN_MSG] background:nil timeDuration:1];
            DDLogWarn(@"DEBUG: ***** %@ --- %@-%@ *****",requestAdd,[code objectForKey:HTTP_RETURN_KEY],[code objectForKey:HTTP_RETURN_MSG]);
        }
            break;
    }
}

@end
