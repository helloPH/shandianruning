//
//  PickerDataViewController.h
//  MeiYanShop
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^PickerDataBlock)(NSString *pickerstr);
typedef void(^PickerDataDicBlock)(NSDictionary *pickerstr);
typedef void(^PickerDataArrBlock)(NSArray *PickArr);
@interface PickerDataViewController : SuperViewController
- (void)getPickerDate:(NSArray *)data Block:(PickerDataBlock)block;
- (void)getPickerDicDate:(NSArray *)data Class:(id)Class Block:(PickerDataDicBlock)block;

-(void)getPickerArrData:(NSArray *)data Block:(PickerDataArrBlock)block;
@end
