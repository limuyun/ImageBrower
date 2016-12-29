//
//  PhotoItem.h
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/24.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYHPhoto : NSObject
/**
 * 全路径图片url地址 
 */
@property (strong, nonatomic) NSString * url;
/**
 *完整的图片 
 */
@property (strong, nonatomic) UIImage * image;
/**
 * 源 ImageView
 */
@property (strong, nonatomic) UIImageView * sourceImageView;
@property (assign, readonly) CGRect sourceImageViewFrame;
/**
 *固定 源 ImageView 相对屏幕位置
 */
@property (assign, nonatomic) CGRect kSourceImageViewFrame;
@property (assign, nonatomic) BOOL haskSourceImageViewFrame;
/**
 *展示第一个时候，由源ImageView 放大呈现
 */
@property (assign, nonatomic) BOOL is_show_first;
@end
