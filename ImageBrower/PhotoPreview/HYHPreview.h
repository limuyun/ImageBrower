//
//  HYHPreview.h
//  ImgBrowerDemo
//
//  Created by limuyun on 16/7/27.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYHPreview;
@protocol HYHPreviewDelegate <NSObject>

@optional
- (void)hyhPreview:(HYHPreview *)hyhPreview  selectIndex:(NSInteger)index;

@end

@interface HYHPreview : UIView
/**
 *所有图片对象,单个元素为 HYHPhoto.
 */
@property (strong, nonatomic) NSArray * hyhPhotos;
/**
 *右下角当前页数展示,default is YES.
 */
@property (assign, nonatomic) BOOL showSignNum;
/**
 *是否自动滚动,default is NO.
 */
@property (assign, nonatomic) BOOL autoScoroll;
/**
 *自动滚动时间间隔,default is 3.0.
 */
@property (assign, nonatomic) NSTimeInterval autoScrollInterval;
/**
 *点击是否放大图片,Default is NO.
 */
@property (assign, nonatomic) BOOL showPhotoBrowerCon;

@property (weak, nonatomic) id <HYHPreviewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame Del:(id)delegate;
@end
