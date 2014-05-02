//
//  JWCCollectionViewFlowLayout.m
//  Collection View Fun
//
//  Created by Jeff Schwab on 5/1/14.
//  Copyright (c) 2014 Jeff Writes Code. All rights reserved.
//

#import "JWCCollectionViewFlowLayoutVariableCenterAndScale.h"
@import QuartzCore;

@implementation JWCCollectionViewFlowLayoutVariableCenterAndScale

- (void)setCurrentCenter:(CGPoint)currentCenter
{
    _currentCenter = currentCenter;
    [self invalidateLayout];
}

- (void)setCurrentScale:(CGFloat)currentScale
{
    _currentScale = currentScale;
    [self invalidateLayout];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self modifyAttributes:layoutAttributes];
    return layoutAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
        [self modifyAttributes:layoutAttributes];
    }
    return layoutAttributesArray;
}

- (void)modifyAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    if ([attributes.indexPath isEqual:_currentCellPath]) {
        attributes.transform3D = CATransform3DMakeScale(_currentScale, _currentScale, 1.0);
        attributes.center = _currentCenter;
        attributes.zIndex = 1;
    }
}

@end
