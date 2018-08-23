//
//  PopAnimation.m
//  ImageViewAnimation
//
//  Created by Hiên on 8/21/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "PopAnimation.h"
#import <AVFoundation/AVFoundation.h>

const NSTimeInterval kPopDuration = 1.0;

@interface PopAnimation ()

@property (nonatomic) BOOL isPresent;

@end

@implementation PopAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        _sourceFrame = CGRectZero;
        _isPresent = YES;
    }
    return self;
}

- (instancetype)initWithSourceFrame:(CGRect)sourceFrame {
    self = [super init];
    if (self) {
        _sourceFrame = sourceFrame;
        _isPresent = YES;
    }
    return self;
}


- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (_isPresent) {
        [self presentTransition:transitionContext];
    } else {
        [self dismissTransition:transitionContext];
//        [transitionContext completeTransition:YES];
    }
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return kPopDuration;
}

- (void)presentTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *container = transitionContext.containerView;
    
    CGFloat height = _sourceFrame.size.width * (toView.frame.size.height / toView.frame.size.width);
    
    CGFloat sX = _sourceFrame.size.width/toView.frame.size.width;
    CGFloat sY = height/toView.frame.size.height;
    CGRect destinationFrame = toView.frame;
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(sX, sY);
    
    toView.transform = scaleTransform;
    toView.center = CGPointMake(CGRectGetMidX(_sourceFrame), CGRectGetMidY(_sourceFrame));
    toView.clipsToBounds = YES;
    
    [container addSubview:toView];
    [container bringSubviewToFront:toView];
    
    [UIView animateWithDuration:kPopDuration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toView.transform = CGAffineTransformIdentity;
        toView.center = CGPointMake(CGRectGetMidX(destinationFrame), CGRectGetMidY(destinationFrame));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        self.isPresent = NO;
    }];
}

- (void)dismissTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *_fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    UIView *fromView = _imageView ? _imageView : [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *container = transitionContext.containerView;
    
    CGFloat height = _sourceFrame.size.width * (toView.frame.size.height / toView.frame.size.width);
    
    CGFloat sX = _sourceFrame.size.width/fromView.frame.size.width;
    CGFloat sY = height/fromView.frame.size.height;
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(sX, sY);
    
    [container addSubview:fromView];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        fromView.transform = scaleTransform;
        fromView.center = CGPointMake(CGRectGetMidX(self.sourceFrame), CGRectGetMidY(self.sourceFrame));
        fromView.frame = self.sourceFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        self.isPresent = YES;
    }];
    
}

@end
