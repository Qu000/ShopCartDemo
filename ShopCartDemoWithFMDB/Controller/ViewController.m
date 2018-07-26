//
//  ViewController.m
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "ViewController.h"

#import "ShopModel.h"
#import "ShopCell.h"
#import "JHFMDB.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 装载数据*/
@property (nonatomic, strong) NSMutableArray * shopDataList;

/** 表*/
@property (nonatomic, strong) UICollectionView * collectionView;
@end

static NSString *cellID = @"ShopCell";
@implementation ViewController

- (NSMutableArray *)shopDataList {
    
    if (!_shopDataList) {
        _shopDataList = [NSMutableArray array];
    }
    return _shopDataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self getShopData];
}

#pragma mark -- 设置UI
- (void)setupUI{
     self.title = @"添加至购物车";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, 170);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:242/250.0 green:243/250.0 blue:240/250.0 alpha:1];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    
    [self.view addSubview:self.collectionView];
}
#pragma mark -- 模拟网络请求，获取数据
- (void)getShopData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shopDataList" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    //转模型
    for (NSDictionary *dict in arr) {
        ShopModel *shop = [[ShopModel alloc]init];
        shop.goodsId = dict[@"goodsId"];
        shop.goodsName = dict[@"goodsName"];
        shop.goodsPrice = dict[@"goodsPrice"];
        
        [self.shopDataList addObject:shop];
    }
    [self.collectionView reloadData];
}

#pragma mark -- delegate&datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shopDataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.addBlock = ^(ShopModel *model) {
        [JHFMDB querySQLWithPath:@"goods.sqlite"];
        
        [JHFMDB createTableWithSQLName:@"create table if not exists goods ('goodsId' text not null, 'goodsName' text not null, 'goodsPrice' text, 'goodsNum' integer not null)" andResultBlock:^(NSString *result) {
            
            NSLog(@"此处创建表:%@",result);
            
            //先进行查询，如已存在，则+1
            NSString *searchSQL = [NSString stringWithFormat:@"select * from goods where goodsId = '%@'",model.goodsId];
            [JHFMDB searchOneDataWithSQL:searchSQL andResultBlock:^(BOOL result, NSDictionary *dict) {
                if (result) {
                    
                    //查询到商品在数据库中
                    int num = 0;
                    NSString *number = [dict objectForKey:@"goodsNum"];
                    num = [number intValue] + 1;
                    number = [NSString stringWithFormat:@"%d",num];
                    
                    NSString *updateSQL = [NSString stringWithFormat:@"update goods set goodsNum = '%d' where goodsId = '%@'",num,model.goodsId];
                    
                    [JHFMDB updateSQLWithName:updateSQL andResultBlocck:^(BOOL result) {
                        if (result) {
                            NSLog(@"此处添加购物车成功+1");
                        }
                    }];
                }else{
                   //如没有查询到，则为第一次添加，则增加一条商品信息
                    model.goodsNum = 1;
                    
                    NSString *insertSQL = [NSString stringWithFormat:@"insert into goods values ('%@','%@','%@','%d')",model.goodsId, model.goodsName, model.goodsPrice, model.goodsNum];
                    [JHFMDB insertSQLWithName:insertSQL andResultBlocck:^(BOOL result) {
                        if (result) {
                            NSLog(@"商品第一次添加到购物车成功");
                        }
                    }];
                }
            }];
        }];
    };
    
    cell.model = self.shopDataList[indexPath.item];
    return cell;
}











@end
