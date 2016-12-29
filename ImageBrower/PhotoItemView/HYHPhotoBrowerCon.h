//
//  PhotoBrowerCon.h
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/23.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHPhoto.h"
typedef NS_ENUM(NSInteger, HyhPhotoBrowserType) {
    HyhPhotoBrowserTypePush,
    HyhPhotoBrowserTypeModel,
    HyhPhotoBrowserTypeNormal,
};
@interface HYHPhotoBrowerCon : UIViewController
/**
 *所有图片对象,单个元素为 HYHPhoto;
 */
@property (strong, nonatomic) NSArray * hyhPhotos;
/**
 *展示当前图片索引，default is 0;
 */
@property (assign, nonatomic) NSInteger currentPhotoIndex;

- (void)showCon:(UIViewController *)con browserPhotoType:(HyhPhotoBrowserType)browserPhotoType;
@end
