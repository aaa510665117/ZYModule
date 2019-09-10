//
//  EqualSpaceFlowLayout.h
//  MobileHospital
//
//  Created by ZY on 2018/7/5.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  EqualSpaceFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>
@end

@interface EqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray * itemAttributes;
@property (nonatomic,weak) id<EqualSpaceFlowLayoutDelegate> delegate;

@end
