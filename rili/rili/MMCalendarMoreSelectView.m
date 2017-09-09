//
//  MMCalendarMoreSelectVIew.m
//  rili
//
//  Created by 郭民民 on 2017/9/8.
//  Copyright © 2017年 minmin. All rights reserved.
//

#import "MMCalendarMoreSelectView.h"

#import "MMCalendarMoreSelectCollectionViewCell.h"

#define kkmScreenWidth self.bounds.size.width
#define kkmScreenHeight self.bounds.size.height
#define kkmBtnWidth 100
#define kkmBtnHeight 60


@interface MMCalendarMoreSelectView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UILabel *midLabel;//中间展示label
@property (nonatomic ,strong) UIButton *leftBtn;//上一个月按钮
@property (nonatomic ,strong) UIButton *rightBtn;//下一月按钮

@property (nonatomic ,strong) UICollectionView *collectionView;//展示的collectionView

@property (nonatomic ,strong) NSMutableArray *daysWeek;//collectionView数据源

@property (nonatomic ,strong) MMCalendarDateModel *curDayModel;//记录当前时间
@property (nonatomic ,strong) MMCalendarDateModel *showDayModel;//记录展示时间
@property (nonatomic ,strong) NSDate *showDate;//展示的date


@property (nonatomic ,strong) NSMutableDictionary *selectDateDic;//选择的天数
@property (nonatomic ,copy) void(^callback)(NSDictionary*);//回调

@property (nonatomic ,assign) CGFloat cellWidth;
@end
@implementation MMCalendarMoreSelectView
#pragma mark - 创建方法
+(instancetype)MMCreateCalendarMoreSelectViewWithFrame:(CGRect)frame andCallBack:(void (^)(NSDictionary *dic))callback{
    
    MMCalendarMoreSelectView *view = [[MMCalendarMoreSelectView alloc] initWithFrame:frame];
    view.callback = callback;
    
    [view setup];
    return view;
    
}

#pragma mark - 设置
-(void)setup{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15.0;
    
    self.cellWidth = (kkmScreenWidth - 20) / 7 - 1;
    self.backgroundColor = [UIColor whiteColor];
    //部分数据初始化
    
    _selectDateDic = [NSMutableDictionary dictionary];
    _showDate = [NSDate date];
    
    //设置头顶UI
    [self setUIs];
    //设置collection
    [self setCollView];
    
    //更新数据源
    [self reloadDate];
}

-(void)drawRect:(CGRect)rect{
    NSArray * weekArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七"];
    
    for (int i = 0 ;i < weekArr.count ;i++) {
        NSString *str = weekArr[i];
        
        CGFloat width = kkmScreenWidth / 7;
        
        [str drawInRect:CGRectMake((i + 0.5)* width - 8, kkmBtnHeight + 0.5 * width - 8, width, width) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.168 green:0.168 blue:0.168 alpha:1.0]}];
        
        
    }

}

-(void)setUIs{
    
    //根据实际需求设置UI
    //中间label
    _midLabel = ({
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kkmScreenWidth, kkmBtnHeight)];
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.168 green:0.168 blue:0.168 alpha:1.0];
    label.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        
    [self addSubview:label];
        
    label;
    });
    
    
    CGFloat spaceX = 0;
    if (kkmScreenWidth > 320) {
        spaceX = (kkmScreenWidth - 320) / 2;
    }
    
    //左按钮
    _leftBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(spaceX, 0, kkmBtnWidth, kkmBtnHeight);
        
        [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:[UIImage imageNamed:@"left_editbymm"] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        btn;
    });
    
    //右按钮
    _rightBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(kkmScreenWidth - spaceX - kkmBtnWidth, 0, kkmBtnWidth, kkmBtnHeight);
        
        [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:[UIImage imageNamed:@"right_editbymm"] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn;
    });

}

-(void)leftBtnClick{
    _showDate = [self lastMonth:_showDate];//变上一个月date
    [self reloadDate];
    [self.collectionView reloadData];
}

-(void)rightBtnClick{
    _showDate = [self nextMonth:_showDate];//变下一个月date
    [self reloadDate];
    
    [self.collectionView reloadData];
}

#pragma mark - 计算数据源
-(void)reloadDate{
    //获取当前时间
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:_showDate];

    //第一天星期几 1-> 星期一 7->星期天
    NSInteger firstDay = [self firstWeekdayInThisMonth:_showDate];
    if (firstDay == 0) {
        firstDay = 7;
    }
    
    //这个月多少天
    NSInteger totalDay = [self totaldaysInMonth:_showDate];
    //上个月多少天
    NSInteger lastTotalDay = [self totaldaysInMonth:[self lastMonth:_showDate]];
    
    //清空当前collection数据源
    [self.daysWeek removeAllObjects];
    
    //生成展示的model
    MMCalendarDateModel *model = [MMCalendarDateModel MMGreateModelWithWeekday:components.weekday andMouthDays:totalDay andLastMouthDays:lastTotalDay andDay:components.day andMonth:components.month andYear:components.year];
    
    if (self.curDayModel == nil) {
        //第一次记录当前时间
        self.curDayModel = model;
    }
    //记录展示当前时间
    self.showDayModel = model;
    
    //更新展示UI
    _midLabel.text = [NSString stringWithFormat:@"%ld年%2ld月",self.showDayModel.year,self.showDayModel.month];
    
    //生成collectionView 的数据源
    for (int i = 0; i < 6 * 7; i ++) {
        MMCalendarDateModel *model = [MMCalendarDateModel MMGreateModelWithWeekday:components.weekday andMouthDays:totalDay andLastMouthDays:lastTotalDay andDay:components.day andMonth:components.month andYear:components.year];
        
        [model mmChangeDayWithGap:i - firstDay + 2 - components.day];
        [self.daysWeek addObject:model];
    }
    
}

#pragma mark - collectionView设置
-(void)setCollView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kkmBtnHeight  + _cellWidth, kkmScreenWidth, kkmScreenHeight) collectionViewLayout:layout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:MMCalendarMoreSelectCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:MMCalendarMoreSelectCollectionViewCellID];
    
    [self addSubview:_collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6 * 7;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cellWidth, _cellWidth);
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMCalendarMoreSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MMCalendarMoreSelectCollectionViewCellID forIndexPath:indexPath];
//    if (indexPath.item < 7) {
//        cell.showLabel.text = _weekArr[indexPath.row];
//        cell.showLabel.textColor = [UIColor colorWithRed:0.168 green:0.168 blue:0.168 alpha:1.0];
//        
//        cell.showNowView.hidden = YES;
//        cell.blueView.hidden = YES;
//        
//    }else{
        MMCalendarDateModel *model = self.daysWeek[indexPath.row];
        cell.showLabel.text = [NSString stringWithFormat:@"%ld",model.day];
        MMCalendarCompareResult result = [MMCalendarDateModel mmCompareTwoDay:_curDayModel andOtherDay:model];
        
        if (model.month != _showDayModel.month || result == MMCalendarCompareResultBefore) {
            cell.showLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        }else{
            cell.showLabel.textColor = [UIColor colorWithRed:0.168 green:0.168 blue:0.168 alpha:1.0];
        }
        
        if (result == MMCalendarCompareResultNow) {
            cell.showNowView.hidden = NO;
        }else{
            cell.showNowView.hidden = YES;
        }
        
        NSString *str = [NSString stringWithFormat:@"%ld,%ld,%ld",model.year,model.month,model.day];
        
        if ([_selectDateDic objectForKey:str]) {
            cell.blueView.hidden = NO;
        }else{
            cell.blueView.hidden = YES;
        }
        
//    }
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row < 7 ) {
//        return;
//    }
//    
    MMCalendarDateModel *model = self.daysWeek[indexPath.row];
    
    if (model.month != _showDayModel.month || [MMCalendarDateModel mmCompareTwoDay:_curDayModel andOtherDay:model] == MMCalendarCompareResultBefore) {
        return;
    }
    
    
    NSString *str = [NSString stringWithFormat:@"%ld,%ld,%ld",model.year,model.month,model.day];
    
    if ([_selectDateDic objectForKey:str]) {
        [_selectDateDic removeObjectForKey:str];
    }else{
        [_selectDateDic setObject:@"1" forKey:str];
    }
    
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]
     ];
    
    if (_callback) {
        _callback(_selectDateDic);
    }
}



#pragma mark - date 计算相关

//第一天星期几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

//这个月多少天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

//上个月的date
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
//下个月的date
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
#pragma mark - lazy
-(NSMutableArray *)daysWeek{
    if (_daysWeek == nil) {
        _daysWeek = [NSMutableArray array];
    }
    return _daysWeek;
}

@end
