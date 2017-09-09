//
//  MMCalendarDateModel.h
//  rili
//
//  Created by 郭民民 on 2017/9/9.
//  Copyright © 2017年 minmin. All rights reserved.
#warning   不能当作时间Model

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MMCalendarCompareResult) {
    MMCalendarCompareResultBefore,//之前
    MMCalendarCompareResultNow,//现在
    MMCalendarCompareResultfuture//以后
};


@interface MMCalendarDateModel : NSObject

@property (nonatomic ,assign) NSInteger day;//日
@property (nonatomic ,assign) NSInteger month;//月
@property (nonatomic ,assign) NSInteger year;//年
@property (nonatomic ,assign) NSInteger weekday;//周几
@property (nonatomic ,assign) NSInteger mouthdays;//这个月多少天
@property (nonatomic ,assign) NSInteger lastMouthDay;//上个月多少天

/**
 *  创建Model 方式
 */
+(instancetype)MMGreateModelWithWeekday:(NSInteger)weekday andMouthDays:(NSInteger )mouthdays andLastMouthDays:(NSInteger)lastMouthDay andDay:(NSInteger)day andMonth:(NSInteger)month andYear:(NSInteger)year;
/**
 *  gap参数说明: 0 当前。  >0 代表时间往后 <0 代表时间往前 只做年月日修改
 */
-(void)mmChangeDayWithGap:(NSInteger)gap;
/**
 *  比较两个Model 天数的大小  只比较日月年
 */
+(MMCalendarCompareResult)mmCompareTwoDay:(MMCalendarDateModel *)model1 andOtherDay:(MMCalendarDateModel *)model2;

@end
