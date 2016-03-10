//
//  HCMBusinessViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMBusinessViewController.h"
#import "HCMBusinessPhotoView.h"
#import "AFNetworking.h"



@interface HCMBusinessViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *businessName;
@property (weak, nonatomic) IBOutlet UITextView *businessInfo;

@property(strong ,nonatomic) NSUserDefaults *defaults;

@property(strong,nonatomic)UIImageView *PhotosImageView;
@property(strong,nonatomic) UIButton *updateImageBtn;

@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@end

@implementation HCMBusinessViewController

-(NSUserDefaults *)defaults{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业申请";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self setUpPhotosImageViewAndButton];
}

//提前创建图片区
-(void)setUpPhotosImageViewAndButton{
    
    self.PhotosImageView = [[UIImageView alloc]init];
    _PhotosImageView.frame = CGRectMake(15, 300, 120, 120);
    
    self.updateImageBtn = [[UIButton alloc]init];
    _updateImageBtn.frame = CGRectMake(110, 295, 30, 30);
    [_updateImageBtn addTarget:self action:@selector(updateImage:) forControlEvents:UIControlEventTouchUpInside];
    [_updateImageBtn setImage:[UIImage imageNamed:@"iconfont-gengxin"] forState:UIControlStateNormal];
    
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.businessName resignFirstResponder];
    [self.businessInfo resignFirstResponder];
}

- (IBAction)addPhotos {
    [self openAlbum];
}

//打开相机
//- (void)openCamera
//{
//    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
//}

//打开相册
- (void)openAlbum
{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    //UIImagePickerControllerSourceTypeCamera
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    
}





- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    ipc.sourceType = type;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 存储图片
    //    [_photos addObject:photo];
    //[self.photosView addPhoto:image];
    
    [self setUpDeleteBtn:image];
}


-(void)setUpDeleteBtn:(UIImage *)image{
    _PhotosImageView.image = image;
    self.addImageBtn.hidden = YES;
    [self.view addSubview:_PhotosImageView];
    [self.view addSubview:_updateImageBtn];
    
}

-(void)updateImage:(UIButton *)btn{
    [self.PhotosImageView removeFromSuperview];
    
}

- (IBAction)send {
    
    if (self.businessName.text.length<1) {
        [SVProgressHUD showInfoWithStatus:@"尚未填写公司名称"];
        return;
    }
    if (self.businessInfo.text.length<1) {
        [SVProgressHUD showInfoWithStatus:@"尚未填写公司简介"];
        return;
    }
    if (self.PhotosImageView.image == nil) {
        [SVProgressHUD showInfoWithStatus:@"尚未添加图片"];
        return;
    }
    
    
    // 创建警告框实例
    //  3.设置self为alertView的代理方
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否立刻提交？" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES",nil];
    //设置alertview的样式
    // alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    // 显示警告框
    [alert show];
    
    
}

//第一个参数：代表委托方自己
//第二个参数：委托方发给代理方的一些重要信息
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //根据点击的按钮的index，获取这个按钮的标题
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Cancel"]) {
        
    } else{
        
        [SVProgressHUD showWithStatus:@"上传中"];
        [self sendWithImage];
        
    }
}


/**
 * 发布带有图片的
 */
- (void)sendWithImage
{
    // URL:http://www.haocaimao.com/ecmobile/?url=user/enterpriseApply
    /**
     uid sid
     name
     profile
     licence
     
     接口：user/enterpriseApply。
     */
    /**	*/
    /**	pic 图。*/
    
    NSString *sid = [self.defaults objectForKey:@"sid"];
    NSString *uid = [self.defaults objectForKey:@"uid"];
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    // mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"session"] = @{@"uid":uid,@"sid":sid};
    params[@"name"] = self.businessName.text;
    params[@"profile"] = self.businessInfo.text;
    
    // 3.发送请求
    [mgr POST:@"http://www.haocaimao.com/ecmobile/?url=user/enterpriseApply" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 拼接文件数据
        UIImage *image = self.PhotosImageView.image;
    
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        //NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.photosView.photos];
        
        [formData appendPartWithFileData:data name:@"licence" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
        
        if (responseObject[@"status"][@"error_code"]) {
            
            [SVProgressHUD showSuccessWithStatus:responseObject[@"status"][@"error_desc"]];
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:responseObject[@"status"][@"error_desc"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络不畅通"];
    }];
    
    
}

@end
