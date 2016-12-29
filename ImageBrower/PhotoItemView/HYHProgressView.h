//
//  HYHProgressView.h
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/24.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYHProgressView : UIView

@property (assign, nonatomic) CGFloat progress;

- (void)removeWithContentView;
- (void)showProgress;
- (void)showLoadFail;
@end
