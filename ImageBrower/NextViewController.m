//
//  NextViewController.m
//  ImageBrower
//
//  Created by limuyun on 2016/12/29.
//  Copyright © 2016年 biiway. All rights reserved.
//

#import "NextViewController.h"
#import "HYHPreview.h"
#import "HYHPhotoBrowerCon.h"
#define IMAGE_WITH_NAME(__NAME) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:__NAME]]
@interface NextViewController ()
@property (strong, nonatomic) NSMutableArray * photoList;
@end

@implementation NextViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _photoList = [[NSMutableArray alloc] init];
        UIBarButtonItem * item0 = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStylePlain target:self action:@selector(show:)];
        self.navigationItem.rightBarButtonItem = item0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Home";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    // Do any additional setup after loading the view.
    NSArray * imageNameList = @[@"ad1.png",@"ad2.png",@"ad3.png"];
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < imageNameList.count; i ++) {
        NSString * imageName = imageNameList[i];
        HYHPhoto * photo = [[HYHPhoto alloc] init];
        photo.image = IMAGE_WITH_NAME(imageName);
        [array addObject:photo];
    }
    NSArray *networkImages=@[@"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
                             @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
                             @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
                             @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
                             @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
                             @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
                             @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
                             @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
                             @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg",
                             @"http://cdn.duitang.com/uploads/item/201401/24/20140124210003_4Z2iC.jpeg",
                             @"http://img5.duitang.com/uploads/item/201405/19/20140519200749_hRfn2.jpeg"
                             ];
    for (int i = 0 ; i < networkImages.count; i ++) {
        HYHPhoto * photo = [[HYHPhoto alloc] init];
        photo.url = networkImages[i];
        [_photoList addObject:photo];
    }
    
    HYHPreview * view = [[HYHPreview alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) Del:self];
    view.hyhPhotos = _photoList;
    view.showPhotoBrowerCon = YES;
    view.autoScoroll = YES;
    [self.view addSubview:view];
    
}
#pragma mark --<HYHPreviewDelegate> method
- (void)hyhPreview:(HYHPreview *)hyhPreview  selectIndex:(NSInteger)index {
    NSLog(@"tap index : %@",[NSNumber numberWithInteger:index+1]);
}
- (void)show:(id)sender {
    HYHPhotoBrowerCon * con = [[HYHPhotoBrowerCon alloc] init];
    con.hyhPhotos = _photoList;
    con.currentPhotoIndex = 0;
    [con showCon:self browserPhotoType:HyhPhotoBrowserTypeModel];
}

@end
