//
//  PhotoBrowserModel.h
//  MobileHospital
//
//  Created by ZY on 2019/7/26.
//  Copyright © 2019 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PreviewPhotoObj @"PreviewPhotoObj"
#define PreviewPhotoTyp @"PreviewPhotoTyp"

NS_ASSUME_NONNULL_BEGIN

//混合预览图片时，图片类型
typedef NS_ENUM(NSUInteger, PreviewPhotoType) {
    PreviewPhotoTypeUIImage,
    PreviewPhotoTypeURLImage,
};

static inline NSDictionary * GetDictForPhotoPreview(id obj, PreviewPhotoType type) {
    if (nil == obj) {
        @throw [NSException exceptionWithName:@"error" reason:@"预览对象不能为空" userInfo:nil];
    }
    return @{PreviewPhotoObj: obj, PreviewPhotoTyp: @(type)};
}

@interface PhotoBrowserModel : NSObject

//网络/本地 图片url
@property (nonatomic, strong) NSURL *url ;
//图片
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
