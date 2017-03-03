//
//  CellView.m
//  BaoJiaHuHang
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CellView.h"
#import "DefaultPageSource.h"
@interface CellView()
@property(nonatomic,assign) float scale;

@end
@implementation CellView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        _btn=[UIButton new];
        [self addSubview:_btn];
        
        self.backgroundColor=[UIColor whiteColor];
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, self.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
        _titleLabel.font=DefaultFont(self.scale);
        // _titleLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:_titleLabel];
        
        
    
        
        _contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right, _titleLabel.top, self.width - _titleLabel.right-10*self.scale, _titleLabel.height)];
        _contentLabel.font=DefaultFont(self.scale);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = blackTextColor;
        [self addSubview:_contentLabel];
        
        _RightImg=[[UIImageView alloc]init];
        _RightImg.image=[UIImage imageNamed:@"personal_jinru"];
        _RightImg.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:_RightImg];
        _RightImg.userInteractionEnabled=YES;
        
        _topline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _topline.hidden=YES;
        _topline.backgroundColor=blackLineColore;
        [self addSubview:_topline];
        
        _bottomline=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        //_bottomline.hidden=YES;
        _bottomline.backgroundColor=blackLineColore;
        [self addSubview:_bottomline];
        
    }
    return self;
}

-(void)jian{
    
    [self endEditing:YES];
}
-(void)setTitle:(NSString *)title{
    _titleLabel.text =title;
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    [self endEditing:YES];
//
//}

-(void)setContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_contentLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize cellsize = [content boundingRectWithSize:CGSizeMake(_contentLabel.width, 10000*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if (cellsize.height<=20) {
        cellsize.height =20;
    }
    _contentLabel.frame=CGRectMake(_titleLabel.right, _titleLabel.top, _contentLabel.width, cellsize.height);
    _contentLabel.numberOfLines=0;
    _contentLabel.text = content;
    self.size=CGSizeMake(self.width, cellsize.height+ _titleLabel.top*2);
}
-(void)layoutSubviews{
    _topline.frame=CGRectMake(0, 0, self.width, 0.5);
    if (_shotLine) {
        _bottomline.frame=CGRectMake(10*self.scale, self.height-0.5, self.width-20*self.scale, 0.5);
    }else{
        _bottomline.frame=CGRectMake(0, self.height-0.5, self.width, 0.5);
    }
    
    _btn.frame = CGRectMake(0, 0, self.width, self.height);
    
}
-(void)ShowRight:(BOOL)show{
    _RightImg.hidden =!show;
    _RightImg.frame=CGRectMake(self.width-25*self.scale,self.height/2-9*self.scale, 18*self.scale, 18*self.scale);
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object) {
        if ([keyPath isEqualToString:@"frame"] && [self isEqual:object]) {
            _titleLabel.frame =CGRectMake(10*self.scale, self.height/2-10*self.scale, 65*self.scale, 20*self.scale);
            float SetY=_titleLabel.height;
            if (_contentLabel.height>_titleLabel.height) {
                SetY=_contentLabel.height;
            }
            _contentLabel.frame=CGRectMake(_titleLabel.right, _titleLabel.top, self.width - _titleLabel.right-20*self.scale, SetY);
        }
    }
}
/**这两个协议只是针对和和寓项目  不用的话可以删除*/
-(void)deleteButtonEvent:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(CellViewDelegateDeleteButtonEvent:)]) {
        [_delegate CellViewDelegateDeleteButtonEvent:_index];
    }
}
-(void)stateButtonEvent:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(CellViewDelegateStateButtonEvent:)]) {
        [_delegate CellViewDelegateStateButtonEvent:_index];
    }
}
-(void)dealloc{
    // [self removeObserver:self  forKeyPath:@"frame"];
}
@end
