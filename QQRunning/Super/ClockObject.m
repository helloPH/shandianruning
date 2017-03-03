//
//  ClockObject.m
//  Super
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ClockObject.h"
#import "NSString+Helper.h"
static ClockObject * _sharedInstance = nil;

@implementation ClockObject
+(ClockObject *)defaultClockObject{
    @synchronized ([ClockObject class]) {
        if (!_sharedInstance) {
            _sharedInstance=[[super alloc] init];
        }
        return _sharedInstance;
    }
        return nil;
}
-(void)setBeginTimeWithEndTimeIntercal:(NSTimeInterval)endTimeIntercal complete:(ClockBlock)block{
    _block=block;
    _endTimeIntercal=endTimeIntercal;
}
-(void)setTimeIntercal:(NSTimeInterval)timeIntercal{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    _timeIntercal=timeIntercal;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startOneOffTimer) userInfo:nil repeats:YES];
}
-(void)startOneOffTimer{
    _timeIntercal++;
    NSDate *data=[NSDate dateWithTimeIntervalSince1970:_timeIntercal];
    NSDate *enddata=[NSDate dateWithTimeIntervalSince1970:_endTimeIntercal];
    NSInteger shijiancha= [enddata timeIntervalSinceDate:data];
    NSString *result=  [NSString TimeformatFromSeconds:shijiancha];
    if (shijiancha<=0) {
        result=@"00:00:00";
    }
    if (_block) {
        _block(result);
    }
}
@end
