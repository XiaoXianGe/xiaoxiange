//
//  HCMAdvisoryViewController.m
//  haocaimao
//
//  Created by 好采猫 on 16/2/25.
//  Copyright © 2016年 haocaimao. All rights reserved.
//  我要咨询

#import "HCMAdvisoryViewController.h"
#import "AFNetworking.h"


@interface HCMAdvisoryViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property(strong,nonatomic)UIImageView *PhotosImageView;
@property(strong,nonatomic)UIImageView *PhotosImageViewOut;
@property(strong,nonatomic) UIButton *updateImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITextField *titleField;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property(strong ,nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet UILabel *hcmLable;
@property (strong, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UIButton *chackMoreBtn;

/** webView */
@property(nonatomic,strong)UIWebView * webView;
/** bgView */
@property(nonatomic,weak)UIView * bgView;
/** btnClose */
@property(nonatomic,weak)UIButton * btnClose;
/** bgBtn */
@property(nonatomic,weak)UIButton * bgBtn;


@property(assign,nonatomic) BOOL status;
@end

@implementation HCMAdvisoryViewController
-(NSUserDefaults *)defaults{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.contentTextView.delegate = self;
    
     self.status = [self.defaults boolForKey:@"status"];
    
    [self setUpPhotosImageViewAndButton];
    
    
}

- (IBAction)checkMoreGoods {
    
    [self.successView removeFromSuperview];
    self.titleField.text = nil;
    self.contentTextView.text = nil;
    
    [self.PhotosImageViewOut removeFromSuperview];
    [self.PhotosImageView removeFromSuperview];
    [self.updateImageBtn removeFromSuperview];
    
}

-(void)setupSuccessView{
    
    self.successView.frame = CGRectMake(0,50 , HCMScreenWidth, HCMScreenHeight - 50);
    [self.view addSubview:self.successView];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (text.length > 0) {
        self.hcmLable.hidden = YES;
    }
    
    return YES;
}


//提前创建图片区
-(void)setUpPhotosImageViewAndButton{
    
    _PhotosImageView = [[UIImageView alloc]init];
    _PhotosImageView.frame = CGRectMake((HCMScreenWidth-100)/2, 350, 100, 100);
    
    _PhotosImageViewOut = [[UIImageView alloc]init];
    _PhotosImageViewOut.frame = CGRectMake((HCMScreenWidth-140)/2, 331, 140, 140);
    [_PhotosImageViewOut setImage:[UIImage imageNamed:@"图片显示框"]];
    
    _updateImageBtn = [[UIButton alloc]init];
    _updateImageBtn.frame = CGRectMake((HCMScreenWidth-30)/2 + 60, 328, 30, 30);
    [_updateImageBtn addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    [_updateImageBtn setImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    
}

-(void)deleteImage{
    [self.PhotosImageViewOut removeFromSuperview];
    [self.PhotosImageView removeFromSuperview];
    [self.updateImageBtn removeFromSuperview];
}

- (IBAction)addPhoto {
    
    [self.view endEditing:YES];
     [self callActionSheetFunc];
    
}

//规则按钮
- (IBAction)clickTheRegulationButton:(UIButton *)sender {
    
    [SVProgressHUD show];
    
    [self loadWebViewWithHtmlStr:@"http://www.haocaimao.com/mobile/index.php?m=default&c=article&a=info&aid=12"];
    
}
-(void)loadWebViewWithHtmlStr:(NSString *)htmlStr
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(8, 66, HCMScreenWidth - 16, HCMScreenHeight - 106)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    UIButton *bgBtn = [[UIButton alloc]init];
    bgBtn.frame = CGRectMake(0, 0, HCMScreenWidth, HCMScreenHeight);
    [bgBtn addTarget:self action:@selector(touchUpWebViewHidden:) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn setBackgroundColor:HCMColor(222, 222, 222, 0.8)];
    self.bgBtn = bgBtn;
    [self.view addSubview:bgBtn];
    
    UIWebView *webVeiw = [[UIWebView alloc]initWithFrame:CGRectMake(10, 68, HCMScreenWidth - 20, HCMScreenHeight-110)];
    webVeiw.backgroundColor = [UIColor lightGrayColor];
//    webVeiw.scalesPageToFit = YES;  //是否支持放大缩小
    [webVeiw loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlStr]]];
    self.webView = webVeiw;
    [self.view addSubview:webVeiw];
    
    UIButton *btnClose = [[UIButton alloc]init];
    btnClose.frame = CGRectMake(HCMScreenWidth - 32, 58, 32, 32);
    [btnClose addTarget:self action:@selector(touchUpWebViewHidden:) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    self.btnClose = btnClose;
    [self.view addSubview:btnClose];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
}

-(void)touchUpWebViewHidden:(UIButton*)btn{
    
    [self.webView removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.bgBtn removeFromSuperview];
    [self.btnClose removeFromSuperview];

}
/**
 * 调用ActionSheet
 */
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择",  nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",  nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self gotoCameraOrLibrary:sourceType];
                    break;
                    
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self gotoCameraOrLibrary:sourceType];
                    break;
                    
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self gotoCameraOrLibrary:sourceType];
            }
        }
        
    }
}


// 跳转到相机或相册页面
-(void)gotoCameraOrLibrary:(UIImagePickerControllerSourceType)sourceType{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) return;

    UIImagePickerController *image = [[UIImagePickerController alloc] init];
    
    image.sourceType = sourceType;
    image.allowsEditing = YES;
    image.delegate = self;

    
    [self presentViewController:image animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.PhotosImageView.image = image;
    
    
    [self.view addSubview:self.PhotosImageViewOut];
    [self.view addSubview:self.PhotosImageView];
    [self.view addSubview:self.updateImageBtn];
    
}

/** 关闭 */
- (IBAction)closeTheView {
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/** 提交 */
- (IBAction)Networking {
    
    HCMLogFunc;
    
    if (!self.status) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    
    if (self.titleField.text.length<1) {
        [SVProgressHUD showInfoWithStatus:@"请填写手机号码"];
        return;
    }
    if (self.contentTextView.text.length<1) {
        [SVProgressHUD showInfoWithStatus:@"请填写内容"];
        return;
    }
    if (self.PhotosImageView.image == nil) {
        [SVProgressHUD showInfoWithStatus:@"请添加图片"];
        return;
    }
    
    
    
    // 创建警告框实例
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否立刻提交？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
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
    
    if ([title isEqualToString:@"取消"]) {
        
        
        
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
    // URL:http://www.haocaimao.com/ecmobile/?url=user/inquriePrice
    /**
     uid sid
     title
     content
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
    params[@"title"] = self.titleField.text;
    params[@"content"] = self.contentTextView.text;
    
    // 3.发送请求
    [mgr POST:@"http://www.haocaimao.com/ecmobile/?url=user/inquirePrice" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 拼接文件数据
        UIImage *image = self.PhotosImageView.image;
        
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        //NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.photosView.photos];
        
        [formData appendPartWithFileData:data name:@"licence" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        HCMLog(@"%@",responseObject);
        
        if ([responseObject[@"status"][@"error_desc"] isEqualToString:@"恭喜，操作成功"]) {
            
            [SVProgressHUD showSuccessWithStatus:responseObject[@"status"][@"error_desc"]];
            
            [self setupSuccessView];
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:responseObject[@"status"][@"error_desc"]];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络不畅通"];

    }];
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
