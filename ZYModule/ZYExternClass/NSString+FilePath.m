//
//  NSString+FilePath.m
//  AirHospital
//
//  Created by C_HAO on 15/10/9.
//  Copyright © 2015年 C_HAO. All rights reserved.
//

#import "NSString+FilePath.h"

@implementation NSString (FilePath)

+ (NSString *)homeDirectory
{
    return NSHomeDirectory();
}

+ (NSString *)documentDirectory
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
}

+ (NSString *)imageDefultDirectory
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
}

+ (NSString *)voiceDefultDirectory
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Voice"];
}

+(NSString *)FirstAddAdImagePath;
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image/FirstAPPAdImage"];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)userAvatarImagePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image/AvatarImage"];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)DocAuthImageImagePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image/DocAuthImage"];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)DidiDocImagePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image/DidiDocImage"];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)DidiSwsVoicePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Voice/DidiSwsVoice"];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/*
 crash路径
 */
+ (NSString *)CrashLogPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ErrorLogs"];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)userThumbnailImagePath:(NSString *)uid
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/Image/thumbnail",uid]];
    BOOL isDirectory = YES;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)userImagePath:(NSString *)uid
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/Image",uid]];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)userVoicePath:(NSString *)uid
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/Voice",uid]];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)userFilePath:(NSString *)uid
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/File/",uid]];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)tempPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/temp/"];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
