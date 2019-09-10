//
//  JHGridView.h
//  JHGridView
//
//  Created by 307A on 16/9/25.
//  Copyright © 2016年 徐嘉宏. All rights reserved.
//

#import <UIKit/UIKit.h>
/* GridIndex. */
struct GridIndex {
    long section;
    long row;
    long col;
};
typedef struct GridIndex GridIndex;

typedef enum{
    JHGridSelectTypeDefault,
    JHGridSelectTypeSingle,
    JHGridSelectTypeNone
}JHGridSelectType;

typedef enum{
    JHGridAlignmentTypeDefault,
    JHGridAlignmentTypeCenter,
    JHGridAlignmentTypeLeft,
    JHGridAlignmentTypeRight
}JHGridAlignmentType;

@protocol GridViewDelegate<NSObject>

@optional
- (CGFloat)heightForRowAtIndex:(long)index;
@optional
- (CGFloat)widthForColAtIndex:(long)index;
@optional
- (CGFloat)heightForTitles;
@optional
- (BOOL)isRowSelectable;
@optional
- (void)didSelectRowAtGridIndex:(GridIndex)gridIndex;
@optional
- (JHGridSelectType)gridViewSelectType;
@optional
- (JHGridAlignmentType)gridViewAlignmentType;
@optional
- (UIColor *)backgroundColorForTitleAtIndex:(long)index;
@optional
- (UIColor *)backgroundColorForGridAtGridIndex:(GridIndex)gridIndex;
@optional
- (UIColor *)textColorForTitleAtIndex:(long)index;
@optional
- (UIColor *)textColorForGridAtGridIndex:(GridIndex)gridIndex;
@optional
- (UIFont *)fontForTitleAtIndex:(long)index;
@optional
- (UIFont *)fontForGridAtGridIndex:(GridIndex)gridIndex;
@end

@interface GridView : UIView
@property (nonatomic) id<GridViewDelegate> delegate;
@property (nonatomic) UIScrollView *backScrollView;
@property (nonatomic) UIScrollView *backTitleScrollView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setTitles:(NSArray *)titles andObjects:(NSArray *)objects withTags:(NSArray *)tags;
-(void)reloadData:(NSArray *)object withGridIndex:(GridIndex)gridIndex;
@end
