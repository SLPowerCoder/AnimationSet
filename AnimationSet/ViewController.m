//
//  ViewController.m
//  AnimationSet
//
//  Created by sunlei on 16/8/31.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "ViewController.h"
#import "AnimationViewController.h"
#import "DrawingBoardViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController{
    NSArray *arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"==========----------%f",[[UIScreen mainScreen] nativeScale]);
    self.navigationItem.title = @"动画";
    
    arr = @[@"基本动画 --- Core Animation",@"关键帧动画 --- Core Animation",@"转场动画 --- Core Animation",@"组动画 --- Core Animation",@"贝塞尔曲线 ---UIBezier" ,@"画板---Core Graphic"];
    
    [self createContents];
}

-(void)createContents{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - tableView相关代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString * const cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = arr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5) {
        
        DrawingBoardViewController *drawVC = [[DrawingBoardViewController alloc]init];
        
        [self.navigationController pushViewController:drawVC animated:YES];
        
        return;
    }

    AnimationViewController *animationVC = [[AnimationViewController alloc]init];
    
    animationVC.row = indexPath.row;
    [self.navigationController pushViewController:animationVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
