//
//  ZYDataBaseManager.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/16.
//  Copyright © 2018年 ZY. All rights reserved.
//  数据库管理类

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>

@interface ZYDataBaseManager : NSObject

/**
 *  取出单例LKDBHelper
 */
+(LKDBHelper *)getUsingLKDBHelperWithName:(NSString *)dbName;

/**
 *  创建LKDBHelper
 */
+(LKDBHelper *)getAllocLKDBHelperWithName:(NSString *)dbName;

/**
 *  关闭表
 */
+(void)closeDB;

/**
 *  删除所有表
 */
+(void)clearAllTable;

/**
 *  保存
 */
-(void)saveToDB;

/*
 异步保存
 */
-(void)saveToDB:(void(^)(void))success;

/**
 *  更新
 */
-(void)updateToDB;

/**
 *  异步更新
 */
-(void)updateToDB:(void(^)(void))success;

/**
 *  清空表数据
 */
+(void)clearTable:(id)Class;

/**
 *  条件删除
 *  class    表类名
 *  where    删除条件
 */
+(BOOL)deleteToDB:(id)Class withSql:(id)where;

/**
 *  条件查询---同步
 *  Class       表类名
 *  where       查询条件
 *  orderBy     升序 or 降序        The Sort: Ascending "name asc",Descending "name desc"
 *  offSet      跳过多少行
 *  count       条数限制
 */
+(NSArray *)searchToDB:(id)Class
               withSql:(id)where
           withOrderBy:(NSString *)orderBy
            withOffSet:(NSInteger)offSet
             withCount:(NSInteger)count;

/**
 *  条件查询---异步
 *  Class       表类名
 *  where       查询条件
 *  orderBy     升序 or 降序        The Sort: Ascending "name asc",Descending "name desc"
 *  offSet      跳过多少行
 *  count       条数限制
 *  blcok       完成后操作
 */
+(void)searchToDB:(id)Class
          withSql:(id)where
      withOrderBy:(NSString *)orderBy
       withOffSet:(NSInteger)offSet
        withCount:(NSInteger)count
         callBack:(void(^)(NSMutableArray* array))block;

@end
