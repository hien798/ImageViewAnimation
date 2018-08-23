//
//  PopAnimation.h
//  ImageViewAnimation
//
//  Created by Hiên on 8/21/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PopAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) CGRect sourceFrame;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImageView *sourceImageView;

- (instancetype)initWithSourceFrame:(CGRect)sourceFrame;

@end
