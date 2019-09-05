//
//  SosSegment.m
//  SkyEmergency
//
//  Created by ZY on 15/10/28.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import "SosSegment.h"
#import "HMSegmentedControl.h"

@interface SosSegment()<UIScrollViewDelegate>

@property (nonatomic, strong)HMSegmentedControl *mySegment;
@property (nonatomic, strong)UIScrollView * myScrollView;

@end

@implementation SosSegment

@synthesize viewArray = _viewArray, selectIndex = _selectIndex, isSegScroolEnable = _isSegScroolEnable,titleArray = _titleArray;

-(id)initWithTitle:(NSArray *)title withFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if(self)
    {
        [self initTitleView:title];
    }
    return self;
}

-(id)initWithImage:(NSArray *)image selectImage:(NSArray *)selectImage withFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if(self)
    {
        [self initImageView:image withSelectImage:selectImage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)initTitleView:(NSArray *)Title
{
    __weak typeof(self) vc = self;
    self.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    _mySegment = [[HMSegmentedControl alloc] initWithSectionTitles:Title];
//    [_mySegment setFrame:CGRectMake(20, 14, self.frame.size.width-40, self.frame.size.height-28)];
    [_mySegment setFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    _mySegment.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor blackColor]};
    _mySegment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0]};
    _mySegment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _mySegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _mySegment.selectedSegmentIndex = 0;

    [_mySegment setIndexChangeBlock:^(NSInteger index) {
        __strong typeof(vc) ss = vc;
        [ss.myScrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(ss.frame) * index, 0, CGRectGetWidth(ss.frame), ss.myScrollView.frame.size.height) animated:YES];
        if(ss.changIndex) ss.changIndex(index);
    }];
    [self addSubview:_mySegment];
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mySegment.frame.size.height+2, CGRectGetWidth(self.frame), self.frame.size.height-_mySegment.frame.size.height-2)];
    _myScrollView.pagingEnabled = YES;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * Title.count, self.frame.size.height-_mySegment.frame.size.height-2);
    _myScrollView.delegate = self;
    [self addSubview:_myScrollView];
}

-(void)initImageView:(NSArray *)image withSelectImage:(NSArray *)selectImage
{
    __weak typeof(self) vc = self;
    self.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    _mySegment = [[HMSegmentedControl alloc] initWithSectionImages:image sectionSelectedImages:selectImage];
    [_mySegment setFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    _mySegment.selectionIndicatorHeight = 3.0f;
    _mySegment.selectionIndicatorColor = [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0];
    _mySegment.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _mySegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _mySegment.verticalDividerEnabled = YES;
    _mySegment.verticalDividerColor = [UIColor colorWithRed:0.788 green:0.792 blue:0.792 alpha:1.000];
    _mySegment.selectedSegmentIndex = 0;
    [_mySegment setIndexChangeBlock:^(NSInteger index) {
        __strong typeof(vc) ss = vc;
        [ss.myScrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(ss.frame) * index, 0, CGRectGetWidth(ss.frame), ss.myScrollView.frame.size.height) animated:YES];
        if(ss.changIndex) ss.changIndex(index);
    }];
    [self addSubview:_mySegment];
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mySegment.frame.size.height+2, CGRectGetWidth(self.frame), self.frame.size.height-_mySegment.frame.size.height-2)];
    _myScrollView.pagingEnabled = YES;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * image.count, self.frame.size.height-_mySegment.frame.size.height-2);
    _myScrollView.delegate = self;
    [self addSubview:_myScrollView];
}

-(void)setViewArray:(NSMutableArray *)viewArray
{
    if(!viewArray || viewArray.count == 0)
    {
        return;
    }
    __weak typeof(self) vc = self;
    _viewArray = viewArray;
    [viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(vc) ss = vc;
        UIView * view = (UIView *)obj;
        [ss.myScrollView addSubview:view];
    }];
}

-(void)setTitleArray:(NSArray *)titleArray
{
    NSInteger index = _mySegment.selectedSegmentIndex;      //保存index
    [_mySegment setSectionTitles:titleArray];               //设置title
    _mySegment.selectedSegmentIndex = index;                //刷新segment
}

-(void)setIsSegScroolEnable:(BOOL)isSegScroolEnable
{
    _isSegScroolEnable = isSegScroolEnable;
    _myScrollView.scrollEnabled = isSegScroolEnable;
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    _mySegment.selectedSegmentIndex = selectIndex;
    [_myScrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.frame) * selectIndex, 0, CGRectGetWidth(self.frame), _myScrollView.frame.size.height) animated:NO];
}

-(void)setChangIndex:(ChangeIndex)changIndex
{
    _changIndex = changIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_mySegment setSelectedSegmentIndex:page animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
