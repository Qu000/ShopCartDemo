//
//  JHFMDB.m
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHFMDB.h"

FMDatabase *db;
@implementation JHFMDB

/**
 查找数据库
 
 @param pathString 路径字符串@"xx.sqlite"
 */
+ (void)querySQLWithPath:(NSString *)pathString
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:pathString];
    
    //FMDB 创建数据库文件
    db = [FMDatabase databaseWithPath:path];
    NSLog(@"db--path==%@",path);
}


/**
 创建表
 
 @param sqlName 表名
 @param block 回调
 */
+ (void)createTableWithSQLName:(NSString *)sqlName andResultBlock:(void(^)(NSString *result))block
{
    NSString *jh;
    if ([db open]) {
        
        if ([db executeUpdate:sqlName]) {
            jh = @"创建表成功";
        }else{
            jh = @"创建表失败";
        }
        
        block(jh);
    }
    
}



/**
 增
 
 @param sqlName 表名
 @param block 回调
 */
+(void)insertSQLWithName:(NSString *)sqlName andResultBlocck:(void(^)(BOOL result))block
{
    BOOL jh;
    
    if ([db open]) {
        if ([db executeUpdate:sqlName]) {
            
            jh = YES;
        }else{
            
            jh = NO;
        }
        
        block(jh);
    }
    
}


/**
 删
 
 @param sqlName 表名
 @param block 回调
 */
+(void)deleteSQLWithName:(NSString *)sqlName andResultBlock:(void(^)(BOOL result))block
{
    BOOL jh;
    
    if ([db open]) {
        
        if ([db executeUpdate:sqlName]) {
            jh = YES;
        }else{
            jh = NO;
        }
        
        block(jh);
        
    }
    
}


/**
 更新
 
 @param sqlName 表名
 @param block 回调
 */
+(void)updateSQLWithName:(NSString *)sqlName andResultBlocck:(void (^)(BOOL result))block
{
    BOOL jh;
    
    if ([db open]) {
        
        if ([db executeUpdate:sqlName]) {
            jh = YES;
        }else{
            jh = NO;
        }
        
        block(jh);
        
    }
}


/**
 搜索一条数据
 
 @param sqlName 表名
 @param block 回调
 */
+(void)searchOneDataWithSQL:(NSString *)sqlName andResultBlock:(void (^)(BOOL result, NSDictionary *dict))block
{
    BOOL result = NO;
    
    //desc 降序---asc 升序
    //ex：NSString *sql=@"select *from 表 order by 查询字段 asc";
    
    if ([db open]) {
        
        //将查询到的数据放到FMResultSet里
        FMResultSet *set = [db executeQuery:sqlName];
        
        NSMutableDictionary *goodsDict = [NSMutableDictionary dictionary];
        
        if ([set next]) {
            
            result = YES;
            [goodsDict setObject:[set stringForColumn:@"goodsId"] forKey:@"goodsId"];
            [goodsDict setObject:[set stringForColumn:@"goodsName"] forKey:@"goodsName"];
            [goodsDict setObject:[set stringForColumn:@"goodsPrice"] forKey:@"goodsPrcie"];
            [goodsDict setObject:@([set intForColumn:@"goodsNum"]) forKey:@"goodsNum"];
        }
        
        block(result,goodsDict);
    }
}


/**
 搜索所有数据
 
 @param sqlName 表名
 @param block 回调
 */
+(void)searchAllDataWithSQL:(NSString *)sqlName andResultBlock:(void (^)(BOOL success, NSMutableArray *goodList))block
{
    BOOL success = NO;
    if ([db open]) {
        
        FMResultSet *set = [db executeQuery:sqlName];
        
        NSMutableArray *list = [NSMutableArray array];
        
        while ([set next]) {
            
            success = YES;
            
            ShopModel *model = [ShopModel new];
            
            model.goodsId = [set objectForColumnName:@"goodsId"];
            model.goodsName = [set objectForColumnName:@"goodsName"];
            model.goodsPrice = [set objectForColumnName:@"goodsPrice"];
            model.goodsNum = [set intForColumn:@"goodsNum"];
            
            [list addObject:model];
        }
        
        block(success,list);
    }
}

@end
