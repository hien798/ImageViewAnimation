//
//  ZAPhotoView.h
//  ImageViewAnimation
//
//  Created by Hiên on 8/20/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIScrollView

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImage *image;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setImageItem:(UIImage *)image;

@end
