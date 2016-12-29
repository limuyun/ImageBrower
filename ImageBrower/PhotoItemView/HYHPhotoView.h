//
//  PhotoItem.h
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/22.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHProgressView.h"
@class HYHPhoto,HYHPhotoView;
@protocol PhotoViewDelegate <NSObject>
@optional
- (void)photoItemSingleTapWithHyhPhotoView:(HYHPhotoView *)hyhPhotoView;
@end

@interface HYHPhotoView : UIScrollView
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) HYHPhoto * hyhPhoto;
@property (weak, nonatomic) id <PhotoViewDelegate> photo_view_delegate;
@property (strong, nonatomic) HYHProgressView * hyhProgressView;
- (instancetype)initWithFrame:(CGRect)frame Del:(id)delegate;
@end
