//
//  MMCalendarDateModel.m
//  rili
//
//  Created by 郭民民 on 2017/9/9.
//  Copyright © 2017年 minmin. All rights reserved.
//

#import "MMCalendarDateModel.h"

@implementation MMCalendarDateModel

+(instancetype)MMGreateModelWithWeekday:(NSInteger )weekday andMouthDays:(NSInteger )mouthdays andLastMouthDays:(NSInteger)lastMouthDay andDay:(NSInteger)day andMonth:(NSInteger)month andYear:(NSInteger)year{
    MMCalendarDateModel *model = [[MMCalendarDateModel alloc] init];
    model.weekday = weekday - 1;
    
    model.mouthdays = mouthdays;
    model.lastMouthDay = lastMouthDay;
    
    model.day = day;
    model.month = month;
    model.year = year;
    
    
    return model;
}

// gap参数说明 0 当前。  >0 代表时间往后 <0 代表时间往前  只做年月日修改
-(void)mmChangeDayWithGap:(NSInteger)gap{
    self.day = _day + gap;
    if (self.day < 1) {
        self.day += _lastMouthDay;
        
        if (_month == 1) {
            _month = 12;
            _year -= 1;
        }
        _month -= 1;
    }else if(self.day > _mouthdays){
        self.day -= _mouthdays;
        if (_month == 12) {
            _month = 1;
            _year += 1;
        }
         _month += 1;
    }
    
    _weekday = (_weekday + gap) % 7;
    
}

// 比较两个Model 天数的大小  只比较日月年
+(MMCalendarCompareResult)mmCompareTwoDay:(MMCalendarDateModel *)model1 andOtherDay:(MMCalendarDateModel *)model2{
    BOOL ret;
    
    if (model1.year != model2.year) {//比年
        ret = model1.year > model2.year;
    }else if(model1.month != model2.month){//比月
        ret = model1.month > model2.month;
    }else if(model1.day != model2.day){// 比日
        ret = model1.day > model2.day;
    }else{
        return MMCalendarCompareResultNow;
    }
    
    if (ret) {
        return MMCalendarCompareResultBefore;
    }else{
        return MMCalendarCompareResultfuture;
    }
}


@end
