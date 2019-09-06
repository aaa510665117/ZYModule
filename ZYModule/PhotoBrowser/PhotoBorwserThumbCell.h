//
//  PhotoBorwserThumbCell.h
//  MobileHospital
//
//  Created by ZY on 2019/7/26.
//  Copyright © 2019 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BackImgBlock)(UIImage * img);

@interface PhotoBorwserThumbCell : UICollectionViewCell

@property (nonatomic, strong) PhotoBrowserModel *model;
@property (nonatomic, strong) UIImageView * thimageView;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) BackImgBlock backImg;

@end

NS_ASSUME_NONNULL_END
