//
//  ViewController.m
//  rili
//
//  Created by 郭民民 on 2017/9/8.
//  Copyright © 2017年 minmin. All rights reserved.
//

#import "ViewController.h"
#import "MMCalendarMoreSelectView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor greenColor];
    
    MMCalendarMoreSelectView *view = [MMCalendarMoreSelectView MMCreateCalendarMoreSelectViewWithFrame:CGRectMake(10, 10, 355, 444)andCallBack:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
    }];
    [self.view addSubview:view];
   
    
    
}





@end
