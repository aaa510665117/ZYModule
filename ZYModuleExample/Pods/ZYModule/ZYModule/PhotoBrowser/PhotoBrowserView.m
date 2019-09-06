//
//  PhotoBrowserView.m
//  MobileHospital
//
//  Created by ZY on 2019/7/26.
//  Copyright © 2019 ZY. All rights reserved.
//

#import "PhotoBrowserView.h"
#import "PhotoBorwserCell.h"
#import "PhotoBorwserThumbCell.h"

//缩略图控件宽度
static float thumbPhotoCol_Width;
//返回图片
typedef void(^BackImg)(NSArray * photoImg);

@interface PhotoBrowserView ()

@property(nonatomic, strong) UICollectionView * photoCollectionView;           //大图view
@property(nonatomic, strong) UICollectionView * thumbPhotoCollectionView;      //缩略图view
@property(nonatomic, weak)   UIViewController *sender;
@property(nonatomic, strong) NSArray<PhotoBrowserModel *> *models;
@property(nonatomic, assign) NSInteger selectIndex;                            //当前选中index
@property(nonatomic, strong) UILabel * photoSelLab;

@property(nonatomic, strong) NSMutableArray * backImgAry;
@property(nonatomic, copy)BackImg backImg;

@end

@implementation PhotoBrowserView
@synthesize selectIndex = _selectIndex;

-(UICollectionView *)photoCollectionView
{
    if(!_photoCollectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(thumbPhotoCol_Width, 0, [UIScreen mainScreen].bounds.size.width-thumbPhotoCol_Width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.pagingEnabled = YES;
        [_photoCollectionView registerClass:[PhotoBorwserCell class] forCellWithReuseIdentifier:@"PhotoBorwserCell"];
    }
    return _photoCollectionView;
}

-(UICollectionView *)thumbPhotoCollectionView
{
    if(!_thumbPhotoCollectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        _thumbPhotoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, thumbPhotoCol_Width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _thumbPhotoCollectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
        _thumbPhotoCollectionView.delegate = self;
        _thumbPhotoCollectionView.dataSource = self;
        _thumbPhotoCollectionView.alwaysBounceVertical = YES;
        _thumbPhotoCollectionView.bounces = YES;
        [_thumbPhotoCollectionView registerClass:[PhotoBorwserThumbCell class] forCellWithReuseIdentifier:@"PhotoBorwserThumbCell"];
    }
    return _thumbPhotoCollectionView;
}

-(UILabel *)photoSelLab
{
    if(!_photoSelLab){
        _photoSelLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-70, 50, 30)];
        _photoSelLab.center = CGPointMake(_photoCollectionView.center.x, _photoSelLab.center.y);
        _photoSelLab.backgroundColor = [UIColor lightGrayColor];
        _photoSelLab.textColor = [UIColor blackColor];
        _photoSelLab.textAlignment = NSTextAlignmentCenter;
        _photoSelLab.layer.cornerRadius = 6.0;
        _photoSelLab.clipsToBounds = YES;
    }
    return _photoSelLab;
}

- (void)photoBrowsers:(NSArray<NSDictionary *> *)photos index:(NSInteger)index showThumbBar:(BOOL)hideThumbBar sender:(UIViewController *)sender complete:(void (^)(NSArray * _Nonnull))complete
{
    //转换为对应类型的model对象
    NSMutableArray<PhotoBrowserModel *> *models = [NSMutableArray arrayWithCapacity:photos.count];
    for (NSDictionary *dic in photos) {
        PhotoBrowserModel *model = [[PhotoBrowserModel alloc] init];
        PreviewPhotoType type = [dic[PreviewPhotoTyp] integerValue];
        id obj = dic[PreviewPhotoObj];
        switch (type) {
            case PreviewPhotoTypeUIImage:
                model.image = obj;
                break;
            case PreviewPhotoTypeURLImage:
                model.url = obj;
                break;
        }
        [models addObject:model];
    }
    _models = models;
    _sender = sender;
    self.selectIndex = index;
    if(hideThumbBar == YES){
        thumbPhotoCol_Width = 90;
    }else{
        thumbPhotoCol_Width = 0;
    }
    if(complete) _backImg = complete;
    _backImgAry = [[NSMutableArray alloc]init];
    [self previewPhotos];
//    zl_weakify(self);
//    __weak typeof(svc.navigationController) weakNav = svc.navigationController;
//    [svc setPreviewNetImageBlock:^(NSArray *photos) {
//        zl_strongify(weakSelf);
//        __strong typeof(weakNav) strongNav = weakNav;
//        if (complete) complete(photos);
//        [strongSelf hide];
//        [strongNav dismissViewControllerAnimated:YES completion:nil];
//    }];
//    svc.cancelPreviewBlock = ^{
//        zl_strongify(weakSelf);
//        [strongSelf hide];
//    };
}

-(void)previewPhotos
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if(thumbPhotoCol_Width == 90){
        [self addSubview:self.thumbPhotoCollectionView];
    }
    [self addSubview:self.photoCollectionView];
    [self addSubview:self.photoSelLab];
    [self.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionLeft) animated:NO];

    if(_sender == nil){
        //全屏加载
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:self];
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                         }
                         completion:^(BOOL finished) {
                         }
         ];
        UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 30, 30, 30)];
        [closeBtn setImage:[UIImage imageNamed:@"pb_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }else{
        //控制器弹出
        UIViewController * vc = [[UIViewController alloc]init];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        [backButton setImage:[UIImage imageNamed:@"pb_navBack"] forState:UIControlStateNormal];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTintColor:[UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0]];
        [backButton addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        vc.navigationItem.leftBarButtonItem = backItem;
        [vc.view addSubview:self];
        [_sender.navigationController pushViewController:vc animated:YES];
    }
}

-(void)tapLeftButton
{
    [_sender.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.models count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:self.photoCollectionView]){
        static NSString *cellIdentifier = @"PhotoBorwserCell";
        PhotoBorwserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        PhotoBrowserModel *model = self.models[indexPath.row];
        cell.model = model;
        cell.userInteractionEnabled = YES;
        return cell;
    }else{
        static NSString *cellIdentifiers = @"PhotoBorwserThumbCell";
        __weak typeof(self) vc = self;
        PhotoBorwserThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifiers forIndexPath:indexPath];
        PhotoBrowserModel *model = self.models[indexPath.row];
        cell.backImg = ^(UIImage * _Nonnull img) {
            __strong typeof(vc) ss = vc;
            [ss.backImgAry addObject:img];
            if(ss.backImg && (ss.backImgAry.count == self.models.count)){
                ss.backImg(ss.backImgAry);
            }
        };
        cell.model = model;
        cell.isSelect = (self.selectIndex == indexPath.row) ? YES : NO;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:self.photoCollectionView]){
        //切换大图初始化缩放比例
        self.selectIndex = indexPath.row;
        PhotoBorwserCell *pbCell = (PhotoBorwserCell *)cell;
        [pbCell.scrollView setZoomScale:pbCell.scrollView.minimumZoomScale animated:NO];
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:self.photoCollectionView]){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - thumbPhotoCol_Width, [UIScreen mainScreen].bounds.size.width);
    }
    else{
        return CGSizeMake(thumbPhotoCol_Width, 60);
    }
}

//定义UICollectionView 的边距（返回UIEdgeInsets：上、左、下、右）
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if([collectionView isEqual:self.photoCollectionView]){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else{
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

//定义UICollectionView 每行内部cell item的间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//每行的行距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if([collectionView isEqual:self.photoCollectionView]){
        return 0;
    }
    else{
        return 5;
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:self.thumbPhotoCollectionView]){
        self.selectIndex = indexPath.row;
        [self.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:(UICollectionViewScrollPositionLeft) animated:NO];
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    _photoSelLab.text = [NSString stringWithFormat:@"%ld/%ld",selectIndex+1,_models.count];
    [_thumbPhotoCollectionView reloadData];
}

-(void)clickClose
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
