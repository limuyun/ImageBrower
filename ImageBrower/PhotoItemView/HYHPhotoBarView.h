//
//  TopBarView.h
//  ImgBrowerDemo
//
//  Created by limuyun on 16/6/23.
//  Copyright © 2016年 Biiway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYHPhotoTopBarDelegate <NSObject>

@optional
- (void)topBarOfBtnClickWithTemp:(NSInteger)temp;
@end

@interface HYHPhotoTopBarView : UIView

@property (strong, nonatomic) UILabel * titleLabel;
@property (assign, nonatomic) BOOL topBarHidden;

@property (weak, nonatomic) id <HYHPhotoTopBarDelegate> delegate;
- (id)initWithDel:(id)delegate;
@end



@protocol HYHPhotoBottomBarDelegate <NSObject>

@optional
- (void)bottomBarOfBtnClickWithTemp:(NSInteger)temp;
@end

@interface HYHPhotoBottomBarView : UIView
@property (strong, nonatomic) NSString * numText;
@property (assign, nonatomic) BOOL bottomBarHidden;
@property (weak, nonatomic) id <HYHPhotoBottomBarDelegate> delegate;
- (id)initWithDel:(id)delegate;
@end
