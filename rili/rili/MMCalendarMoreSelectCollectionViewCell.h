//
//  MMCalendarMoreSelectCollectionViewCell.h
//  rili
//
//  Created by 郭民民 on 2017/9/8.
//  Copyright © 2017年 minmin. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *MMCalendarMoreSelectCollectionViewCellID = @"MMCalendarMoreSelectCollectionViewCell";
@interface MMCalendarMoreSelectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *showNowView;

@end
