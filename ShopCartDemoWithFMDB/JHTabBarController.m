//
//  JHTabBarController.m
//  ShopCartDemoWithFMDB
//
//  Created by qujiahong on 2018/7/25.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHTabBarController.h"

#import "ViewController.h"
#import "JHShopCartVC.h"
@interface JHTabBarController ()

@end

@implementation JHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建子视图控制器
    [self creatChildViewControllers];
    
    //设置tabbarItemTextAttributes中的颜色
    [self setTabBarItemTextAttributes];
}

- (void)creatChildViewControllers
{
    // 首页
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:[ViewController new]] title:@"首页" normalImage:@"homeBarSelect" selectedImage:@"homeBarSelect"];
    // 购物车
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:[JHShopCartVC new]] title:@"购物车" normalImage:@"shopcatrBarSelect" selectedImage:@"shopcatrBarSelect"];
}
- (void)addOneChildViewController:(UIViewController *)viewController title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage
{
    // tab标题
    viewController.tabBarItem.title = title;
    
    // tab未选中图片
    viewController.tabBarItem.image = [UIImage imageNamed:normalImage];
    
    // tab选中图片
    UIImage *image = [UIImage imageNamed:selectedImage];
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    viewController.tabBarItem.selectedImage = image;
    
    // 添加子控制器
    [self addChildViewController:viewController];
}


- (void)setTabBarItemTextAttributes
{
    //设置普通状态下文本的颜色
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1];
    
    //设置选中状态下的文本颜色
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:255/255.0 green:152/255.0 blue:124/255.0 alpha:1];
    
    //配置文本属性（将上述设置的颜色添加上去）
    UITabBarItem *tabbarItem = [UITabBarItem appearance];
    [tabbarItem setTitleTextAttributes:normalAttrs forState:(UIControlStateNormal)];
    [tabbarItem setTitleTextAttributes:selectedAttrs forState:(UIControlStateSelected)];
}

@end
