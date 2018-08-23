//
//  ZAPhotoView.m
//  ImageViewAnimation
//
//  Created by Hiên on 8/20/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bouncesZoom = YES;
        self.maximumZoomScale = 4;
        self.multipleTouchEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
//        _imageView = [[UIImageView alloc] init];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImageItem:(UIImage *)image {
    _image = image;
    if (image) {
        self.imageView.image = image;
    }    
}

@end
