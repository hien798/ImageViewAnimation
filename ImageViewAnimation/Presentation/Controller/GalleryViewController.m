//
//  PhotoViewController.m
//  ImageViewAnimation
//
//  Created by Hiên on 8/19/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "GalleryViewController.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoViewController.h"
#import "PopAnimation.h"
#import <AVFoundation/AVFoundation.h>

@interface GalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, PhotoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic) NSArray *photos;
@property (nonatomic) PopAnimation *popAnimation;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    _photos = @[[UIImage imageNamed:@"cat-1"], [UIImage imageNamed:@"cat-2"], [UIImage imageNamed:@"cat-3"], [UIImage imageNamed:@"cat-4"], [UIImage imageNamed:@"cat-5"], [UIImage imageNamed:@"cat-6"], [UIImage imageNamed:@"cat-7"], [UIImage imageNamed:@"cat-8"], [UIImage imageNamed:@"cat-9"], [UIImage imageNamed:@"cat-10"], [UIImage imageNamed:@"cat-11"], [UIImage imageNamed:@"cat-12"], [UIImage imageNamed:@"cat-13"], [UIImage imageNamed:@"cat-14"], [UIImage imageNamed:@"cat-15"], [UIImage imageNamed:@"cat-16"], [UIImage imageNamed:@"cat-17"], [UIImage imageNamed:@"cat-18"], [UIImage imageNamed:@"cat-19"], [UIImage imageNamed:@"cat-20"], [UIImage imageNamed:@"cat-21"], [UIImage imageNamed:@"cat-22"], [UIImage imageNamed:@"cat-23"], [UIImage imageNamed:@"cat-24"]];
    _popAnimation = [[PopAnimation alloc] init];
}

- (void)setupView {
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    
    _navigationBar.topItem.title = @"Photo Viewer";
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = [_photos objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_photos count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width/3-7, self.view.bounds.size.width/3-7);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
//    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    CGRect sourceFrame = [self.collectionView convertRect:attributes.frame toView:self.collectionView.superview];
    
    _popAnimation.sourceFrame = sourceFrame;

//    ZAViewController *zaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZAViewController"];
//    zaVC.delegate = self;
//    [zaVC setImage:[_photos objectAtIndex:indexPath.row]];
//    zaVC.transitioningDelegate = self;
//    [self presentViewController:zaVC animated:YES completion:nil];
    
    
    
    PhotoViewController *vc = [[PhotoViewController alloc] initWithPhotoItems:_photos atIndex:indexPath.row withSourceRect:sourceFrame];
    vc.delegate = self;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    NSLog(@"lalalalalalaq");
    
}

# pragma mark - UIViewControllerTransitioningDelegate


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return _popAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _popAnimation;
}


# pragma mark - PhotoViewControllerDelegate

- (void)dismissViewContainImageView:(UIImageView *)imageView {
//    _popAnimation.
    NSLog(@"dismiss vc");
    _popAnimation.imageView = imageView;
}



@end
