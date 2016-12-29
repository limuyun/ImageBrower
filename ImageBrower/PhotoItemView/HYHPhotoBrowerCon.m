//
//  PhotoBrowerCon.m
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/23.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import "HYHPhotoBrowerCon.h"
#import "HYHPhotoView.h"
#import "HYHPhotoBarView.h"
#import "UIImageView+WebCache.h"
#define Kspace 10
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KPhotoBrowerViewTag 100
@interface HYHPhotoBrowerCon ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView * photo_scrollView;
/** 所有的图片*/
@property (strong, nonatomic) NSMutableSet * visiblePhotoViews;
@property (strong, nonatomic) NSMutableSet * reusablePhotoViews;

@property (strong, nonatomic) HYHPhotoTopBarView * topBarView;
@property (assign, nonatomic) BOOL topBarHidden;
@property (strong, nonatomic) HYHPhotoBottomBarView * bottomBarView;

@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;

@property (assign, nonatomic) HyhPhotoBrowserType browerType;
@end

@implementation HYHPhotoBrowerCon

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentPhotoIndex = 0;
    }
    return self;
}
- (void)showCon:(UIViewController *)con browserPhotoType:(HyhPhotoBrowserType)browserPhotoType {
    _browerType = browserPhotoType;
    if (browserPhotoType == HyhPhotoBrowserTypePush) {
        [con.navigationController pushViewController:self animated:YES];
    }else if (browserPhotoType == HyhPhotoBrowserTypeModel) {
        [con presentViewController:self animated:YES completion:nil];
    }else if (browserPhotoType == HyhPhotoBrowserTypeNormal) {
        for (int i = 0 ; i < _hyhPhotos.count; i ++) {
            HYHPhoto * photo = _hyhPhotos[i];
            photo.is_show_first = i == _currentPhotoIndex;
        }
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.view];
        [window.rootViewController addChildViewController:self];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.x -= Kspace;
    rect.size.width += (2 * Kspace);
    _photo_scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _photo_scrollView.pagingEnabled = YES;
    _photo_scrollView.delegate = self;
    _photo_scrollView.contentSize = CGSizeMake(rect.size.width * _hyhPhotos.count, rect.size.height);
    _photo_scrollView.contentOffset = CGPointMake(_currentPhotoIndex * rect.size.width, 0);
    [self.view addSubview:_photo_scrollView];
    [self showPhotos];
    if (_browerType == HyhPhotoBrowserTypePush || _browerType == HyhPhotoBrowserTypeModel) {
        [self creatPhotoTopBar];
    }else {
        [self creatPhotoBottomBar];
    }
}
- (void)setHyhPhotos:(NSArray *)hyhPhotos {
    _hyhPhotos = hyhPhotos;
    if (hyhPhotos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
}
- (void)setCurrentPhotoIndex:(NSInteger)currentPhotoIndex {
    _currentPhotoIndex = currentPhotoIndex;
}
- (void)showPhotos {
    // 只有一张图片
    if (_hyhPhotos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    CGRect visibleBounds = _photo_scrollView.bounds;
    NSInteger firstIndex = floorf((CGRectGetMinX(visibleBounds)+Kspace*2) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floorf((CGRectGetMaxX(visibleBounds)-Kspace*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _hyhPhotos.count) firstIndex = _hyhPhotos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _hyhPhotos.count) lastIndex = _hyhPhotos.count - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (HYHPhotoView * photoView in _visiblePhotoViews) {
        photoViewIndex = photoView.tag - KPhotoBrowerViewTag;
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}
#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSInteger)index {
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.x = (rect.size.width + 2 * Kspace) * index + Kspace;
    HYHPhotoView * photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[HYHPhotoView alloc] initWithFrame:rect Del:self];
    }else {
        photoView.frame = rect;
    }
    photoView.hyhPhoto = _hyhPhotos[index];
    photoView.tag = KPhotoBrowerViewTag + index;
    [_visiblePhotoViews addObject:photoView];
    [_photo_scrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}
#pragma mark 循环利用某个view
- (HYHPhotoView *)dequeueReusablePhotoView  {
    HYHPhotoView * photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    [photoView.hyhProgressView removeWithContentView];
    return photoView;
}
- (void)loadImageNearIndex:(NSInteger)index {
    
    if (index > 0) {
        HYHPhoto * photo = _hyhPhotos[index - 1];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:photo.url] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        }];
    }
    if (index < _hyhPhotos.count - 1) {
        HYHPhoto * photo = _hyhPhotos[index + 1];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:photo.url] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        }];
    }
}
#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (HYHPhotoView * photoView in _visiblePhotoViews) {
        if (photoView.tag - KPhotoBrowerViewTag == index) {
            return YES;
        }
    }
    return  NO;
}
- (void)creatPhotoTopBar {
    _topBarView = [[HYHPhotoTopBarView alloc] initWithDel:self];
    _topBarView.topBarHidden = _topBarHidden = YES;
    [self.view addSubview:_topBarView];
    self.navigationController.navigationBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    [self updateTopBarCondition];
}
- (void)creatPhotoBottomBar {
    _bottomBarView = [[HYHPhotoBottomBarView alloc] initWithDel:self];
    [self.view addSubview:_bottomBarView];
    [self updateBottomBarCondition];
}
- (void)updateTopBarCondition {
    NSString * title = [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInteger:_currentPhotoIndex+1],[NSNumber numberWithInteger:_hyhPhotos.count]];
    _topBarView.titleLabel.text = title;
}
- (void)updateBottomBarCondition {
    NSString * title = [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInteger:_currentPhotoIndex+1],[NSNumber numberWithInteger:_hyhPhotos.count]];
    _bottomBarView.numText = title;
}
#pragma mark -- <TopBarDelegate> methods
- (void)topBarOfBtnClickWithTemp:(NSInteger)temp {
    if (temp == 100) {//返回
        if (_browerType == HyhPhotoBrowserTypePush) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (_browerType == HyhPhotoBrowserTypeModel) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
#pragma mark -- <BottomBarDelegate> methods
- (void)bottomBarOfBtnClickWithTemp:(NSInteger)temp {
    [_photo_scrollView setContentOffset:CGPointMake(_photo_scrollView.frame.size.width * temp, 0) animated:YES];
}
#pragma mark -- <PhotoItemDelegaet> methods
- (void)photoItemSingleTapWithHyhPhotoView:(HYHPhotoView *)hyhPhotoView {
    if (_browerType == HyhPhotoBrowserTypePush || _browerType == HyhPhotoBrowserTypeModel) {
        _topBarHidden = !_topBarHidden;
        _topBarView.topBarHidden = _topBarHidden;
        _statusBarStyle = _topBarHidden ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [self setNeedsStatusBarAppearanceUpdate];
    }else if (_browerType == HyhPhotoBrowserTypeNormal) {
        [hyhPhotoView.hyhProgressView removeWithContentView];
        CGRect sourceFrame = hyhPhotoView.hyhPhoto.sourceImageViewFrame;
        BOOL isInScreen = CGRectIntersectsRect(sourceFrame, [UIScreen mainScreen].bounds);
        if (hyhPhotoView.zoomScale > 1) {
            hyhPhotoView.zoomScale = 1;
        }
        [UIView animateWithDuration:.5f animations:^{
            if (isInScreen && (hyhPhotoView.hyhPhoto.sourceImageView || hyhPhotoView.hyhPhoto.haskSourceImageViewFrame)) {
                hyhPhotoView.imageView.frame = hyhPhotoView.hyhPhoto.sourceImageViewFrame;
            }else {
                hyhPhotoView.alpha = 0;
                hyhPhotoView.transform= CGAffineTransformMakeScale(0.8,0.8);
            }
            _bottomBarView.alpha = 0;
            self.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currentPhotoIndex = _photo_scrollView.contentOffset.x / _photo_scrollView.frame.size.width;
    if (_browerType == (HyhPhotoBrowserTypePush | HyhPhotoBrowserTypeModel )) {
        [self updateTopBarCondition];
    }else {
        [self updateBottomBarCondition];
    }
    [self showPhotos];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}
- (BOOL)prefersStatusBarHidden {
    return _topBarHidden;
}
@end
