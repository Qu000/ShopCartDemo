//
//  JHShopCartVC.m
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHShopCartVC.h"

#import "ShopCartCell.h"
#import "JHFMDB.h"
#import "ShopModel.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface JHShopCartVC ()<UITableViewDelegate,UITableViewDataSource>
/// 购物车的tableView
@property (strong, nonatomic) UITableView *shopcartTableView;
/// 购物车数据源数组
@property (strong, nonatomic) NSMutableArray *shopcartGoodsArray;
@end

static NSString *cellID = @"ShopCartCell";
@implementation JHShopCartVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.shopcartGoodsArray = [NSMutableArray array];
    NSString *searchAllSQL = [NSString stringWithFormat:@"select * from goods"];
    [JHFMDB querySQLWithPath:@"goods.sqlite"];
    
    [JHFMDB searchAllDataWithSQL:searchAllSQL andResultBlock:^(BOOL success, NSMutableArray *goodList) {
        if (success) {
            
            self.shopcartGoodsArray = goodList;
        }
    }];
    
    if (self.shopcartGoodsArray.count>0) {
        [self setupUI];
    }else{
        [self setupNoShoopsView];
    }
    
    [self.shopcartTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor colorWithRed:242/250.0 green:243/250.0 blue:240/250.0 alpha:1];
    
    self.shopcartTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
   self.shopcartTableView.backgroundColor = [UIColor colorWithRed:242/250.0 green:243/250.0 blue:240/250.0 alpha:1];
    self.shopcartTableView.delegate = self;
    self.shopcartTableView.dataSource = self;
    [self.view addSubview:self.shopcartTableView];
    [self.shopcartTableView registerNib:[UINib nibWithNibName:@"ShopCartCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.shopcartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupNoShoopsView{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 100, 100, 30)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"去首页添加" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(goHomeViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)goHomeViewAction:(UIButton *)button
{
    self.tabBarController.selectedIndex = 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.shopcartGoodsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // cell中 减号点击的回调
    cell.subNumBlock = ^(UITextField *numText) {
        int num = numText.text.intValue;
        ShopModel *model = self.shopcartGoodsArray[indexPath.section];
        if (num >= 1) {
            num--;
            numText.text = [NSString stringWithFormat:@"%d",num];
            
            [self subOneShopWithModel:model];
        }
        model.goodsNum = num;
        
        [self.shopcartGoodsArray replaceObjectAtIndex:indexPath.section withObject:model];
        
        [self.shopcartTableView reloadData];
        
        if (num == 0) {//删除
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                // 通过FMDB删除本地数据库对应的商品
                [JHFMDB querySQLWithPath:@"goods.sqlite"];
                
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM goods WHERE goodsId = '%@'", model.goodsId];
                [JHFMDB deleteSQLWithName:sql andResultBlock:^(BOOL result) {
                    if (result) {
                        
                        NSLog(@"删除成功！");
                    }
                }];
                
                
                // 需要先判断要删除的model，结算数组里是否包含
                // 1、如果包含，结算数组也需要删除对应的model，否则会影响全选按钮的选中状态
                // 2、如果不包含，在删除数据源数组对应的model之后，需要判断结算数组和数据源数组的个数，否则同样会影响全选按钮的选中状态（eg：如果购物车中有三个model数据，选中两个model，如果删除一个未选中的model，此时全选按钮选中状态应该置为YES）
                /*if ([self.resultArray containsObject:self.shopcartGoodsArray[indexPath.section]]) {
                 
                 [self.resultArray removeObject:self.shopcartGoodsArray[indexPath.section]];
                 }*/
                
                // 删除数据源
                [self.shopcartGoodsArray removeObjectAtIndex:indexPath.section];
                
                // 删除UI
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
                
                
                if (self.shopcartGoodsArray.count == 0) {
                    
                    [self setupNoShoopsView];
                }
                
                // 判断数据源数组的个数和结算数组的个数是否相等
                /*if (self.resultArray.count == self.shopcartGoodsArray.count) {
                 
                 self.sumView.selectAllButton.selected = YES;
                 }*/
                
                
                [self.shopcartTableView reloadData];
                
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    };
    
    // cell中 加号点击的回调
    cell.addNumBlock = ^(UITextField *numText) {
        int num = numText.text.intValue;
        num++;
        numText.text = [NSString stringWithFormat:@"%d",num];
        
        ShopModel *model = self.shopcartGoodsArray[indexPath.section];
        model.goodsNum = num;
        
        [self addOneShopWithModel:model];
        [self.shopcartGoodsArray replaceObjectAtIndex:indexPath.section withObject:model];
        
        [self.shopcartTableView reloadData];
    };
    
    // cell中删除按钮的回调
    cell.deleteBlock = ^(ShopModel *model){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 通过FMDB删除本地数据库对应的商品
            [JHFMDB querySQLWithPath:@"goods.sqlite"];
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM goods WHERE goodsId = '%@'", model.goodsId];
            [JHFMDB deleteSQLWithName:sql andResultBlock:^(BOOL result) {
                if (result) {
                    
                    NSLog(@"删除成功！");
                }
            }];
            
            
            // 需要先判断要删除的model，结算数组里是否包含
            // 1、如果包含，结算数组也需要删除对应的model，否则会影响全选按钮的选中状态
            // 2、如果不包含，在删除数据源数组对应的model之后，需要判断结算数组和数据源数组的个数，否则同样会影响全选按钮的选中状态（eg：如果购物车中有三个model数据，选中两个model，如果删除一个未选中的model，此时全选按钮选中状态应该置为YES）
            /*if ([self.resultArray containsObject:self.shopcartGoodsArray[indexPath.section]]) {
                
                [self.resultArray removeObject:self.shopcartGoodsArray[indexPath.section]];
            }*/
            
            // 删除数据源
            [self.shopcartGoodsArray removeObjectAtIndex:indexPath.section];
            
            // 删除UI
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
            
            
            if (self.shopcartGoodsArray.count == 0) {
                
                [self setupNoShoopsView];
            }
            
            // 判断数据源数组的个数和结算数组的个数是否相等
            /*if (self.resultArray.count == self.shopcartGoodsArray.count) {
                
                self.sumView.selectAllButton.selected = YES;
            }*/
            
            
            [self.shopcartTableView reloadData];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    };
    
    cell.model = self.shopcartGoodsArray[indexPath.section];
    
    return cell;
}

#pragma mark -- 数据库中相应商品数量减1
- (void)subOneShopWithModel:(ShopModel *)model{
    [JHFMDB querySQLWithPath:@"goods.sqlite"];
    
    NSString *searchOneSQL = [NSString stringWithFormat:@"select * from goods where goodsId = '%@'", model.goodsId];
    
    [JHFMDB searchOneDataWithSQL:searchOneSQL andResultBlock:^(BOOL result, NSDictionary *dict) {
        if (result) {
            
            int num = [[dict objectForKey:@"goodsNum"] intValue];
            num = num - 1;
            
            [JHFMDB updateSQLWithName:[NSString stringWithFormat:@"update goods set goodsNum = '%d' where goodsId = '%@'", num, model.goodsId] andResultBlocck:^(BOOL result) {
                if (result) {
                    
                    NSLog(@"数据库里对应数据减1了");
                }
            }];
        }
    }];
    
}
#pragma mark -- 数据库中相应商品数量加1
- (void)addOneShopWithModel:(ShopModel *)model{
    [JHFMDB querySQLWithPath:@"goods.sqlite"];
    
    NSString *searchOneSQL = [NSString stringWithFormat:@"select * from goods where goodsId = '%@'", model.goodsId];
    
    [JHFMDB searchOneDataWithSQL:searchOneSQL andResultBlock:^(BOOL result, NSDictionary *dict) {
        
        if (result)
        {
            int num = [[dict objectForKey:@"goodsNum"] intValue];
            num = num + 1;
            
            [JHFMDB updateSQLWithName:[NSString stringWithFormat:@"update goods set goodsNum = '%d' where goodsId = '%@'", num, model.goodsId] andResultBlocck:^(BOOL result) {
                
                if (result)
                {
                    NSLog(@"数据库里对应数据加1");
                }
                
            }];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}












@end
