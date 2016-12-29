//
//  HYHProgressView.m
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/24.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import "HYHProgressView.h"
#import "UAProgressView.h"
@interface HYHProgressView ()
@property (strong, nonatomic) UAProgressView * progressView;
@property (strong, nonatomic) UILabel * progressLabel;
@property (strong, nonatomic) UIImageView * emptyImageView;
//@property (strong, nonatomic) UILabel * failLabel;
@end
@implementation HYHProgressView
- (void)removeWithContentView {
    [_progressView  removeFromSuperview];
    [_progressLabel removeFromSuperview];
    [_emptyImageView removeFromSuperview];
}
- (void)showProgress {
    _progressView = [[UAProgressView alloc] init];
    _progressView.bounds = CGRectMake(0, 0, 50, 50);
    _progressView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0,[UIScreen mainScreen].bounds.size.height/2.0);
    _progressView.borderWidth = 3;
    _progressView.lineWidth = 6;
    _progressView.progress = 0.0001;
    _progressView.fillOnTouch = NO;
    _progressView.tintColor = [UIColor whiteColor];
    [self addSubview:_progressView];
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50.0, 20.0)];
    [_progressLabel setTextAlignment:NSTextAlignmentCenter];
    _progressLabel.font = [UIFont systemFontOfSize:11];
    _progressLabel.textColor = [UIColor whiteColor];
    _progressLabel.center = _progressView.center;
    [self addSubview:_progressLabel];
}
- (void)setProgress:(CGFloat)progress {
    [_emptyImageView removeFromSuperview];
    [_progressView setProgress:progress animated:YES];
    _progressLabel.text = [NSString stringWithFormat:@"%2.0f%%",progress * 100];
    if (progress >= 1) {
        [_progressView removeFromSuperview];
        [_progressLabel removeFromSuperview];
    }
}
- (void)showLoadFail {
    [_progressView removeFromSuperview];
    [_progressLabel removeFromSuperview];
    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0-40, [UIScreen mainScreen].bounds.size.height/2.0-40, 80, 80);
    _emptyImageView = [[UIImageView alloc] initWithFrame:frame];
    _emptyImageView.image = [UIImage imageNamed:@"hyhdefaultImage"];
    [self addSubview:_emptyImageView];
}
@end
