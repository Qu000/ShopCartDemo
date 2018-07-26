//
//  shopModel.h
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

/** goodsId*/
@property (nonatomic, strong) NSString * goodsId;

/** goodsName*/
@property (nonatomic, strong) NSString * goodsName;

/** goodsPrice*/
@property (nonatomic, strong) NSString * goodsPrice;

/** 存入的number*/
@property (nonatomic, assign) int goodsNum;
@end
