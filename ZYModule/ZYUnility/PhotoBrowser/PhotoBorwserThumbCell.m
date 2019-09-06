//
//  PhotoBorwserThumbCell.m
//  MobileHospital
//
//  Created by ZY on 2019/7/26.
//  Copyright © 2019 ZY. All rights reserved.
//

#import "PhotoBorwserThumbCell.h"

@implementation PhotoBorwserThumbCell

-(UIImageView *)thimageView
{
    if(!_thimageView){
        _thimageView = [[UIImageView alloc]init];
//        _thimageView.frame = self.bounds;
        _thimageView.clipsToBounds = YES;
        _thimageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _thimageView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
        [self.contentView addSubview:self.thimageView];
        NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.thimageView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.f
                                                                 constant:0.f];
        NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:self.thimageView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.f
                                                                constant:0.f];
        NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:self.thimageView
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1.f
                                                                 constant:5.f];
        NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:self.thimageView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.f
                                                                  constant:-5.f];
        [self.contentView addConstraints:@[top, bottom, left, right]];
    }
    return self;
}

-(void)setModel:(PhotoBrowserModel *)model
{
    _model = model;
    __weak typeof(self) vc = self;
    CGImageRef cgref = [_model.image CGImage];
    CIImage *cim = [_model.image CIImage];
    if(cim != nil || cgref != NULL){
        self.thimageView.image = _model.image;
        if(vc.backImg){
            vc.backImg(_model.image);
        }
    }else{
        [self.thimageView sd_setImageWithPreviousCachedImageWithURL:_model.url placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(vc.backImg){
                vc.backImg(image);
            }
        }];
    }
}

-(void)setIsSelect:(BOOL)isSelect
{
    if(isSelect == YES){
        _thimageView.layer.borderWidth = 3.0f;
        _thimageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }else{
        _thimageView.layer.borderWidth = 0.0f;
    }
}

@end
