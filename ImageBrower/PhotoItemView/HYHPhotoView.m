//
//  PhotoItem.m
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/22.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import "HYHPhotoView.h"
#import "HYHPhoto.h"
#import "HYHProgressView.h"
#import "UIImageView+WebCache.h"
@interface HYHPhotoView ()<UIScrollViewDelegate>
@property (assign, nonatomic) BOOL doubleTap;
/** 双击 */
@property (strong, nonatomic) UITapGestureRecognizer * doubleWithTapGesture;
/** 单击 */
@property (strong, nonatomic) UITapGestureRecognizer * singleWithTapGesture;
/** 长按 */
@property (strong, nonatomic) UILongPressGestureRecognizer * longWithPressGesture;

@end

@implementation HYHPhotoView

- (instancetype)initWithFrame:(CGRect)frame Del:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.photo_view_delegate = delegate;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.bouncesZoom = YES;
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        [self addGestureRecognizer:self.doubleWithTapGesture];
        [self addGestureRecognizer:self.singleWithTapGesture];
        [self addGestureRecognizer:self.longWithPressGesture];
        [self.singleWithTapGesture requireGestureRecognizerToFail:self.doubleWithTapGesture];
        _hyhProgressView = [[HYHProgressView alloc] init];
    }
    return self;
}
- (UITapGestureRecognizer *)doubleWithTapGesture {
    if(!_doubleWithTapGesture){
        _doubleWithTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
        _doubleWithTapGesture.numberOfTapsRequired = 2;
    }
    return _doubleWithTapGesture;
}
- (UITapGestureRecognizer *)singleWithTapGesture {
    if (!_singleWithTapGesture) {
        _singleWithTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        _singleWithTapGesture.delaysTouchesBegan = YES;
        _singleWithTapGesture.numberOfTapsRequired = 1;
    }
    return _singleWithTapGesture;
}
- (UILongPressGestureRecognizer *)longWithPressGesture {
    if (!_longWithPressGesture) {
        _longWithPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        _longWithPressGesture.minimumPressDuration = 1.0;
    }
    return _longWithPressGesture;
}
- (void)doubleTapGesture:(UITapGestureRecognizer *) tap {
    _doubleTap = YES;
    if (!_imageView.image) {
        return;
    }
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}
- (void)singleTapGesture:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    if (_photo_view_delegate && [_photo_view_delegate respondsToSelector:@selector(photoItemSingleTapWithHyhPhotoView:)]) {
        [_photo_view_delegate photoItemSingleTapWithHyhPhotoView:self];
    }
}
- (void)longPressGesture:(UITapGestureRecognizer *)gesture {
    /*
    if(gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
     */
}
- (void)centerContent {
    CGRect imageViewFrame = _imageView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (imageViewFrame.size.height > screenBounds.size.height) {
        imageViewFrame.origin.y = 0.0f;
    }else {
        imageViewFrame.origin.y = (screenBounds.size.height - imageViewFrame.size.height) / 2.0;
    }
    if (imageViewFrame.size.width < screenBounds.size.width) {
        imageViewFrame.origin.x = (screenBounds.size.width - imageViewFrame.size.width) /2.0;
    }else {
        imageViewFrame.origin.x = 0.0f;
    }
    CGRect sourceImageViewFrame = imageViewFrame;
    UIViewController * con = [self viewController];
    if (_hyhPhoto.is_show_first && (_hyhPhoto.sourceImageView || _hyhPhoto.haskSourceImageViewFrame)) {
        sourceImageViewFrame = _hyhPhoto.sourceImageViewFrame;
        _imageView.frame = sourceImageViewFrame;
        con.view.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.35 animations:^{
            _imageView.frame = imageViewFrame;
            con.view.backgroundColor = [UIColor blackColor];
        }completion:^(BOOL finished) {
        }];
        _hyhPhoto.is_show_first = NO;
    }else {
        _imageView.frame = imageViewFrame;
    }
}
#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerContent];
}
- (void)setHyhPhoto:(HYHPhoto *)hyhPhoto {
    _hyhPhoto = hyhPhoto;
    if (!hyhPhoto) {
        return;
    }
    if (hyhPhoto.image) {   //本地图片
        self.scrollEnabled = YES;
        _imageView.image = hyhPhoto.image;
        [self adaptImageViewFrame];
        [_hyhProgressView removeWithContentView];
    }else {                 //网络加载图片
        self.scrollEnabled = NO;
        //显示进度条
        [_hyhProgressView showProgress];
        [self addSubview:_hyhProgressView];
        __weak HYHPhotoView * hyhPhotoView = self;
        __weak HYHProgressView * hyhProgressView = _hyhProgressView;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:hyhPhoto.url] placeholderImage:hyhPhoto.sourceImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize > 0.0001) {
                hyhProgressView.progress = (double)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [hyhPhotoView photoDownloadFinishedWithImage:image];
        }];
    }
}
- (void)photoDownloadFinishedWithImage:(UIImage *)image {
    if (image) {
        self.scrollEnabled = YES;
        _hyhPhoto.image = image;
        [self adaptImageViewFrame];
        [_hyhProgressView removeWithContentView];
    }else {
        self.bouncesZoom = NO;
        [_hyhProgressView showLoadFail];
    }
}
- (void)adaptImageViewFrame {
    if (!_imageView.image) {
        return;
    }
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 4;
    self.zoomScale = 1;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect imageViewFrame = CGRectMake(0, 0, screenWidth, screenHeight);
    //较胖
    if (imageWidth/imageHeight >= screenWidth/screenHeight) {
        imageViewFrame = CGRectMake(0, 0, screenWidth, screenWidth*imageHeight/imageWidth);
    }else {
        imageViewFrame = CGRectMake(0, 0, screenHeight*imageWidth/imageHeight, screenHeight);
    }
    _imageView.frame = imageViewFrame;
    self.contentSize = CGSizeMake(imageViewFrame.size.width, imageViewFrame.size.height);
    [self centerContent];
}
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
