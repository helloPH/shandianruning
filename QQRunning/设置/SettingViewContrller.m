//
//  SettingViewContrller.m
//  SJSD
//
//  Created by 软盟 on 16/4/27.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SettingViewContrller.h"
#import "SettingTableViewCell.h"
#import "CacheManager.h"
#import "ChangePasswordViewController.h"
//#import "TiXianZhangHuViewController.h"
#import "YiJianFanKuiViewController.h"
//#import "LoginViewController.h"
//#import "ChangJianWenTiViewControlle.h"
//#import "FuWuTiaoKuanViewController.h"
//#import "ShiYongXuZhiViewController.h"
#import "AboutUsViewController.h"
#import "TextContentViewController.h"
//#import "JPUSHService.h"

@interface SettingViewContrller ()<UITableViewDelegate,UITableViewDataSource,SettingTableViewCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *contentArray;

@property (nonatomic,strong) NSString *keFuPhone;
//@property (nonatomic,strong) NSMutableDictionary * verSionDic;
@end

@implementation SettingViewContrller
-(void)viewDidLoad
{
    [super viewDidLoad];
    _keFuPhone=@"";
    _contentArray = @[@"修改登录密码",@"关于我们",@"联系我们",@"意见反馈",@"保险说明",@"清除缓存",@"当前版本"];
    [self setupNewNavi];
    [self setupTableView];
    
    [self reshData];
}
-(void)reshData{
    NSDictionary * dic = @{@"Flag":@"2"};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getAppSetParamterWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            _keFuPhone = [NSString stringWithFormat:@"%@",model[@"Value"]];
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        };
        [_tableView reloadData];
        
    }];
    
    

    
//    dic =@{@"type":@"1"};
//    [AnalyzeObject getVersionWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
//        _verSionDic=[NSMutableDictionary dictionary];
//        
//        if (CODE(ret)) {
//            [_verSionDic addEntriesFromDictionary:model];
//        }else{
//            [CoreSVP showMessageInCenterWithMessage:msg];
//        }
//        [_tableView reloadData];
//    }];
}
-(void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height - self.NavImg.bottom )];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 90*self.scale)];
    view.backgroundColor = superBackgroundColor;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(RM_ButtonPadding, 20*self.scale, RM_VWidth - RM_ButtonPadding*2, RM_ButtonHeight)];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:whiteLineColore forState:UIControlStateNormal];
    button.backgroundColor = mainColor;
    button.titleLabel.font = Big15Font(self.scale);
    button.layer.cornerRadius = RM_CornerRadius;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(outLoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [_tableView setTableFooterView:view];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = whiteLineColore;
    CacheManager *cachemanager=[CacheManager defaultCacheManager];
    double cachesize=[cachemanager GetCacheSize];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSArray *Arr=@[@"",@"",@"",@"",@"",@"",@"",@"",[NSString stringWithFormat:@"%.2fM",cachesize],appVersion];
    cell.ValueLabel.text=Arr[indexPath.row];
    cell.ValueLabel.textColor = mainColor;
    cell.TitleLabel.text = _contentArray[indexPath.row];
    cell.RigthImage.hidden = NO;
//    if (indexPath.row == 1) {
//        cell.kaiGuan.hidden = NO;
//        cell.RigthImage.hidden = YES;
//        cell.delegate = self;
//        cell.indexPath = indexPath;
//        //        cell.kaiGuan.on=[Stockpile sharedStockpile].OnOrOff;
//    }
    if (indexPath.row==2) {
        cell.ValueLabel.text=_keFuPhone;
    }
    
    if (indexPath.row==5) {
        cell.ValueLabel.text=[NSString stringWithFormat:@"%.2fM",[cachemanager GetCacheSize]/1024.0];
    }
    if (indexPath.row == 6) {
        cell.RigthImage.hidden = YES;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
        //    // app名称
        //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        //    // app build版本
        //    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        cell.ValueLabel.text=[NSString stringWithFormat:@"V%@",app_Version];
        
    }
    cell.topLine.hidden = indexPath.row != 0;
    cell.shortLine.hidden = indexPath.row == self.contentArray.count - 1;
    cell.bottomLine.hidden = !cell.shortLine.hidden;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -- SettingTableViewCellDelegate
-(void)SettingTableViewCellSwitch:(BOOL)ONOrOFF IndexPath:(NSIndexPath *)indexPath
{
//    if (ONOrOFF) {
//        [[Stockpile sharedStockpile] setOnOrOff:YES];
//        NSString *bieMing = [NSString stringWithFormat:@"SD2_%@",[Stockpile sharedStockpile].ID];
//        [JPUSHService setTags:nil alias:bieMing fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//            NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
//        }];
//        [self ShowAlertWithMessage:@"消息推送功能已开启"];
//    } else {                                                                                                                                                                                                                                                                                      
//        [[Stockpile sharedStockpile] setOnOrOff:NO];
//        [JPUSHService setTags:nil
//                        alias:@""
//        fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//            
//            NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
//        }];
//        [self ShowAlertWithMessage:@"消息推送功能已关闭"];
//    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            {
                ChangePasswordViewController *changePasswordVC = [ChangePasswordViewController new];
                [self.navigationController pushViewController:changePasswordVC animated:YES];
                break;
            }
        case 1:
        {
            AboutUsViewController * about=[AboutUsViewController new];
            [self.navigationController pushViewController:about animated:YES];
            break;
        }
        case 2:
        {
       
            BOOL isSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_keFuPhone]]];
            if (!isSuccess) {
                //               [CoreSVP showMessageInCenterWithMessage:@"拨打电话失败"];
            }
            
        }
                break;
           
        case 3:
            {
                YiJianFanKuiViewController *yiJianVC = [YiJianFanKuiViewController new];
                [self.navigationController pushViewController:yiJianVC animated:YES];
                break;

            }
        case 4:
            
        {
            [self.navigationController pushViewController:[TextContentViewController insWithTitle:@"保险说明" parameter:@"9"] animated:YES];
//          [PHPopBox showAlertWithTitle:@"提示" message:@"保险说明" boxType:boxType1 buttons:@[[ControlStyle insWithTitle:@"确定" andColor:mainColor],[ControlStyle insWithTitle:@"取消" andColor:matchColor]] block:^(NSInteger index) {
//              
//          }];
//[PHPopBox showSheetWithButtonStyles:@[[ControlStyle insWithTitle:@"CONG" andColor:mainColor],[ControlStyle insWithTitle:@"取消" andColor:matchColor]] block:^(NSInteger index) {
//    
//}];
            break;
        }
        case 5:
            {
                //清空缓存
                [self ShowAlertTitle:nil Message:@"确定清除缓存?" Delegate:self OKText:@"确定" CancelText:@"取消" Block:^(NSInteger index) {
                    if (index==1) {
                        CacheManager *cacheManager = [CacheManager defaultCacheManager];
                        [cacheManager clearCache:^(BOOL success) {
                            [cacheManager clearCache:^(BOOL success) {
                                [_tableView reloadData];
                                [CoreSVP showMessageInCenterWithMessage:@"已全部清除完毕"];
                            }];
                        }];
                    }
                }];
                
                break;
                
            }
        case 6:
            {
                break;
            }
        case 7:
            {
                break;
            }
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*self.scale ;
}
-(void)outLoginButtonEvent:(UIButton *)button
{
    [self ShowAlertTitle:@"确定退出登录" Message:nil Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
            [[Stockpile sharedStockpile] setIsLogin:NO];
            [self.appdelegate OutLogin];
        }
    }];
    
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"系统设置";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
