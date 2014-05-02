//
//  JWCViewController.m
//  Collection View Fun
//
//  Created by Jeff Schwab on 5/1/14.
//  Copyright (c) 2014 Jeff Writes Code. All rights reserved.
//

#import "JWCViewController.h"
#import "JWCCollectionViewCell.h"
#import "JWCCollectionViewFlowLayoutVariableCenterAndScale.h"
#import "JWCCollectionViewFlowLayoutDragAndDrop.h"

@interface JWCViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    BOOL _holdingCell;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewCell *movedCell;
@property (strong, nonatomic) UIView *highlightView;

@property (strong, nonatomic) NSMutableArray *colors;

@end

@implementation JWCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPress];
    
    UILongPressGestureRecognizer *twoFingerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerLongPress:)];
    twoFingerLongPress.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:twoFingerLongPress];
    
    self.colors = [NSMutableArray new];
    for (int x = 0; x < 100; x++) {
        UIColor *currentColor = [self randomColor];
        [self.colors addObject:currentColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.colors count];;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWCCollectionViewCell *cell;
    cell = (JWCCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

#pragma mark - Gesture Recognizers
- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    JWCCollectionViewFlowLayoutVariableCenterAndScale *layout = (JWCCollectionViewFlowLayoutVariableCenterAndScale *)self.collectionView.collectionViewLayout;
    if (pinch.state == UIGestureRecognizerStateBegan) {
        CGPoint pinchLocation = [pinch locationInView:self.collectionView];
        NSIndexPath *cellIndexPath = [self.collectionView indexPathForItemAtPoint:pinchLocation];
        layout.currentCellPath = cellIndexPath;
    } else if (pinch.state == UIGestureRecognizerStateChanged) {
        layout.currentScale = pinch.scale;
        layout.currentCenter = [pinch locationInView:self.collectionView];
    } else if (pinch.state == UIGestureRecognizerStateEnded) {
        [self.collectionView performBatchUpdates:^{
            layout.currentCellPath = nil;
            layout.currentScale = 1.0;
        } completion:nil];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    JWCCollectionViewFlowLayoutVariableCenterAndScale *layout = (JWCCollectionViewFlowLayoutVariableCenterAndScale *)self.collectionView.collectionViewLayout;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        _holdingCell = true;
        layout.currentScale = 1;
        CGPoint pressedLocation = [longPress locationInView:self.collectionView];
        NSIndexPath *cellIndexPath = [self.collectionView indexPathForItemAtPoint:pressedLocation];
        layout.currentCellPath = cellIndexPath;
    } else if (longPress.state == UIGestureRecognizerStateChanged) {
        layout.currentCenter = [longPress locationInView:self.collectionView];
    } else if (longPress.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *closestIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
        
        UIColor *tempColorFromArray = self.colors[closestIndexPath.row];
        self.colors[closestIndexPath.row] = self.colors[layout.currentCellPath.row];
        self.colors[layout.currentCellPath.row] = tempColorFromArray;
        
        [self.collectionView reloadData];
        
        [self.collectionView performBatchUpdates:^{
            layout.currentCellPath = nil;
            layout.currentScale = 1.0;
        } completion:nil];
    }
}

- (void)twoFingerLongPress:(UILongPressGestureRecognizer *)twoFingerLongPress
{
    if (twoFingerLongPress.state == UIGestureRecognizerStateBegan) {
        self.highlightView = [UIView new];
        self.highlightView.layer.anchorPoint = CGPointMake(0, 0);
        CGPoint touchLocation = [twoFingerLongPress locationInView:self.collectionView];
        self.highlightView.frame = CGRectMake(touchLocation.x, touchLocation.y, 1, 1);
        self.highlightView.backgroundColor = [UIColor grayColor];
        self.highlightView.alpha = .5;
        [self.view addSubview:self.highlightView];
    } else if (twoFingerLongPress.state == UIGestureRecognizerStateChanged) {
        CGPoint currentTouch = [twoFingerLongPress locationInView:self.collectionView];
        CGFloat originX = self.highlightView.frame.origin.x;
        CGFloat originY = self.highlightView.frame.origin.y;
        
        self.highlightView.layer.transform = CATransform3DMakeScale(currentTouch.x - originX, currentTouch.y - originY, 1.0);
        
    } else if (twoFingerLongPress.state == UIGestureRecognizerStateEnded) {
        [self.highlightView removeFromSuperview];
    }
}

#pragma mark - Convenience Methods
- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end
