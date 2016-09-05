//
//  DrawingBoardViewController.m
//  AnimationSet
//
//  Created by sunlei on 16/9/5.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "DrawingBoardViewController.h"
#import "DrawingBoard.h"

@interface DrawingBoardViewController ()

@end

@implementation DrawingBoardViewController

-(void)loadView{
    
    self.view = [[DrawingBoard alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
