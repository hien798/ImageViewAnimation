//
//  PhotoCollectionViewCell.m
//  ImageViewAnimation
//
//  Created by Hiên on 8/19/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
const CGFloat kPadding = 0;
@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _imageView = [[UIImageView alloc] init];
    _imageView.bounds = CGRectMake(0, 0, self.bounds.size.width-2*kPadding, self.bounds.size.width-2*kPadding);
    _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageView];
    return self;
}

@end
