//
//  PhotoBorwserCell.m
//  MobileHospital
//
//  Created by ZY on 2019/7/26.
//  Copyright © 2019 ZY. All rights reserved.
//

#import "PhotoBorwserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotoBorwserCell()<UIScrollViewDelegate>
{
    BOOL isClickDouble;
}
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation PhotoBorwserCell

-(UIView *)containerView{
    if(!_containerView){
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        // Add gesture,double tap zoom imageView.
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                                       action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [_containerView addGestureRecognizer:doubleTapGesture];
    }
    return _containerView;
}

-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
}

-(UIImageView *)showImageView{
    if(!_showImageView){
        _showImageView = [[UIImageView alloc]init];
        _showImageView.frame = self.bounds;
        [self.containerView addSubview:self.showImageView];
        self.scrollView.zoomScale = 1;
        self.scrollView.contentOffset = CGPointZero;
        self.containerView.bounds = self.showImageView.bounds;
        [self scrollViewDidZoom:_scrollView];
    }
    return _showImageView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        isClickDouble = NO;
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:self.containerView];
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

-(void)setModel:(PhotoBrowserModel *)model
{
    _model = model;
    CGImageRef cgref = [_model.image CGImage];
    CIImage *cim = [_model.image CIImage];
    if(cim != nil || cgref != NULL){
        //实体图片
        self.showImageView.image = _model.image;
    }else{
        //网络图片
        [self.showImageView sd_setImageWithURL:_model.url placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    [self resetZoomScale];
    self.scrollView.zoomScale  = self.scrollView.minimumZoomScale;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale;
    if(!isClickDouble)
    {
        newScale = self.scrollView.zoomScale * 2.5;
        isClickDouble = YES;
    }
    else
    {
        newScale = self.scrollView.zoomScale / 2.5;
        isClickDouble = NO;
    }
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma mark- Scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat Ws = self.scrollView.frame.size.width - self.scrollView.contentInset.left - self.scrollView.contentInset.right;
    CGFloat Hs = self.scrollView.frame.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom;
    CGFloat W = self.containerView.frame.size.width;
    CGFloat H = self.containerView.frame.size.height;
    
    CGRect rct = self.containerView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    self.containerView.frame = rct;
}

- (void)resetZoomScale {
    CGFloat Rw = self.scrollView.frame.size.width / self.showImageView.frame.size.width;
    CGFloat Rh = self.scrollView.frame.size.height / self.showImageView.frame.size.height;
    
    CGFloat scale = 1;
    Rw = MAX(Rw, self.showImageView.image.size.width / (scale * self.scrollView.frame.size.width));
    Rh = MAX(Rh, self.showImageView.image.size.height / (scale * self.scrollView.frame.size.height));
    
    self.scrollView.contentSize = self.showImageView.frame.size;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
}

@end
