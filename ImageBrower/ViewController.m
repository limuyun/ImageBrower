//
//  ViewController.m
//  ImageBrower
//
//  Created by limuyun on 2016/12/29.
//  Copyright © 2016年 biiway. All rights reserved.
//

#import "ViewController.h"
#import "HYHPhotoBrowerCon.h"
#import "UIImageView+WebCache.h"
#import "UAProgressView.h"
#import "NextViewController.h"
#define IMAGE_WITH_NAME(__NAME) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:__NAME]]
@interface ViewController () {
    NSMutableArray * _imageViewList;
    NSArray * _networkImages;
    
    UIView * _customView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageViewList = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    UIBarButtonItem * item0 = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(one:)];
    self.navigationItem.rightBarButtonItem = item0;
    [self userInterface];
}
- (void)one:(id)sender {
    NextViewController * con = [[NextViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}
- (void)userInterface {
    _networkImages = @[@"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
                       @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
                       @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
                       @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
                       @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
                       @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
                       @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
                       @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
                       @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg",
                       @"http://cdn.duitang.com/uploads/item/201401/24/20140124210003_4Z2iC.jpeg",
                       @"http://img5.duitang.com/uploads/item/201405/19/20140519200749_hRfn2.jpeg"];
    CGFloat imageWidth = ([UIScreen mainScreen].bounds.size.width - 30)/2.0;
    CGFloat imageHeight = imageWidth*9/16.0;
    for (int i = 0 ; i < 6; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(10+imageWidth)*(i%2),10+(10+imageHeight)*(i/2), imageWidth, imageHeight)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_networkImages[i]]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [self.view addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [imageView addGestureRecognizer:tap];
        [_imageViewList addObject:imageView];
    }
}
- (void)imageTap:(UITapGestureRecognizer *)tap {
    UIImageView * imageView = (UIImageView *)tap.view;
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < _networkImages.count; i ++) {
        HYHPhoto * photo = [[HYHPhoto alloc] init];
        photo.url = _networkImages[i];
        if (i < 6) {
            photo.sourceImageView = _imageViewList[i];
        }
        [array addObject:photo];
    }
    HYHPhotoBrowerCon * con = [[HYHPhotoBrowerCon alloc] init];
    con.hyhPhotos = array;
    con.currentPhotoIndex = imageView.tag;
    [con showCon:self browserPhotoType:HyhPhotoBrowserTypeNormal];
}
@end
