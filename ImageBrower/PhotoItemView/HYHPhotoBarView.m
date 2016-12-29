//
//  TopBarView.m
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/23.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import "HYHPhotoBarView.h"

@implementation HYHPhotoTopBarView
- (id)initWithDel:(id)delegate {
    _delegate = delegate;
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        backButton.frame = CGRectMake(10, 20, 60, 44);
        backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [backButton setTitle:@"<--返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backButton.tag = 100;
        [backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, [UIScreen mainScreen].bounds.size.width-200, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return self;
}
- (void)setTopBarHidden:(BOOL)topBarHidden {
    self.hidden = topBarHidden;
    for (UIView * view in self.subviews) {
        view.hidden = topBarHidden;
    }
}
- (void)backBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(topBarOfBtnClickWithTemp:)]) {
        [_delegate topBarOfBtnClickWithTemp:sender.tag];
    }
}
@end


@interface HYHPhotoBottomBarView ()
@property (strong, nonatomic) UILabel * numLabel;
@end
@implementation HYHPhotoBottomBarView

- (id)initWithDel:(id)delegate {
    _delegate = delegate;
    CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel * numLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, [UIScreen mainScreen].bounds.size.width-200, 20)];
        numLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        numLabel.font = [UIFont systemFontOfSize:16];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor whiteColor];
        numLabel.layer.cornerRadius = 10;
        numLabel.layer.masksToBounds = YES;
        [self addSubview:numLabel];
        _numLabel = numLabel;
    }
    return self;
}
- (void)setNumText:(NSString *)numText {
    _numLabel.text = numText;
    [_numLabel sizeToFit];
    _numLabel.bounds = CGRectMake(0, 0, _numLabel.bounds.size.width+16, _numLabel.bounds.size.height);
    _numLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 22);
    
}
- (void)setBottomBarHidden:(BOOL)bottomBarHidden {
    self.hidden = bottomBarHidden;
    for (UIView * view in self.subviews) {
        view.hidden = bottomBarHidden;
    }
}
@end
