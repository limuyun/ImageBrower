//
//  HYHPreview.m
//  ImgBrowerDemo
//
//  Created by limuyun on 16/7/27.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import "HYHPreview.h"
#import "HYHPhoto.h"
#import "UIImageView+WebCache.h"
#import "HYHPhotoBrowerCon.h"
@interface HYHPreview ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView * scrollView;
@property (assign, nonatomic) NSInteger currentPageIndex;
@property (strong, nonatomic) NSMutableArray * imageViewsList;
@property (strong, nonatomic) UILabel * signLabel;
@property (strong, nonatomic) NSTimer * timer;//定制滚动时间
@end

@implementation HYHPreview

- (id)initWithFrame:(CGRect)frame Del:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _imageViewsList = [[NSMutableArray alloc] init];
        _currentPageIndex = 0;
        _autoScoroll = NO;
        _autoScrollInterval = 3.0;
        _showPhotoBrowerCon = NO;
        [self setUpScrollView];
        [self setUpSignLabel];
    }
    return self;
}
- (void)setUpSignLabel {
    CGRect rect = CGRectMake(self.frame.size.width-60, self.frame.size.height-30, 50,20);
    _signLabel = [[UILabel alloc] initWithFrame:rect];
    _signLabel.backgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.7];
    _signLabel.textAlignment = NSTextAlignmentCenter;
    _signLabel.layer.cornerRadius = 3;
    _signLabel.textColor = [UIColor whiteColor];
    _signLabel.font = [UIFont systemFontOfSize:14];
    _signLabel.layer.masksToBounds = YES;
    [self addSubview:_signLabel];
}
- (void)setUpScrollView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.bounds) * 3, CGRectGetHeight(_scrollView.bounds));
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:_scrollView];
}
- (void)setHyhPhotos:(NSArray *)hyhPhotos {
    _hyhPhotos = hyhPhotos;
    if (_hyhPhotos.count == 0 || !_hyhPhotos) {
        return;
    }
    for (int i = 0; i < 3; i ++) {
        NSInteger index = [self processIndexWithIndex:_currentPageIndex - 1 + i];
        CGRect rect = CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        HYHPhoto * photo = hyhPhotos[index];
        if (photo.image) {
            imageView.image = photo.image;
        }else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:nil];
        }
        [imageView setClipsToBounds:YES];
        [_imageViewsList addObject:imageView];
        [_scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapRecognizer:)];
        [imageView addGestureRecognizer:tap];
    }
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.bounds), 0);
    [self startTimer];
}
- (void)imageViewTapRecognizer:(id)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(hyhPreview:selectIndex:)]) {
        [_delegate hyhPreview:self selectIndex:_currentPageIndex];
    }
    if (_showPhotoBrowerCon) {
        for (HYHPhoto * photo in _hyhPhotos) {
            CGRect temp_frame = [self convertRect:self.bounds toView:nil];
            photo.kSourceImageViewFrame = CGRectMake(0, temp_frame.origin.y, self.frame.size.width, self.frame.size.height);
            photo.haskSourceImageViewFrame = YES;
        }
        HYHPhotoBrowerCon * con = [[HYHPhotoBrowerCon alloc] init];
        con.hyhPhotos = _hyhPhotos;
        con.currentPhotoIndex = _currentPageIndex;
        [con showCon:[self viewController] browserPhotoType:HyhPhotoBrowserTypeNormal];
    }
}
- (NSInteger)processIndexWithIndex:(NSInteger)index{
    // 获取最大索引
    NSInteger maximumIndex = _hyhPhotos.count - 1;
    // 判断真实索引位置
    if (index > maximumIndex) {
        index = 0;
    }
    else if (index < 0) {
        index = maximumIndex;
    }
    return index;
}
- (void)updateScrollView{
    BOOL needUpdate = NO;
    CGFloat offset_x = _scrollView.contentOffset.x;
    //向左
    if (offset_x <= 0) {
        _currentPageIndex = [self processIndexWithIndex: --_currentPageIndex];
        needUpdate = YES;
    }
    //向右
    else if (offset_x >= 2*CGRectGetWidth(_scrollView.bounds)){
        _currentPageIndex = [self processIndexWithIndex:++_currentPageIndex];
        needUpdate = YES;
    }
    NSString * sign_str = [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInteger:_currentPageIndex+1],[NSNumber numberWithInteger:_hyhPhotos.count]];
    _signLabel.text = sign_str;
    // 判断是否需要更新
    if (!needUpdate) {
        return;
    }
    // 更新所有imageView显示的图片
    NSInteger leftIndex = [self processIndexWithIndex:_currentPageIndex - 1 ];
    NSInteger rigthIndex = [self processIndexWithIndex:_currentPageIndex + 1];
    for (int i = 0 ; i < _imageViewsList.count; i ++) {
        UIImageView * imageView = _imageViewsList[i];
        HYHPhoto * photo;
        if (i == 0) photo = _hyhPhotos[leftIndex];
        if (i == 1) photo = _hyhPhotos[_currentPageIndex];
        if (i == 2) photo = _hyhPhotos[rigthIndex];
        if (photo.image) {
            imageView.image = photo.image;
        }else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:nil];
        }
    }
    // 恢复可见区域
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.bounds), 0)];
}
#pragma mark -- UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateScrollView];
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView { //将开始拖拽
    [self pauseTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView { //停止拖拽
    [self updateScrollView];
    [self startTimer];
}

- (void)startTimer {
    NSTimeInterval interval = 3.0;
    if (_autoScrollInterval > 0) {
        interval = _autoScrollInterval;
    }
    if (!_autoScoroll) {
        return;
    }
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(respondToTimer:) userInfo:nil repeats:YES];
    }
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
    
}
- (void)pauseTimer{
    if (_timer && _timer.isValid) {
        _timer.fireDate = [NSDate distantFuture];
    }
}
- (void)stopTimer{
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)respondToTimer:(NSTimer *)timer {
    [_scrollView setContentOffset:CGPointMake(2 * CGRectGetWidth(_scrollView.bounds), 0 ) animated:YES];
}

- (void)setShowSignNum:(BOOL)showSignNum {
    _signLabel.hidden = showSignNum;
}
- (void)setAutoScoroll:(BOOL)autoScoroll {
    _autoScoroll = autoScoroll;
    if (autoScoroll) [self startTimer];
    else [self stopTimer];
}
- (void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval {
    [self pauseTimer];
    _autoScrollInterval = autoScrollInterval;
    [self startTimer];
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
