//
//  EqualSpaceFlowLayout.m
//  MobileHospital
//
//  Created by ZY on 2018/7/5.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "EqualSpaceFlowLayout.h"

@implementation EqualSpaceFlowLayout

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGFloat xOffset = self.sectionInset.left;
    CGFloat yOffset = self.sectionInset.top;
    CGFloat xNextOffset = self.sectionInset.left;
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
        xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
        if (xNextOffset > [self collectionView].bounds.size.width - self.sectionInset.right) {
            xOffset = self.sectionInset.left;
            xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + self.minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
        }
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        [_itemAttributes addObject:layoutAttributes];
    }
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

//#pragma mark - Methods to Override
//- (void)prepareLayout
//{
//    [super prepareLayout];
//    
//    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
//    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
//    
//    CGFloat xOffset = self.sectionInset.left;
//    CGFloat yOffset = self.sectionInset.top;
//    CGFloat xNextOffset = self.sectionInset.left;
//    for (NSInteger idx = 0; idx < itemCount; idx++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
//        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
//        
//        xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
//        if (xNextOffset > [self collectionView].bounds.size.width - self.sectionInset.right) {
//            xOffset = self.sectionInset.left;
//            xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
//            yOffset += (itemSize.height + self.minimumLineSpacing);
//        }
//        else
//        {
//            xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
//        }
//        
//        UICollectionViewLayoutAttributes *layoutAttributes =
//        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//        
//        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
//        [_itemAttributes addObject:layoutAttributes];
//    }
//}
//
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return (self.itemAttributes)[indexPath.item];
//}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

@end
