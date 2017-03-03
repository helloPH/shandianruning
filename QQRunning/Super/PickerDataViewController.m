//
//  PickerDataViewController.m
//  MeiYanShop
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PickerDataViewController.h"
#import "CellView.h"
@interface PickerDataViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIPickerView *datePicker;

@property (nonatomic,strong)PickerDataBlock block;
@property (nonatomic,strong)PickerDataDicBlock dblock;
@property (nonatomic,strong)PickerDataArrBlock ablock;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)id Class;
@end

@implementation PickerDataViewController
-(void)getPickerArrData:(NSArray *)data Block:(PickerDataArrBlock)block{
    _dataSource=[NSMutableArray new];
    [_dataSource addObjectsFromArray:data];
    _ablock=block;
    _block = nil;
    _dblock=nil;
    [_datePicker reloadAllComponents];
}
- (void)getPickerDate:(NSArray *)data Block:(PickerDataBlock)block{
    _dataSource=[NSMutableArray new];
    [_dataSource addObjectsFromArray:data];
    _block = block;
    _dblock=nil;
    [_datePicker reloadAllComponents];
}
- (void)getPickerDicDate:(NSArray *)data Class:(id)Class Block:(PickerDataDicBlock)block{
    _dataSource=[NSMutableArray new];
    [_dataSource addObjectsFromArray:data];
    _dblock = block;
    _block=nil;
    _Class=Class;
    [_datePicker reloadAllComponents];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.NavImg.alpha = 0;
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [self newPickerV];
    [self newBtn];
}
- (void)newBtn{
    
  /*  UILabel *qingChuL = [[UILabel     alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44*self.scale)];
    qingChuL.text = @"清除已选";
    qingChuL.textColor = [UIColor grayColor];
    qingChuL.backgroundColor = [UIColor clearColor];
    qingChuL.textAlignment = 1;
    qingChuL.font = [UIFont systemFontOfSize:12*self.scale];
    
    [self.view addSubview:qingChuL];*/
    
    CellView *cell=[[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44*self.scale)];
    cell.topline.hidden=NO;
    [self.view addSubview:cell];
    
    
    UIButton *quXiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quXiaoBtn.frame = CGRectMake(0,0  , 60*self.scale, 44*self.scale);
    [quXiaoBtn setTitle:@"取消" forState:0];
    [quXiaoBtn setTitleColor:grayTextColor forState:0];
    quXiaoBtn.tag = 1;
    [quXiaoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    quXiaoBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13*self.scale];
    [cell addSubview:quXiaoBtn];
    
    UIButton *queDingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queDingBtn.frame = CGRectMake(self.view.width - 60*self.scale,0, 60*self.scale, 44*self.scale);
    [queDingBtn setTitle:@"确定" forState:0];
    [queDingBtn setTitleColor:orangeTextColor forState:0];
    queDingBtn.tag = 2;
    [queDingBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    queDingBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13*self.scale];
    [cell addSubview:queDingBtn];
    
    
   /* UIImageView *hxImg  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.width, .5)];
    hxImg.backgroundColor  = blackLineColore;
    [self.view addSubview:hxImg];
    
    UIImageView *hxImg1  = [[UIImageView alloc] initWithFrame:CGRectMake(0,queDingBtn.bottom - .5, self.view.width, .5)];
    hxImg1.backgroundColor  = blackLineColore;
    [self.view addSubview:hxImg1];*/
    
    
    
}

- (void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 1) {
        if (_block) {
              _block(@"");
        }
        if (_dblock) {
            _dblock(nil);
        }
      
    }else{
        if (_block) {
            NSString *result=[_dataSource objectAtIndex:[_datePicker selectedRowInComponent:0]];
            _block(result);
        }
        if (_dblock) {
            NSDictionary *dic =[_dataSource objectAtIndex:[_datePicker selectedRowInComponent:0]];
             _dblock(dic);
        }
        if (_ablock) {
            NSMutableArray *Arr=[[NSMutableArray alloc]init];
            for (int i=0; i<_dataSource.count; i++)
            {
                NSArray *resultArr=[_dataSource objectAtIndex:i];
              //  NSString *result=[resultArr objectAtIndex:[_datePicker selectedRowInComponent:i]];
                [Arr addObject:[resultArr objectAtIndex:[_datePicker selectedRowInComponent:i]]];
            }

            _ablock(Arr);

        }
       
    }
    
}
- (void)newPickerV{
    _datePicker=[[ UIPickerView alloc] initWithFrame:CGRectMake(0, 44*self.scale, self.view.width, 437*self.scale/2.25)];
      _datePicker.delegate = self;
   _datePicker.dataSource = self;
    _datePicker.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_datePicker];
}
#pragma mark PickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_ablock) {
        return [_dataSource count];
    }
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_ablock) {
        return [[_dataSource objectAtIndex:component] count];
    }
    return _dataSource.count;
}
/*-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        //CGRect frame = CGRectMake(0.0, 0.0, 100, 60*self.scale);
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:Big15Font(self.scale)];
    }
    pickerLabel.text =[self pickerView:pickerView titleForRow:row forComponent:component];
    //[NSString stringWithFormat:@"%@",[_dataSource objectAtIndex:row]];
    return pickerLabel;
}*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_dblock) {
        NSDictionary *dic = [_dataSource objectAtIndex:row];
        return [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }
    if (_ablock) {
        NSDictionary *dic =[[_dataSource objectAtIndex:component] objectAtIndex:row];
        return [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }
    return [NSString stringWithFormat:@"%@",[_dataSource objectAtIndex:row]];
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
