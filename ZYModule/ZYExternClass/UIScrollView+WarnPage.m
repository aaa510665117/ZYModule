//
//  UIScrollView+WarnPage.m
//  MobileHospital
//
//  Created by 扬张 on 2018/7/28.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "UIScrollView+WarnPage.h"
#import <objc/runtime.h>

#define IMAGE_WIDTH [UIScreen mainScreen].bounds.size.width / 2.3

static char tapkey;

@implementation UIScrollView(WarnPage)

- (void)loadErrorBackViewTitle:(NSString *)title reload:(void (^)(void))reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self loadBackView:[UIImage imageNamed:@"errorBackImage"] withTitle:(title.length) ? title : @"无法连接网络,请检查网络连接" withDescribe:@"点击重新加载" operation:reloadData];
    });
    
}

- (void)loadNoDataBackViewTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self loadBackView:[UIImage imageNamed:@"noDataBackImage"] withTitle:(title.length) ? title : @"暂无数据" withDescribe:@"" operation:nil];
    });
}

- (void)loadBackView:(UIImage *)image withTitle:(NSString *)title withDescribe:(NSString *)describe operation:(void (^)(void))operation
{
    UIView *hasView = [self viewWithTag:99999];
    if (hasView) {
        [hasView removeFromSuperview];
    }
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    NSLog(@"w=%f,h=%f",self.frame.size.width,self.frame.size.height);
    
    view.userInteractionEnabled = YES;
    view.tag = 99999;
    view.backgroundColor = self.backgroundColor;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (operation) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadData:)];
        [view addGestureRecognizer:tapGestureRecognizer];
        objc_setAssociatedObject(self, &tapkey, operation, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    [self addSubview:view];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [view addSubview:imageView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:IMAGE_WIDTH]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:IMAGE_WIDTH]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-64]];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor colorWithWhite:0.425 alpha:1.000];
    label.text = title;
    
    [view addSubview:label];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:15]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
    
    UILabel *remind = [[UILabel alloc] init];
    remind.numberOfLines = 0;
    remind.lineBreakMode = 0;
    remind.textAlignment = NSTextAlignmentCenter;
    remind.translatesAutoresizingMaskIntoConstraints = NO;
    remind.font = [UIFont systemFontOfSize:16];
    remind.textColor = [UIColor colorWithWhite:0.756 alpha:1.000];
    remind.text = describe;
    
    [view addSubview:remind];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:remind attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:remind attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:remind attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeBottom multiplier:1 constant:15]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:remind attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
}

- (void)reloadData:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *view = (UIView *)tapGestureRecognizer.view;
    
    [view removeFromSuperview];
    
    void (^reloadData)(void) = (void (^)(void))objc_getAssociatedObject(self, &tapkey);
    (reloadData) ? reloadData() : nil;
}

- (void)removeBackView
{
    UIView *view = [self viewWithTag:99999];
    
    [UIView animateWithDuration:0.25 animations:^ {
        view.alpha = 0;
    } completion:^ (BOOL finished) {
        [view removeFromSuperview];
    }];
    
}

@end
