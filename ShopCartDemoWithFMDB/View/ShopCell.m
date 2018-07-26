//
//  ShopCell.m
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "ShopCell.h"
@interface ShopCell()

/** number*/
@property (nonatomic, assign) NSInteger number;

@end
@implementation ShopCell

- (void)setModel:(ShopModel *)model{
    
    _model = model;
    
    self.shopIDLab.text = [NSString stringWithFormat:@"商品名称：%@||商品ID：%@||单价：%@",model.goodsName,model.goodsId,model.goodsPrice];
    
}
- (IBAction)clickSubBtn:(id)sender {
    
    if ([self.numberText.text isEqualToString:@"0"]) {
        return;
    }
    NSInteger temp = [self.numberText.text integerValue];
    self.number = temp - 1;
    self.numberText.text = [NSString stringWithFormat:@"%ld",self.number];
    if (self.subBlock) {
        self.subBlock(self.model);
    }
}
- (IBAction)clickAddBtn:(id)sender {
    NSInteger temp = [self.numberText.text integerValue];
    self.number = temp + 1;
    self.numberText.text = [NSString stringWithFormat:@"%ld",self.number];
    
    if (self.addBlock) {
        self.addBlock(self.model);
    }
}


@end
