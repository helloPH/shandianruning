//
//  SuperTableViewCell.m
//  Wedding
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@implementation SuperTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _scale=RM_Scale;
    }
    return self;
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        _scale=RM_Scale;
    }
    return self;
}
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone{
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines=0;
    label.text=text;
    label.font=fone;
    [label sizeToFit];
    return label.size;
}
@end
