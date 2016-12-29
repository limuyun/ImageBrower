//
//  PhotoItem.m
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/24.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import "HYHPhoto.h"

@interface HYHPhoto ()
@end

@implementation HYHPhoto
- (CGRect)sourceImageViewFrame {
    if (_haskSourceImageViewFrame) {
        return _kSourceImageViewFrame;
    }
    if (self.sourceImageView) {
        return [self.sourceImageView convertRect:self.sourceImageView.bounds toView:nil];
    }
    return CGRectZero;
}
@end
