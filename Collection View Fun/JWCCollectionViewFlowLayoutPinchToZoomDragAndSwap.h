//
//  JWCCollectionViewFlowLayout.h
//  Collection View Fun
//
//  Created by Jeff Schwab on 5/1/14.
//  Copyright (c) 2014 Jeff Writes Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCCollectionViewFlowLayoutPinchToZoomDragAndSwap : UICollectionViewFlowLayout

@property (nonatomic) NSIndexPath *currentCellPath;
@property (nonatomic) CGPoint currentCenter;
@property (nonatomic) CGFloat currentScale;

@end
