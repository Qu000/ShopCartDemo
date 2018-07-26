//
//  ShopCartCell.h
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

///加减block
typedef void(^ShopCartNumBlock)(UITextField *numText);
typedef void(^DeleteBlock)(ShopModel *good);

@interface ShopCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopIDLab;
@property (weak, nonatomic) IBOutlet UITextField *shopNumText;

///减 block
@property (copy, nonatomic) ShopCartNumBlock subNumBlock;

///加 block
@property (copy, nonatomic) ShopCartNumBlock addNumBlock;

@property (copy, nonatomic) DeleteBlock deleteBlock;

@property (strong, nonatomic) ShopModel *model;
@end
