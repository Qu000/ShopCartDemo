//
//  ShopCartCell.m
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "ShopCartCell.h"

@implementation ShopCartCell

- (void)setModel:(ShopModel *)model{
    _model = model;
    
    self.shopIDLab.text = [NSString stringWithFormat:@"商品名称：%@||商品ID：%@||单价：%@",model.goodsName,model.goodsId,model.goodsPrice];
    self.shopNumText.text = [NSString stringWithFormat:@"%d",model.goodsNum];
    
    
}
- (IBAction)clickAddBtn:(id)sender {
    if (self.addNumBlock) {
        self.addNumBlock(self.shopNumText);
    }
}
- (IBAction)clickSubBtn:(id)sender {
    if (self.subNumBlock) {
        self.subNumBlock(self.shopNumText);
    }
}
- (IBAction)clickDeleteBtn:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.model);
    }
}


@end
