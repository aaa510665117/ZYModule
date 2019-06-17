//
//  ZYDataBaseManager.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/16.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "ZYDataBaseManager.h"

@implementation ZYDataBaseManager

static LKDBHelper* db;

//重载选择 使用的LKDBHelper
+(LKDBHelper *)getUsingLKDBHelperWithName:(NSString *)dbName
{
    @synchronized(self)
    {
        if(db == nil)
        {
            NSString * dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
            db = [[LKDBHelper alloc]initWithDBPath:[NSString stringWithFormat:@"%@/%@/%@.db",dir,dbName,dbName]];
            //加密
//            [db setKey:@"admin"];//key可以是随意字符串
        }
    }
    return db;
}

+(LKDBHelper *)getAllocLKDBHelperWithName:(NSString *)dbName
{
    if(dbName && ![dbName isEqualToString:@""])
    {
        return nil;
    }
    NSString * dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    db = [[LKDBHelper alloc]initWithDBPath:[NSString stringWithFormat:@"%@/%@/%@.db",dir,dbName,dbName]];
    
    return db;
}

+(void)closeDB
{
    if(db)
    {
        //        [db dbClose];
    }
    db = nil;       //销毁
}

+(void)clearAllTable
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    [db dropAllTable];
}

-(void)saveToDB
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    [db insertToDB:self];
}

-(void)saveToDB:(void(^)(void))success
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    [db insertToDB:self callback:^(BOOL result) {
        if(success) success();
    }];
}

-(void)updateToDB
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    [db updateToDB:self where:nil];
}

-(void)updateToDB:(void(^)(void))success
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    [db updateToDB:self where:nil callback:^(BOOL result) {
        if(success) success();
    }];
}

+(void)clearTable:(id)Class;
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    [db deleteWithClass:[Class class] where:@""];
}

+(BOOL)deleteToDB:(id)Class withSql:(id)where
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    BOOL isSuccess = [db deleteWithClass:[Class class] where:where];
    return isSuccess;
}

+(NSArray *)searchToDB:(id)Class
               withSql:(id)where
           withOrderBy:(NSString *)orderBy
            withOffSet:(NSInteger)offSet
             withCount:(NSInteger)count
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    NSArray * array = [db search:[Class class] where:where orderBy:orderBy offset:offSet count:count];
    return array;
}

+(void)searchToDB:(id)Class
          withSql:(id)where
      withOrderBy:(NSString *)orderBy
       withOffSet:(NSInteger)offSet
        withCount:(NSInteger)count
         callBack:(void(^)(NSMutableArray* array))block
{
    if(!db)
    {
        NSLog(@"DataBaseError");
    }
    [db search:[Class class] where:where orderBy:orderBy offset:offSet count:count callback:^(NSMutableArray *array) {
        block(array);
    }];
}

@end
