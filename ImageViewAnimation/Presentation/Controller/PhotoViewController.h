//
//  ViewController.h
//  ImageViewAnimation
//
//  Created by Hiên on 8/16/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewControllerDelegate

- (void)dismissViewContainImageView:(UIImageView *)imageView;

@end


@interface PhotoViewController : UIViewController

@property (weak, nonatomic) id<PhotoViewControllerDelegate> delegate;

- (instancetype)initWithPhotoItems:(NSArray<UIImage *> *)items atIndex:(NSInteger)index withSourceRect:(CGRect)sourceRect;

@end

