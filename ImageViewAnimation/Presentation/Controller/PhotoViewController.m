//
//  ViewController.m
//  ImageViewAnimation
//
//  Created by Hiên on 8/16/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoView.h"


@interface PhotoViewController () <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSArray *photos;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSMutableSet *reuseableItemViews;
@property (nonatomic) NSMutableArray *visibleItemViews;
@property (nonatomic) CGRect startFrame;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) CGRect sourceRect;

@end

@implementation PhotoViewController

- (instancetype)initWithPhotoItems:(NSArray<UIImage *> *)items atIndex:(NSInteger)index withSourceRect:(CGRect)sourceRect {
    self = [super init];
    if (self) {
        _photos = items;
        _currentPage = index;
        _sourceRect = sourceRect;
        _reuseableItemViews = [[NSMutableSet alloc] init];
        _visibleItemViews = [[NSMutableArray alloc] init];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    [self addGesturerecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PhotoView *photoView = [self itemViewWithPage:_currentPage];
    CGRect desRect = photoView.imageView.frame;
    photoView.imageView.frame = _sourceRect;
    UIImage *image = [_photos objectAtIndex:_currentPage];
//    photoView.imageView.image = image;
    photoView.alpha = 0;
    self.backgroundView.alpha = 0;
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 1;
        photoView.imageView.frame = desRect;
        photoView.alpha = 1;
    } completion:^(BOOL finished) {
        [photoView setImageItem:image];
    }];
}

- (void)setupView {
    _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-10, 0, self.view.bounds.size.width + 20, self.view.bounds.size.height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*[_photos count], _scrollView.bounds.size.height);
    [self.view addSubview:_scrollView];
    CGFloat padding = 10;
    CGRect rect = _scrollView.frame;
    
    for (PhotoView *item in _visibleItemViews) {
        item.frame = CGRectMake(0, item.tag*rect.size.width, rect.size.width - 2*padding, rect.size.height);
    }
    
    CGPoint contentOffset = CGPointMake(rect.size.width*_currentPage, 0);
    [_scrollView setContentOffset:contentOffset animated:NO];
    if (contentOffset.x == 0) {
        [self scrollViewDidScroll:_scrollView];
    }
}

- (PhotoView *)dequeueReuseableItemView {
    PhotoView *itemView = [_reuseableItemViews anyObject];
    if (itemView == nil) {
        CGRect rect = _scrollView.bounds;
        rect.origin.x = 10; //padding
        rect.size.width = _scrollView.bounds.size.width - 20;
        itemView = [[PhotoView alloc] initWithFrame:rect];
    } else {
        [_reuseableItemViews removeObject:itemView];
    }
    itemView.tag = -1;
    return itemView;
}

- (PhotoView *)itemViewWithPage:(NSInteger)page {
    for (PhotoView *item in _visibleItemViews) {
        if (item.tag == page) {
            return item;
        }
    }
    return nil;
}

- (void)updateReuseableItemViews {
    NSMutableArray *itemsForRemove = [[NSMutableArray alloc] init];
    for (PhotoView *item in _visibleItemViews) {
        if ((item.frame.origin.x + item.frame.size.width < _scrollView.contentOffset.x - _scrollView.frame.size.width) || (item.frame.origin.x > _scrollView.contentOffset.x + 2*_scrollView.frame.size.width)) {
            [item removeFromSuperview];
            [item setImageItem:nil];
            [itemsForRemove addObject:item];
            [_reuseableItemViews addObject:item];
        }
    }
    [_visibleItemViews removeObjectsInArray:itemsForRemove];
}

- (void)updateItemViewContents {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.bounds.size.width + 0.5;
    for (NSInteger i=page-1; i <=page+1; i++) {
        if (i<0 || i>_photos.count-1) {
            continue;
        }
        PhotoView *item = [self itemViewWithPage:i];
        if (item == nil) {
            item = [self dequeueReuseableItemView];
            CGRect rect = _scrollView.bounds;
            rect.origin.x = i*_scrollView.bounds.size.width + 10;
            rect.size.width = _scrollView.bounds.size.width - 20;
            item.frame = rect;
            item.tag = i;
            [_scrollView addSubview:item];
            [_visibleItemViews addObject:item];
        }
        UIImage *image = [_photos objectAtIndex:i];
        [item setImageItem:image];
    }
    if (page != _currentPage && (page >= 0 && page < [_photos count])) {
        _currentPage = page;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupView];
}


// UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateReuseableItemViews];
    [self updateItemViewContents];
}


// Gesture Recognizer

- (void)addGesturerecognizer {
    // Pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)didPan:(UIPanGestureRecognizer *)pan {
    [self performDismissWithPan:pan];
}

- (void)performDismissWithPan:(UIPanGestureRecognizer *)pan {
    PhotoView *photoView = [self itemViewWithPage:_currentPage];
    CGPoint translation = [pan translationInView:self.view]; // delta location of drag drop
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self handlePanBegin];
            _startFrame = photoView.imageView.frame;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            double percent = 1 - fabs(translation.y) / self.view.frame.size.height;
            double s = MAX(percent, 0.3);
            
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            self.backgroundView.alpha = percent;
            
            CGFloat width = _startFrame.size.width * s;
            CGFloat height = _startFrame.size.height * s;
            
            CGFloat rateX = (location.x - _startFrame.origin.x) / _startFrame.size.width;
            CGFloat x = location.x - width*rateX;
            
            CGFloat rateY = (location.y - _startFrame.origin.y) / _startFrame.size.height;
            CGFloat y = location.y - height*rateY;
            
            photoView.imageView.frame = CGRectMake(x, y, width, height);
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (fabs(translation.y) > 200 || fabs(velocity.y) > 1000) {
                // dismiss VC
                self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                [self.delegate dismissViewContainImageView:photoView.imageView];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                // cancel pan
                [UIView animateWithDuration:0.1 animations:^{
                    photoView.imageView.frame = self.startFrame;
                    self.backgroundView.alpha = 1;
                    self.view.backgroundColor = [UIColor blackColor];
                } completion:^(BOOL finished) {

                }];
            }
            
//            [UIView animateWithDuration:0.1 animations:^{
//                photoView.imageView.frame = self.startFrame;
//                self.backgroundView.alpha = 1;
//                self.view.backgroundColor = [UIColor blackColor];
//            } completion:^(BOOL finished) {
//
//            }];
            
            break;
        }
        default:
            break;
    }
}

- (void)handlePanBegin {
    NSLog(@"Pan begin");
}

@end
