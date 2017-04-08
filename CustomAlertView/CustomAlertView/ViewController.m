//
//  ViewController.m
//  CustomAlertView
//
//  Created by Tong on 2017/4/8.
//  Copyright © 2017年 Tong. All rights reserved.
//

#import "ViewController.h"

#import "XTAlertViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"弹出提示框" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

- (void)clickAction
{
    // 初始化提示信息
    XTAlertViewModel *alertModel = [XTAlertViewModel new];
    alertModel.title = @"提示";
    alertModel.message = @"提示内容";
    alertModel.actions = @[@"取消",@"确定"];
    
    
    XTAlertViewController *alertVC =  [XTAlertViewController showAlertViewWithModel:alertModel parentViewController:self willShowBlock:nil didHideBlock:nil];
    
    // 点击第一个按钮
    alertVC.firstActionBlock = ^(){
        NSLog(@"点击第一个按钮");
    };
    
    // 点击第二个按钮
    alertVC.secondActionBlock = ^(){
        NSLog(@"点击第二个按钮");

    };

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
