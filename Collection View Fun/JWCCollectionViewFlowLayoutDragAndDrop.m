//
//  JWCCollectionViewFlowLayoutDragAndDrop.m
//  Collection View Fun
//
//  Created by Jeff Schwab on 5/1/14.
//  Copyright (c) 2014 Jeff Writes Code. All rights reserved.
//

#import "JWCCollectionViewFlowLayoutDragAndDrop.h"

@implementation JWCCollectionViewFlowLayoutDragAndDrop

- (void)setCurrentCenter:(CGPoint *)currentCenter
{
    _currentCenter = currentCenter;
    [self invalidateLayout];
}

@end
