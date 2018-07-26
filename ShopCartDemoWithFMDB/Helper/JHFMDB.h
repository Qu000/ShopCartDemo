//
//  JHFMDB.h
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"
#import "ShopModel.h"

@interface JHFMDB : NSObject


/**
 查找数据库

 @param pathString 路径字符串@"xx.sqlite"
 */
+ (void)querySQLWithPath:(NSString *)pathString;


/**
 创建表

 @param sqlName 表名
 @param block 回调
 */
+ (void)createTableWithSQLName:(NSString *)sqlName andResultBlock:(void(^)(NSString *result))block;



/**
 增

 @param sqlName 表名
 @param block 回调
 */
+(void)insertSQLWithName:(NSString *)sqlName andResultBlocck:(void(^)(BOOL result))block;


/**
 删

 @param sqlName 表名
 @param block 回调
 */
+(void)deleteSQLWithName:(NSString *)sqlName andResultBlock:(void(^)(BOOL result))block;


/**
 更新

 @param sqlName 表名
 @param block 回调
 */
+(void)updateSQLWithName:(NSString *)sqlName andResultBlocck:(void (^)(BOOL result))block;


/**
 搜索一条数据

 @param sqlName 表名
 @param block 回调
 */
+(void)searchOneDataWithSQL:(NSString *)sqlName andResultBlock:(void (^)(BOOL result, NSDictionary *dict))block;


/**
 搜索所有数据

 @param sqlName 表名
 @param block 回调
 */
+(void)searchAllDataWithSQL:(NSString *)sqlName andResultBlock:(void (^)(BOOL success, NSMutableArray *goodList))block;

@end
