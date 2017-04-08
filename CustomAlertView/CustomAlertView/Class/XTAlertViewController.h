//
//  XTAlertViewController.h
//  CustomAlertView
//
//  Created by Tong on 2017/4/8.
//  Copyright © 2017年 Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XTAlertViewWillShowBlock)();

typedef void (^XTAlertViewDidHideBlock)();

typedef void (^XTAlertViewFirstActionBlock)();

typedef void (^XTAlertViewSecondActionBlock)();

@class XTAlertViewModel;

@interface XTAlertViewController : UIViewController

/** 点击第一个按钮回调 */
@property (nonatomic, copy) XTAlertViewFirstActionBlock firstActionBlock;

/** 点击第二个按钮回调 */
@property (nonatomic, copy) XTAlertViewSecondActionBlock secondActionBlock;



/**
 显示提示框

 @param alerViewModel 提示框的自定义数据
 @param parentViewController 父视图
 @param willShowBlock 将要显示回调块
 @param didHidBlock 已经显示回调块
 @return 提示框
 */
+ (XTAlertViewController *)showAlertViewWithModel:(XTAlertViewModel *)alerViewModel parentViewController:(UIViewController *)parentViewController willShowBlock:(XTAlertViewWillShowBlock)willShowBlock didHideBlock:(XTAlertViewDidHideBlock)didHidBlock;


@end


@interface XTAlertViewModel : NSObject


/**
 标题 (必填)
 */
@property (nonatomic, copy) NSString *title;


/**
 内容 (必填)
 */
@property (nonatomic, copy) NSString *message;


/**
 标题颜色 (默认:36,38,40,1)
 */
@property (nonatomic, strong) UIColor *titleColor;


/**
 内容颜色 (默认:70,74,80,1)
 */
@property (nonatomic, strong) UIColor *messageColor;


/**
 分割线颜色 (默认:0,0,0,0.25)
 */
@property (nonatomic, strong) UIColor *separatorLineColor;


/**
 标题字体 (默认:苹方黑体17)
 */
@property (nonatomic, strong) UIFont *titleFont;


/**
 内容字体 (默认:苹方常规体13)
 */
@property (nonatomic, strong) UIFont *messageFont;


/**
 按钮字体 (默认:苹方常规体17)
 */
@property (nonatomic, strong) UIFont *actionFont;


/**
 按钮文本（最多两个）默认:[@"取消",@"确定"]
 */
@property (nonatomic, strong) NSArray<NSString *> *actions;


/**
 按钮颜色 和actions个数相对应对应 默认:@[(36,38,40),(3,122,255)]
 */
@property (nonatomic, strong) NSArray<UIColor *> *actionColors;


/**
 视图大小 默认:CGSizeMake(270, 166)
 */
@property (nonatomic, assign) CGSize size;


/**
 圆角 默认:12.0
 */
@property (nonatomic, assign) CGFloat radius;


/**
 标题和内容的间距 默认:10.0
 */
@property (nonatomic, assign) CGFloat titleSpacingToMessage;


/**
 标题行数  默认:1
 */
@property (nonatomic, assign) NSInteger titleNumberOfLines;


/**
 内容行数  默认:2
 */
@property (nonatomic, assign) NSInteger messageNumerOfLines;





@end
