//
//  PhotoBorwserCell.h
//  MobileHospital
//
//  Created by ZY on 2019/7/26.
//  Copyright © 2019 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PhotoBorwserCell : UICollectionViewCell

@property (nonatomic, strong) PhotoBrowserModel *model;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
