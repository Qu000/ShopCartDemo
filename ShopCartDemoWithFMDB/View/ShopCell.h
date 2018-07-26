//
//  ShopCell.h
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

typedef void(^SubBlock)(ShopModel *model);
typedef void(^AddBlock)(ShopModel *model);
@interface ShopCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopIDLab;
@property (weak, nonatomic) IBOutlet UIButton *subShopBtn;
@property (weak, nonatomic) IBOutlet UIButton *addShopBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberText;

/** model*/
@property (nonatomic, strong) ShopModel * model;

/** subBlock*/
@property (nonatomic, copy) SubBlock subBlock;
/** addBlock*/
@property (nonatomic, copy) AddBlock addBlock;
@end
