//
//  YAboutViewController.m
//  shopsN
//
//  Created by imac on 2017/1/12.
//  Copyright © 2017年 联系QQ:1084356436. All rights reserved.
//

#import "YAboutViewController.h"

@interface YAboutViewController ()

@property (strong,nonatomic) UIImageView *QRIV;

@end

@implementation YAboutViewController

-(NSString *)compareVersion{
      NSString *checkUrl = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",iphoneAppID];
//    NSString *checkUrl = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=1192571504"];
    NSURL *check= [NSURL URLWithString:checkUrl];
    NSString *appinfo = [NSString stringWithContentsOfURL:check encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    NSData *JSONData = [appinfo dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:&error];
    if (!error&&info) {
        NSArray *result = info[@"results"];
        NSDictionary *dic =result.firstObject;
        NSString *version =dic[@"version"];
        NSString *downName = dic[@"trackViewUrl"];

        NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        if (!IsNilString(downName)) {
            return downName;
        }
    }
    return @"https://www.baidu.com";
}


-(void)getData{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = [self compareVersion];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];

    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];

    self.QRIV.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:120];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [SXLoadingView showProgressHUD:@""];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initView];
        });
    });
}


-(void)initView{
    //main
    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-221)/2, 90, 221, 49)];
    [self.view addSubview:loginIV];
    loginIV.image =MImage(@"loginLogo");
    loginIV.contentMode = UIViewContentModeScaleAspectFit;

    UILabel *versionLb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(loginIV)+20, __kWidth, 15)];
    [self.view addSubview:versionLb];
    versionLb.textAlignment = NSTextAlignmentCenter;
    versionLb.font = MFont(15);
    versionLb.textColor = __DTextColor;
    versionLb.text = [NSString stringWithFormat:@"iPhonev%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

    UIView *erV = [[UIView alloc]initWithFrame:CGRectMake((__kWidth-170)/2, CGRectYH(versionLb)+10, 170, 170)];
    [self.view addSubview:erV];
    erV.backgroundColor = [UIColor whiteColor];


    [erV addSubview:self.QRIV];

    UILabel *listLb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(erV)+20, __kWidth, 15)];
    [self.view addSubview:listLb];
    listLb.textAlignment = NSTextAlignmentCenter;
    listLb.font = MFont(15);
    listLb.textColor = __TextColor;
    listLb.text = [NSString stringWithFormat:@"扫描二维码，您的朋友也可以下载%@",ShortTitle];

    UILabel*rightLb =[[UILabel alloc]initWithFrame:CGRectMake(0, __kHeight-76, __kWidth, 16)];
    [self.view addSubview:rightLb];
    rightLb.textAlignment = NSTextAlignmentCenter;
    rightLb.textColor = __TextColor;
    rightLb.font = MFont(15);
    rightLb.text = @"Copyright @2016-2018";

    UILabel*right2Lb =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(rightLb)+7, __kWidth, 15)];
    [self.view addSubview:right2Lb];
    right2Lb.textAlignment = NSTextAlignmentCenter;
    right2Lb.textColor = __TextColor;
    right2Lb.font = MFont(14);
    right2Lb.text = [NSString stringWithFormat:@"%@版权所有",MainTitle];
    [SXLoadingView hideProgressHUD];
}

#pragma mark ==懒加载==
- (UIImageView *)QRIV {
    if (!_QRIV) {
        _QRIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 150, 150)];
    }
    return _QRIV;
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
