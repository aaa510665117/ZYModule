//
//  PhotoBrowserView.h
//  MobileHospital
//
//  Created by ZY on 2019/7/26.
//  Copyright © 2019 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserModel.h"

@interface PhotoBrowserView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<PhotoBrowserModel *> *arrDataSources;

/*
 初始化方法
 @param photos 内对象请调用 PhotoBrowserModel 中 GetDictForPhotoPreview 方法，例: GetDictForPhotoPreview(obj, PreviewPhotoTypeUIImage);
 
 @param photos 接收对象 PhotoBrowserModel 中 GetDictForPhotoPreview 生成的字典
 @param index 默认选中的照片索引
 @param showThumbBar 是否隐藏左边缩略图栏目
 @param complete 回调 (数组内为接收的 UIImage / NSURL 对象)
 @param sender 传入控制器push加载  传nil为window加载
 */
- (void)photoBrowsers:(NSArray<NSDictionary *> *)photos index:(NSInteger)index showThumbBar:(BOOL)showThumbBar sender:(UIViewController *)sender complete:(void (^)(NSArray *photos))complete;

@end
