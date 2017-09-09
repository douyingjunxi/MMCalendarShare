//
//  MMCalendarMoreSelectVIew.h
//  rili
//
//  Created by 郭民民 on 2017/9/8.
//  Copyright © 2017年 minmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCalendarDateModel.h"

@interface MMCalendarMoreSelectView : UIView
/**
 *  创建MMCalendarMoreSelectVIew 方式
 */
+(instancetype)MMCreateCalendarMoreSelectViewWithFrame:(CGRect)frame andCallBack:(void(^)(NSDictionary *dic))callback;
@end
