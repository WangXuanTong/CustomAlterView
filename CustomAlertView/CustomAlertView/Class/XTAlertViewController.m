//
//  XTAlertViewController.m
//  CustomAlertView
//
//  Created by Tong on 2017/4/8.
//  Copyright © 2017年 Tong. All rights reserved.
//

#import "XTAlertViewController.h"

#import "UIView+Frame.h"

// 是否高清屏
#define isDeviceRetina (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO : [UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.width > 320 : NO)

@interface XTAlertViewController ()

@property (nonatomic, copy) XTAlertViewDidHideBlock didHideBlock;

@property (nonatomic, strong) XTAlertViewModel *alertViewModel;

@property (nonatomic, strong) UIView *baseView; // 基层视图

@property (nonatomic, strong) UILabel *titleLabel; // 标题

@property (nonatomic, strong) UILabel *messageLabel; // 内容

@property (nonatomic, strong) UIView *lineView; // 分割线

@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, assign) CGFloat separatorHeight;

@end

@implementation XTAlertViewController

- (void)dealloc
{
    NSLog(@"dealloc ----> WFAlertViewController");
}


#pragma mark - --------------------------- life cycle ---------------------------

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0 blue:0 alpha:0.3];
    
    self.viewWidth = 100;
    self.viewHeight = 100;
    
    _separatorHeight = isDeviceRetina ? 0.5 : 1.0;
    
    [self createAlertView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.baseView.center = self.view.center;
}

#pragma mark - --------------------------- button events ---------------------------

- (void)clickAction:(UIButton *)button
{
    if (button.tag == 1000) {
        if (self.firstActionBlock) {
            self.firstActionBlock();
        }
    } else if (button.tag == 1001) {
        if (self.secondActionBlock) {
            self.secondActionBlock();
        }
    }
    
    [self closeAlertView];
}


#pragma mark - --------------------------- setter and getter ---------------------------

- (void)setAlertViewModel:(XTAlertViewModel *)alertViewModel
{
    _alertViewModel = alertViewModel;
    
    self.viewWidth = alertViewModel.size.width;
    self.viewHeight = alertViewModel.size.height;
    
    // 基层
    self.baseView.size = alertViewModel.size;
    self.baseView.layer.cornerRadius = alertViewModel.radius;
    
    // 标题
    [self setTitleInfoWithModel:alertViewModel];
    
    // 消息
    [self setMessageInfoWithModel:alertViewModel];
    
    if (alertViewModel.titleNumberOfLines == 0 || alertViewModel.messageNumerOfLines == 0) {
        CGFloat height = self.messageLabel.origin.y + self.messageLabel.frame.size.height + 44 + 32;
        
        if (self.viewHeight < height) {
            self.viewHeight = height;
        }
        
        self.baseView.size = CGSizeMake(self.viewWidth, self.viewHeight);
    }
    
    // 分割线
    self.lineView.backgroundColor = alertViewModel.separatorLineColor;
    
    // 按钮
    if (alertViewModel.actions.count != alertViewModel.actionColors.count) {
        return;
    }
    
    [self setActionsInfoWithModel:alertViewModel];
}

// 基层
- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.center = self.view.center;
        [self.view addSubview:_baseView];
    }
    return _baseView;
}

// 标题
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.viewWidth - 40, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.baseView addSubview:_titleLabel];
    }
    return _titleLabel;
}

// 内容
- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, self.viewWidth - 40, 40)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self.baseView addSubview:_messageLabel];
    }
    return _messageLabel;
}

// 分割线
- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 44, self.viewWidth, self.separatorHeight)];
        [self.baseView addSubview:_lineView];
    }
    return _lineView;
}

#pragma mark - --------------------------- private methods ---------------------------

- (void)createAlertView
{
    [self baseView];
}

/**
 关闭提示视图
 */
- (void)closeAlertView
{
    if (self.didHideBlock) {
        self.didHideBlock();
    }
    
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
}


/**
 设置标题信息
 */
- (void)setTitleInfoWithModel:(XTAlertViewModel *)alertViewModel
{
    self.titleLabel.text = alertViewModel.title;
    self.titleLabel.textColor = alertViewModel.titleColor;
    self.titleLabel.font = alertViewModel.titleFont;
    self.titleLabel.numberOfLines = alertViewModel.titleNumberOfLines;
    
    if (alertViewModel.titleNumberOfLines == 0) {
        CGRect rect = [alertViewModel.title boundingRectWithSize:CGSizeMake(self.viewWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: alertViewModel.titleFont} context:nil];
        self.titleLabel.frame = CGRectMake(20, 10, self.viewWidth - 40, rect.size.height + 4);
    }
}

/**
 设置内容信息
 */
- (void)setMessageInfoWithModel:(XTAlertViewModel *)alertViewModel
{
    self.messageLabel.text = alertViewModel.message;
    self.messageLabel.textColor = alertViewModel.messageColor;
    self.messageLabel.font = alertViewModel.messageFont;
    self.messageLabel.numberOfLines = alertViewModel.messageNumerOfLines;
    
    if (alertViewModel.messageNumerOfLines == 0) {
        CGRect rect = [alertViewModel.message boundingRectWithSize:CGSizeMake(self.viewWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: alertViewModel.messageFont} context:nil];
        
        CGFloat top = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + alertViewModel.titleSpacingToMessage + 4;
        self.messageLabel.frame = CGRectMake(20, top, self.viewWidth - 40, rect.size.height + 4);
    }
}

/**
 设置按钮信息
 */
- (void)setActionsInfoWithModel:(XTAlertViewModel *)alertViewModel
{
    NSInteger actionCount = alertViewModel.actions.count;
    
    for (NSInteger i = 0; i < actionCount; i++) {
        
        NSString *actionTitle = [alertViewModel.actions objectAtIndex:i];
        UIColor *actionTitleColor = [alertViewModel.actionColors objectAtIndex:i];
        CGFloat actionWidth = self.viewWidth / actionCount;
        
        UIButton *action = [UIButton buttonWithType:UIButtonTypeCustom];
        action.frame = CGRectMake(i * actionWidth, self.viewHeight - 44, actionWidth, 44);
        action.backgroundColor = [UIColor clearColor];
        [action setTitle:actionTitle forState:UIControlStateNormal];
        [action setTitleColor:actionTitleColor forState:UIControlStateNormal];
        action.titleLabel.font = alertViewModel.actionFont;
        action.tag = 1000 + i;
        [action addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:action];
        
        
        if (i != actionCount - 1 && actionCount!= 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i+1) *actionWidth, self.viewHeight - 44, self.separatorHeight, 44)];
            line.backgroundColor = alertViewModel.separatorLineColor;
            [self.baseView addSubview:line];
        }
    }
    
}



#pragma mark - --------------------------- public methods ---------------------------

/**
 显示提示框
 
 @param alerViewModel 提示框的自定义数据
 @param parentViewController 父视图
 @param willShowBlock 将要显示回调块
 @param didHidBlock 已经显示回调块
 @return 提示框
 */
+ (XTAlertViewController *)showAlertViewWithModel:(XTAlertViewModel *)alerViewModel parentViewController:(UIViewController *)parentViewController willShowBlock:(XTAlertViewWillShowBlock)willShowBlock didHideBlock:(XTAlertViewDidHideBlock)didHidBlock
{
    XTAlertViewController *controller = [[XTAlertViewController alloc] init];
    
    controller.view.frame = parentViewController.view.frame;
    
    NSLog(@"%@",NSStringFromCGRect(controller.view.frame));
    
    [parentViewController addChildViewController:controller];
    [controller didMoveToParentViewController:parentViewController];
    
    [parentViewController.view addSubview:controller.view];
    [parentViewController.view bringSubviewToFront:controller.view];
    
    controller.alertViewModel = alerViewModel;
    controller.didHideBlock = didHidBlock;

    return controller;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



@implementation XTAlertViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _titleColor = [UIColor colorWithRed:36 / 255.0 green:38 / 255.0 blue:40 / 255.0 alpha:1.0];
        _messageColor = [UIColor colorWithRed:70 / 255.0 green:74 / 255.0 blue:80 / 255.0 alpha:1.0];
        _separatorLineColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
        
        _titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _messageFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _actionFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        
        _size = CGSizeMake(270, 166);
        
        _radius = 12.0;
        _titleSpacingToMessage = 10.0;
        
        _titleNumberOfLines = 1;
        _messageNumerOfLines = 2;

    }
    return self;
}

// 按钮文本（最多两个）
- (NSArray<NSString *> *)actions
{
    if (_actions == nil) {
        _actions = @[@"取消",@"确定"];
    }
    return _actions;
}

// 按钮颜色，和actions个数相对应对应
- (NSArray<UIColor *> *)actionColors
{
    if (_actionColors == nil) {
        _actionColors = @[[UIColor colorWithRed:36 / 255.0 green:38 / 255.0 blue:40 / 255.0 alpha:1.0],[UIColor colorWithRed:3 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0]];
    }
    return _actionColors;
}

@end


















