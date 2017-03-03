//
//  UIButton+Helper.m
//  GeXiaZi
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIButton+Helper.h"



@implementation UIButton(Helper)
/**
 *  按钮上的图片跟文字，居中对齐
 */
-(void)TiaoZhengButtonWithOffsit:(CGFloat)offset TextImageSite:(UIButtonTextSite)site{
    if (site==UIButtonTextLeft) {
        [self TextImageLeftWithOffsit:offset];
    } else if (site==UIButtonTextTop) {
        [self TextImageTopWithOffsit:offset];
    } else  if (site==UIButtonTextBottom) {
        [self TextImageBottomWithOffsit:offset];
    }else{
        
        [self TextImageRightWithOffsit:offset];
    }
}
/**
 *  文字在右边，图片在左边，居中对齐
 *
 *  @param offset 文字跟图片间的间距大小
 */
-(void)TextImageRightWithOffsit:(CGFloat)offset{
    
    CGFloat offsetBetweenImageAndText = offset;
    CGFloat insetAmount = offsetBetweenImageAndText / 2.0;
    self.imageEdgeInsets = UIEdgeInsetsMake(0,-insetAmount, 0,insetAmount);
    self.titleEdgeInsets = UIEdgeInsetsMake(0,insetAmount, 0, -insetAmount);
    self.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
}
/**
 *  文字在左边，图片在右边，居中对齐
 *
 *  @param offset 文字跟图片间的间距大小
 */
-(void)TextImageLeftWithOffsit:(CGFloat)offset{
    CGFloat imgW=self.imageView.frame.size.width;
    CGFloat titleW=self.titleLabel.frame.size.width;
    CGFloat offsetBetweenImageAndText = offset;
    CGFloat insetAmount = offsetBetweenImageAndText / 2.0;
    self.imageEdgeInsets = UIEdgeInsetsMake(0,titleW+insetAmount, 0,-titleW-insetAmount);
    self.titleEdgeInsets = UIEdgeInsetsMake(0,-imgW-insetAmount, 0, imgW+insetAmount);
    self.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
}
/**
 *  文字在下边，图片在上边，居中对齐
 *
 *  @param offset 文字跟图片间的间距大小
 */
-(void)TextImageBottomWithOffsit:(CGFloat)offset{
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(self.imageView.bounds));
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(self.bounds)-CGRectGetMidY(self.titleLabel.bounds));
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    // 设置imageEdgeInsets
    CGFloat imgH=self.imageView.frame.size.height/2;
    CGFloat titleH=self.titleLabel.frame.size.height/2;
    CGFloat offsetBetweenImageAndText = offset;
    CGFloat insetAmount = offsetBetweenImageAndText / 2.0;
    
    CGFloat imageEdgeInsetsTop = -titleH-insetAmount;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = imgH+insetAmount;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}
/**
 *  文字在上边，图片在下边，居中对齐
 *
 *  @param offset 文字跟图片间的间距大小
 */
-(void)TextImageTopWithOffsit:(CGFloat)offset{
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(self.imageView.bounds));
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(self.bounds)-CGRectGetMidY(self.titleLabel.bounds));
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    // 设置imageEdgeInsets
    CGFloat imgH=self.imageView.frame.size.height/2;
    CGFloat titleH=self.titleLabel.frame.size.height/2;
    CGFloat offsetBetweenImageAndText = offset;
    CGFloat insetAmount = offsetBetweenImageAndText / 2.0;
    
    CGFloat imageEdgeInsetsTop = titleH+insetAmount;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = -imgH-insetAmount;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}
#pragma mark - 获取验证码倒计时

NSTimer *_timer;
NSInteger timeout1;
-(void)StartMsgCodeTimeDown
{
//    NSTimer *_timer;
//    NSInteger timeout;
    timeout1 = MsgCodeTime;
    [self setTitle:[NSString stringWithFormat:@"%@秒后重发",@(timeout1)] forState:UIControlStateDisabled];
      self.enabled=NO;
    _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeji) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}
-(void)timeji
{
//    NSTimer *_timer;
//    NSInteger timeout;
     timeout1--;
    if (timeout1 <= 0) {
        [_timer invalidate];
        _timer = nil;
        self.enabled=YES;
    }else {
        [self setTitle:[NSString stringWithFormat:@"%@秒后重发",@(timeout1)] forState:UIControlStateDisabled];
        self.enabled = NO;
    }
}
-(void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
