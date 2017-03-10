//
//  ShenFenRenZhengViewController.m
//  SJSD
//
//  Created by 软盟 on 16/4/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "ShenFenRenZhengViewController.h"
#import "CellView.h"
//#import "HelpTableViewCell.h"
//#import "QianDanLieBiaoViewController.h"
#import "LoginViewController.h"


#define headCellHeight 70*self.scale
#define photoCellHeight 120*self.scale
#define grayViewWidth 180*self.scale
#define grayViewHeight 200*self.scale
@interface ShenFenRenZhengViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIView *grayView;
@property (nonatomic,assign) BOOL isHeadImage;//判断是头像还是照片

@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,strong) NSString *headImageStr;



@property (nonatomic,strong) NSString *logo1;
@property (nonatomic,strong) NSString *logo2;
@property (nonatomic,strong) NSString *logo3;


@property (nonatomic,strong) UIScrollView * scrollView;
@end

@implementation ShenFenRenZhengViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = superBackgroundColor;
    _photoArray = [[NSMutableArray alloc] init];
    [self setupNewNavi];
    [self setupNewView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark -- 界面
-(void)setupNewView{
    float setY =  RM_Padding;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight-self.NavImg.height)];
    [self.view addSubview:_scrollView];
    
    
    CellView *headerCellView = [[CellView alloc] initWithFrame:CGRectMake(0, setY, RM_VWidth, 70*self.scale)];
    headerCellView.btn.hidden=YES;
    headerCellView.titleLabel.text = @"头像资料";
    headerCellView.titleLabel.frame = CGRectMake(RM_Padding, headerCellView.height/2 - 15*self.scale, headerCellView.width/2, 30*self.scale);
    headerCellView.topline.hidden = NO;
    headerCellView.bottomline.hidden = NO;
//    [headerCellView ShowRight:YES];
    [_scrollView addSubview:headerCellView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotoEvent:)];
    tap.numberOfTapsRequired = 1;
    [headerCellView addGestureRecognizer:tap];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( headerCellView.width-RM_Padding - 50*self.scale, headerCellView.height/2 - 25*self.scale, 50*self.scale, 50*self.scale)];
    headImageView.layer.cornerRadius = 25*self.scale;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.layer.borderWidth=2*self.scale;
    headImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    headImageView.clipsToBounds = YES;
    headImageView.tag = 20;
    [headImageView setImageWithURL:[NSURL URLWithString:[Stockpile sharedStockpile].userLogo] placeholderImage:[UIImage imageNamed:@"sy_touxiang"]];
    [headerCellView addSubview:headImageView];
    setY=headerCellView.bottom+RM_Padding;
    
    
    
    for (int i = 0; i < 2; i ++) {
        CellView *nameCellView = [[CellView alloc] initWithFrame:CGRectMake(0, setY, RM_VWidth, 40*self.scale)];
        nameCellView.titleLabel.text = i == 0 ? @"真实姓名" : @"身份证号";
        nameCellView.titleLabel.attributedText = [[NSString stringWithFormat:@"<black13>%@</black13><red13>*</red13>",i == 0 ? @"真实姓名" : @"身份证号"] attributedStringWithStyleBook:[self Style]];
        
//        self.Style
        
        
        nameCellView.topline.hidden = i == 1;
        [_scrollView addSubview:nameCellView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameCellView.titleLabel.right, 0, nameCellView.width - nameCellView.titleLabel.right - RM_Padding, nameCellView.height)];
        textField.placeholder = i == 0 ? @"请输入真实姓名" : @"请输入本人的身份证号";

        
        
        textField.font = DefaultFont(self.scale);
        textField.textColor = blackTextColor;
        [nameCellView addSubview:textField];
        setY = nameCellView.bottom;
        textField.tag = 10 + i;
        if (i == 0) {
            textField.keyboardType=UIKeyboardTypeDefault;
            [textField setMaxLength:RM_NameLength];
            [nameCellView setShotLine: YES];
        }else{
            textField.ry_inputType = RYIDCardInputType;
            [textField setMaxLength:RM_IDCardLength];
            [nameCellView setShotLine: NO];
        }
    }
    

    
    CellView *IDCardCellView = [[CellView alloc] initWithFrame:CGRectMake(0, setY + RM_Padding, RM_VWidth, 120*self.scale)];
    IDCardCellView.topline.hidden = NO;
    IDCardCellView.bottomline.hidden = NO;
    [_scrollView addSubview:IDCardCellView];
    
    
    CellView *label = [[CellView alloc] initWithFrame:CGRectMake(RM_Padding, RM_Padding, IDCardCellView.width - 2*RM_Padding, 30*self.scale)];
    label.title = @"请依据示例样式上传，保证照片清晰";
    label.bottomline.hidden=NO;
    label.shotLine=NO;
    label.titleLabel.font =DefaultFont(self.scale);
    label.titleLabel.textColor = mainColor;
    [label.titleLabel sizeToFit];
    label.titleLabel.left=0;
    [IDCardCellView addSubview:label];
    

    
    float blankWidth = 20*self.scale;
    float setX = RM_Padding;
    for ( int i = 0 ; i < 3; i ++) {
        UIButton *IDButton = [[UIButton alloc] initWithFrame:CGRectMake(setX, label.bottom + RM_Padding, 120/2.25*self.scale, 120/2.25*self.scale)];
        [IDButton setBackgroundImage:[UIImage imageNamed:@"upload photo"] forState:UIControlStateNormal];
        [IDButton setBackgroundImage:[UIImage imageNamed:@"upload photo"] forState:UIControlStateSelected];
        IDButton.tag = 1000 + i;
        [IDButton addTarget:self action:@selector(tuPianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [IDCardCellView addSubview:IDButton];
        setX = IDButton.right + blankWidth;
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(IDButton.right - 10*self.scale, IDButton.top - 10*self.scale, 20*self.scale, 20*self.scale)];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:13*self.scale];
        deleteButton.backgroundColor = redTextColor;
        deleteButton.layer.cornerRadius = deleteButton.width/2;
        deleteButton.clipsToBounds = YES;
        [deleteButton setTitle:@"X" forState:0];
        deleteButton.tag = 2000 + i;
        deleteButton.alpha = 0;
        [deleteButton addTarget:self action:@selector(shanChuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [IDCardCellView addSubview:deleteButton];
        if (i > 0) {
            IDButton.alpha = 0;
        }
    }
    [self setupBottomViewWithView:IDCardCellView];
}
-(void)setupBottomViewWithView:(UIView *)idCardCellView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, idCardCellView.bottom, RM_VWidth, 100*self.scale)];
    bgView.backgroundColor = clearColor;
    [_scrollView addSubview:bgView];
    
    UILabel *decLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, 0, RM_VWidth - 2*RM_Padding, 30*self.scale)];
    decLabel.attributedText = [[NSString stringWithFormat:@"<main13>* </main13><gray11>注：请参照下图依次上传身份证正面,反面,手持身份证正面</gray11>"] attributedStringWithStyleBook:[self Style]];
    [bgView addSubview:decLabel];
    //示例图片
    float blankWidth = (self.view.width - 180*self.scale/2.25*3)/4;
    float imageViewHeight = 110/2.25*self.scale;
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(blankWidth +(180*self.scale/2.25  + blankWidth) * i, decLabel.bottom, 180*self.scale/2.25, imageViewHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"shili_0%d",i + 1]];
        [bgView addSubview:imageView];
    }
    //提交按钮
    UIButton * tiJiaoButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_ButtonPadding, decLabel.bottom + imageViewHeight + 20*self.scale, RM_VWidth - 2*RM_ButtonPadding, RM_ButtonHeight)];
    [tiJiaoButton setTitle:@"提交" forState:0];
    tiJiaoButton.backgroundColor =  blackLineColore;
    tiJiaoButton.titleLabel.font = Big15Font(self.scale);
    [tiJiaoButton addTarget:self action:@selector(tiJiaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    tiJiaoButton.layer.cornerRadius = RM_CornerRadius;
    tiJiaoButton.clipsToBounds = YES;
    tiJiaoButton.userInteractionEnabled = NO;
    tiJiaoButton.tag = 30;
    [bgView addSubview:tiJiaoButton];
    bgView.height = tiJiaoButton.bottom;
    
    _scrollView.contentSize=CGSizeMake(RM_VWidth, bgView.bottom+RM_Padding);
}
-(void)ReshView{
    
    for (int i = 0; i<3; i++)
    {
        UIButton* paiZhaoBtn=(UIButton*)[self.view viewWithTag:1000+i];
        UIButton * delBtn=(UIButton*)[self.view viewWithTag:2000+i];
        if (i<_photoArray.count) {
            [paiZhaoBtn setBackgroundImage:[_photoArray objectAtIndex:i] forState:0];
            paiZhaoBtn.userInteractionEnabled = NO;
            paiZhaoBtn.alpha=1;
            delBtn.alpha=1;
        }else if(i== _photoArray.count){
            paiZhaoBtn.alpha=1;
            [paiZhaoBtn setBackgroundImage:[UIImage imageNamed:@"upload photo"] forState:UIControlStateNormal];
            [paiZhaoBtn setBackgroundImage:[UIImage imageNamed:@"upload photo"] forState:UIControlStateSelected];
            paiZhaoBtn.userInteractionEnabled = YES;
            delBtn.alpha=0;
        }else{
            paiZhaoBtn.alpha=0;
            delBtn.alpha=0;
        }
    }
}

#pragma mark -- 点击事件
- (void)tuPianBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    _selectButton = btn;
    if (_photoArray.count > 3) {
        return ;
    }
    [self takePhotoEvent:nil];
}
- (void)shanChuBtnClick:(UIButton *)btn{
    [_photoArray removeObjectAtIndex:btn.tag - 2000];
    [self ReshView];
}
-(void)tiJiaoBtnClick
{
//    _headImageStr = [UIImageJPEGRepresentation(<#UIImage * _Nonnull image#>, <#CGFloat compressionQuality#>)]
    
    for (int i = 0; i < _photoArray.count; i ++) {
        
        NSData *date = UIImageJPEGRepresentation(_photoArray[i], .5);
        
        switch (i) {
            case 0:{
                
                _logo1 = [date base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
                break;
            case 1:{
                
                _logo2 = [date base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
                break;
            case 2:{
                _logo3 = [date base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    
    //姓名
    UITextField *nameTextField = [self.view viewWithTag:10];
    NSString *name = [nameTextField.text trimString];
    //身份证号
    UITextField *idCardNumTextField = [self.view viewWithTag:11];
    NSString *idCard = [idCardNumTextField.text trimString];
    
    if (_headImageStr.length == 0) {
        [CoreSVP showMessageInCenterWithMessage:@"请上传您的头像"];
        return;
    }
    
    if (name.length == 0) {
        [CoreSVP showMessageInCenterWithMessage:@"请输入您的姓名"];
        return;
    }
    if (![idCard isValidateIdentityCard]) {
        [CoreSVP showMessageInCenterWithMessage:@"请输入正确的身份证号"];
        return;
    }
    if (_logo1.length == 0 || _logo2.length == 0 || _logo3.length == 0) {
        [CoreSVP showMessageInCenterWithMessage:@"请上传您的照片"];
        return;
    }
    
     NSDictionary * dic=@{@"PeiSongId":[Stockpile sharedStockpile].userID,
                         @"Name":name,
                         @"IdCarNum":idCard,
                         @"Image1":_headImageStr,
                         @"Image2":_logo1,
                         @"Image3":_logo2,
                         @"Image4":_logo3,
                         };

    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject commitPeiSongDataWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            if (_biaoJi == 0) { // 注册界面过来的
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            if (_biaoJi == 1) { // 首页过来的
                LoginViewController * login = [LoginViewController new];
                
                UINavigationController * navi =[[UINavigationController alloc]initWithRootViewController:login];
                [self presentViewController:navi animated:YES completion:^{
                }];
                //        [self dismissViewControllerAnimated:YES completion:nil];
            }
            [[Stockpile sharedStockpile]setIsLogin:NO];
//            LoginViewController * login = [LoginViewController new];
//            [self.navigationController pushViewController:login animated:YES];
        }else{
            
        }
        [CoreSVP showMessageInCenterWithMessage:msg];
    }];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark -- 选择照片
-(void)takePhotoEvent:(UITapGestureRecognizer *)tap{
    
    if (tap) {
        _isHeadImage = YES;
    }else{
        _isHeadImage = NO;
    }
    
    [PHPopBox showSheetWithButtonStyles:@[[ControlStyle insWithTitle:@"从手机相册中选取" andColor:nil],[ControlStyle insWithTitle:@"相机" andColor:nil]] block:^(NSInteger index) {
        if (index==0) {//  相册
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];

        }
        if (index==1) {// 相机
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                //            imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImage = nil;
    if (_isHeadImage) {
        newImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:20];
        imageView.image = newImage;
        NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
        NSString *base64Image = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        _headImageStr = base64Image;
    }
    else
    {
        newImage=[self imageWithImageSimple:image scaledToSize:CGSizeMake(600, 600)];
        
        switch (_selectButton.tag) {
            case 1000:
                [_photoArray insertObject:newImage atIndex:0];
                break;
            case 1001:
                [_photoArray insertObject:newImage atIndex:1];
                break;
            case 1002:
                [_photoArray insertObject:newImage atIndex:2];
                break;
            default:
                break;
        }
        [self ReshView];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize
{
    newSize.height = image.size.height * (newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}




- (void)setImgBtn{
    
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [self.view viewWithTag:1000 + i];
        UIButton *shanChuBtn = [self.view viewWithTag:2000 + i];
        btn.alpha = 0;
        shanChuBtn.alpha = 0;
        if (i < _photoArray.count) {
            [btn setBackgroundImage:_photoArray[i] forState:0];
            btn.userInteractionEnabled = NO;
            btn.alpha = 1;
            shanChuBtn.alpha = 1;
        }else if (i ==  _photoArray.count){
            btn.alpha = 1;
            [btn setBackgroundImage:[UIImage imageNamed:@"dl11_"] forState:0];
            btn.userInteractionEnabled = YES;
        }else{
            btn.alpha = 0;
            shanChuBtn.alpha = 0;
        }
    }
}
-(void)shangChuanTouXiang:(UIButton *)sender
{
    NSLog(@"上传头像");
}
#pragma mark -- 通知
-(void)TextFieldChange{
    //姓名
    UITextField *nameTextField = [self.view viewWithTag:10];
    NSString *name = [nameTextField.text trimString];
    //身份证号
    UITextField *idCardNumTextField = [self.view viewWithTag:11];
    NSString *idCard = [idCardNumTextField.text trimString];

    UIButton *tiJiaoButton = (UIButton *)[self.view viewWithTag:30];
    if (name.length > 0 && idCard.length > 0) {
        tiJiaoButton.backgroundColor = mainColor;
        tiJiaoButton.userInteractionEnabled = YES;
    }else{
        tiJiaoButton.backgroundColor = blackLineColore;
        tiJiaoButton.userInteractionEnabled = NO;
    }
    

}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"提交资料";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
}
-(void)PopVC
{
    if (_block) {
        _block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
