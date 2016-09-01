//
//  AnimationViewController.m
//  AnimationSet
//
//  Created by sunlei on 16/8/31.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "AnimationViewController.h"

#define angle2radion(a) ((a) / 180.0 * M_PI) // 角度转弧度

@interface AnimationViewController ()

@property (nonatomic, strong) UIView *animationView;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.animationName;
    
    _animationView = [[UIView alloc]initWithFrame:CGRectMake(40, 100, self.view.frame.size.width - 80, self.view.frame.size.height - 140)];
    _animationView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_animationView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self playAnimationWithName:self.animationName];
}

//播放动画
-(void)playAnimationWithName:(NSString *)name{

    NSArray *arr = @[@"基本动画",@"关键帧动画",@"转场动画",@"组动画",@"贝塞尔曲线"];;
    
    if ([name isEqualToString:arr[0]]) {
        [self createBasicAnimation];
    }else if ([name isEqualToString:arr[1]]){
        [self createKeyFrameAnimation];
    }else if ([name isEqualToString:arr[2]]){
        [self createTransitionAnimation];
    }else if ([name isEqualToString:arr[3]]){
        [self createGroupAnimation];
    }else if ([name isEqualToString:arr[4]]){
        _animationView.hidden = YES;
        [self createMiidolWithtarget:self];
    }
}


#pragma mark -  创建基本动画
-(void)createBasicAnimation{
    // 基本动画
    //凡是Animatable的属性，都可作为参数
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    //动画的起止值
    basic.fromValue = @(_animationView.layer.position.x - 20); //如果开始值不设置，则默认当前值为开始值
    basic.toValue = @(_animationView.layer.position.x + 20);;
    
    //持续的时间
    basic.duration = 0.08f;
    //重复的次数
    basic.repeatCount = 4;//HUGE_VALF;//非常大的数
    //自动翻转，即从0到1，然后在从1到0，如此循环
    //basic.autoreverses = YES;
    
    // 核心动画结束后，不想回到原来的位置，需要以下两行代码
    basic.fillMode = kCAFillModeForwards; // 填充模式
    basic.removedOnCompletion = NO;
    
    //时序函数，调节速度的，你还可以自己定制
    basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //调好一个贝塞尔曲线实在是太难了，妹的，可以通过该网址调整贝塞尔曲线http://cubic-bezier.com/#.17,.67,.83,.67
    //basic.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.29 :0.76 :0.81 :0.34];
    
    [_animationView.layer addAnimation:basic forKey:nil];
}

#pragma mark -  创建关键帧动画
-(void)createKeyFrameAnimation{
    
//    //创建关键帧动画
//    CAKeyframeAnimation *keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
//    
//    //每一帧的动画
//    keyFrameAni.values =  @[@(angle2radion(-5)), @(angle2radion(5)), @(angle2radion(-5)) ];
//    //每一帧动画的时间
//    //keyFrameAni.keyTimes = @[@0.1,@5,@0.1];
//    keyFrameAni.repeatCount = MAXFLOAT;
//    
//    [_animationView.layer addAnimation:keyFrameAni forKey:nil];
    _animationView.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.5;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_animationView.layer addAnimation:popAnimation forKey:nil];
}

#pragma mark -  创建转场动画
-(void)createTransitionAnimation{

    //转场动画
    CATransition *anim = [[CATransition alloc] init];
    
    //要执行什么动画，设置过度效果
    /*
     fade, moveIn, push, reveal
     cube, oglFlip, suckEffect, rippleEffect, pageCurl, pageUnCurl, cameraIrisHollowOpen, cameraIrisHollowClose
     */
    anim.type = @"cameraIrisHollowOpen";  // 动画过渡类型
    //动画过渡方向
    anim.subtype = kCATransitionFromLeft;
    //设置动画持续时间
    anim.duration = 1.0;
    
    //添加动画
    [_animationView.layer addAnimation:anim forKey:nil];
}

#pragma mark -  创建组动画
-(void)createGroupAnimation{
    
    // 组动画：同时缩放，旋转，平移
    CAAnimationGroup *group = [CAAnimationGroup animation];
    //设置组动画持续时间，好像单独设置每一个动画的持续时间后不起作用啊
    group.duration = 1;
    // 缩放
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    // 这里是以向量(1, 1, 0)为轴，旋转π/2弧度(90°)
    // 如果只是在手机平面上旋转，就设置向量为(0, 0, 1)，即Z轴
    scale.toValue =[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 1, 1, 0)];
    scale.duration = 1;
    
    // 旋转（随机效果）
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform"];
    // 没有设置fromValue说明当前状态作为初始值
    // 宽度(width)变为原来的2倍，高度(height)变为原来的1.5倍
    rotation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 1.5, 1)];
    rotation.duration = 1;
    
    // 平移（随机效果）
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"position";
    position.toValue =[NSValue valueWithCGPoint:CGPointMake(_animationView.layer.position.x,_animationView.layer.position.y + 500)];
//    position.duration = 4;
    
    // 放入组动画
    group.animations = @[scale, rotation, position];
    
    [_animationView.layer addAnimation:group forKey:nil];
}


#pragma mark - 常见贝塞尔曲线
-(void)createMiidolWithtarget:(id)target{

    
    CGColorRef fillColor = [UIColor blackColor].CGColor;
    CGColorRef strokeColor = [UIColor purpleColor].CGColor;
    
    UIView *animationView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 115)/2, (self.view.frame.size.height - 60)/2, 115, 60)];
    
//    CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"backGroundColor"];
//    basicAni.fromValue = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    basicAni.toValue = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//    
//    [animationView.layer addAnimation:basicAni forKey:nil];
    
    animationView.backgroundColor = [UIColor blackColor];
    animationView.layer.cornerRadius = 8;
    animationView.layer.masksToBounds = YES;
    
    if ([target isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)target;
        [vc.view addSubview:animationView];
    }else if ([target isKindOfClass:[UIViewController class]]){
        UIView *view = (UIView *)target;
        [view addSubview:animationView];
    }else{
        return;
    }

    //MIIDOL米多标志
    //M
    CAShapeLayer *mShapeLayer = [CAShapeLayer layer];
    mShapeLayer.frame = CGRectMake(10, 15, 20, 30);
    mShapeLayer.backgroundColor = [UIColor blackColor].CGColor;
    mShapeLayer.lineWidth = 2;
    mShapeLayer.strokeColor = strokeColor;
    mShapeLayer.fillColor = fillColor;
    
    CABasicAnimation *mAni = [CABasicAnimation animationWithKeyPath:@"position.y"];
    mAni.duration = 0.4;
    mAni.fromValue = @(mShapeLayer.position.y - 5); //如果开始值不设置，则默认当前值为开始值
    mAni.toValue = @(mShapeLayer.position.y + 5);
  
    mAni.autoreverses = YES;
    mAni.repeatCount = HUGE_VALF;
    mAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [mShapeLayer addAnimation:mAni forKey:nil];
    
    UIBezierPath *mPath = [UIBezierPath bezierPath];
    [mPath moveToPoint:CGPointMake(0, mShapeLayer.frame.size.height)];
    [mPath addLineToPoint:CGPointMake(0, 2)];
    [mPath addLineToPoint:CGPointMake(mShapeLayer.frame.size.width/2, mShapeLayer.frame.size.height/2)];
    [mPath addLineToPoint:CGPointMake(mShapeLayer.frame.size.width, 2)];
    [mPath addLineToPoint:CGPointMake(mShapeLayer.frame.size.width, mShapeLayer.frame.size.height)];
    
    mShapeLayer.path = mPath.CGPath;
    
    [animationView.layer addSublayer:mShapeLayer];
    
    //I
    for (int i = 0; i < 2; i ++) {
        CAShapeLayer *iShapeLayer = [CAShapeLayer layer];
        iShapeLayer.frame = CGRectMake(40 + 12*i, 15, 2, 30);
        iShapeLayer.backgroundColor = [UIColor blackColor].CGColor;
        iShapeLayer.lineWidth = 2;
        iShapeLayer.strokeColor = strokeColor;
        iShapeLayer.fillColor = fillColor;
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.5 + i*0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CABasicAnimation *iAni = [CABasicAnimation animationWithKeyPath:@"position.y"];
            iAni.duration = 0.4;
            iAni.fromValue = @(mShapeLayer.position.y - 5); //如果开始值不设置，则默认当前值为开始值
            iAni.toValue = @(mShapeLayer.position.y + 5);
            iAni.autoreverses = YES;
            iAni.repeatCount = HUGE_VALF;
            iAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [iShapeLayer addAnimation:iAni forKey:nil];

        });
        
        UIBezierPath *iPath = [UIBezierPath bezierPath];
        [iPath moveToPoint:CGPointMake(0, 0)];
        [iPath addLineToPoint:CGPointMake(0, iShapeLayer.frame.size.height)];
        
        iShapeLayer.path = iPath.CGPath;
        
        [animationView.layer addSublayer:iShapeLayer];
    }
    
    //D
    CAShapeLayer *dShapeLayer = [CAShapeLayer layer];
    dShapeLayer.frame = CGRectMake(60, 15, 16, 30);
    dShapeLayer.backgroundColor = [UIColor blackColor].CGColor;
    dShapeLayer.lineWidth = 2;
    dShapeLayer.strokeColor = strokeColor;
    dShapeLayer.fillColor = fillColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CABasicAnimation *dAni = [CABasicAnimation animationWithKeyPath:@"position.y"];
        dAni.duration = 0.4;
        dAni.fromValue = @(mShapeLayer.position.y - 5); //如果开始值不设置，则默认当前值为开始值
        dAni.toValue = @(mShapeLayer.position.y + 5);
        dAni.autoreverses = YES;
        dAni.repeatCount = HUGE_VALF;
        dAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [dShapeLayer addAnimation:dAni forKey:nil];
        
    });
    
    UIBezierPath *dPath = [UIBezierPath bezierPath];
    [dPath moveToPoint:CGPointMake(0, dShapeLayer.frame.size.height)];
    [dPath addLineToPoint:CGPointMake(0, 2)];
    [dPath addLineToPoint:CGPointMake(dShapeLayer.frame.size.width/2, 2)];
    [dPath addQuadCurveToPoint:CGPointMake(dShapeLayer.frame.size.width/2, dShapeLayer.frame.size.height) controlPoint:CGPointMake(20, dShapeLayer.frame.size.height/2)];
    [dPath addLineToPoint:CGPointMake(0, dShapeLayer.frame.size.height)];
    
    dShapeLayer.path = dPath.CGPath;
    
    [animationView.layer addSublayer:dShapeLayer];
    
    //O
    CAShapeLayer *oShapeLayer = [CAShapeLayer layer];
    oShapeLayer.frame = CGRectMake(80, 15, 8, 30);
    oShapeLayer.backgroundColor = [UIColor blackColor].CGColor;
    oShapeLayer.lineWidth = 2;
    oShapeLayer.strokeColor = strokeColor;
    oShapeLayer.fillColor = fillColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CABasicAnimation *oAni = [CABasicAnimation animationWithKeyPath:@"position.y"];
        oAni.duration = 0.4;
        oAni.fromValue = @(mShapeLayer.position.y - 5); //如果开始值不设置，则默认当前值为开始值
        oAni.toValue = @(mShapeLayer.position.y + 5);
        oAni.autoreverses = YES;
        oAni.repeatCount = HUGE_VALF;
        oAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [oShapeLayer addAnimation:oAni forKey:nil];
        
    });
    
    UIBezierPath *oPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 2, 13, 26)];
    oShapeLayer.path = oPath.CGPath;
    
    [animationView.layer addSublayer:oShapeLayer];
    
    
    //L
    CAShapeLayer *lShapeLayer = [CAShapeLayer layer];
    lShapeLayer.frame = CGRectMake(100, 15, 8, 30);
    lShapeLayer.backgroundColor = [UIColor blackColor].CGColor;
    lShapeLayer.lineWidth = 2;
    lShapeLayer.strokeColor = strokeColor;
    lShapeLayer.fillColor = fillColor;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CABasicAnimation *lAni = [CABasicAnimation animationWithKeyPath:@"position.y"];
        lAni.duration = 0.4;
        lAni.fromValue = @(mShapeLayer.position.y - 5); //如果开始值不设置，则默认当前值为开始值
        lAni.toValue = @(mShapeLayer.position.y + 5);
        lAni.autoreverses = YES;
        lAni.repeatCount = HUGE_VALF;
        lAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [lShapeLayer addAnimation:lAni forKey:nil];
    });
    
    UIBezierPath *lPath = [UIBezierPath bezierPath];
    [lPath moveToPoint:CGPointMake(0, 0)];
    [lPath addLineToPoint:CGPointMake(0, lShapeLayer.frame.size.height)];
    [lPath addLineToPoint:CGPointMake(lShapeLayer.frame.size.width, lShapeLayer.frame.size.height)];
    
    lShapeLayer.path = lPath.CGPath;
    
    [animationView.layer addSublayer:lShapeLayer];
}


-(void)dealloc{

    [_animationView.layer removeAllAnimations];
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
