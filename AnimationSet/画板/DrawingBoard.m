//
//  View.m
//  AnimationSet
//
//  Created by sunlei on 16/9/5.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "DrawingBoard.h"
#import "LineObj.h"

@implementation DrawingBoard{
    CGPoint lastPoint;
    NSMutableArray <LineObj *>*_prepareDrawArr; //将要被画出来的线
//    NSMutableArray <LineObj *>*_drawedArr; //已经画过了
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _prepareDrawArr = [NSMutableArray arrayWithCapacity:0];
//        _drawedArr = [NSMutableArray arrayWithCapacity:0];
        [self createContent];
    }
    return self;
}

-(void)createContent{
    
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width - 100)/2, self.frame.size.height - 60, 100, 30)];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor redColor];
    clearBtn.layer.shadowOffset = CGSizeMake(10, 10);
    [clearBtn addTarget:self action:@selector(clearBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
}

-(void)clearBtn{
    NSLog(@"清除画板");
    [_prepareDrawArr removeAllObjects];
    [self layoutIfNeeded];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    //GContextAddXXXXX 有一系列的添加形状的方法，如：添加线条line, 矩形rect，二阶贝塞尔曲线Curve，三阶贝塞尔曲线 QuadCurve
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    
    for (int i = 0;  i < _prepareDrawArr.count; i++) {
        
        LineObj *obj = _prepareDrawArr[i];
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, obj.startPoint.x, obj.startPoint.y);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, obj.endPoint.x,obj.endPoint.y);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CGPoint point =[[[touches allObjects] lastObject] locationInView:self];

    lastPoint = point;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point =[[[touches allObjects] lastObject] locationInView:self];
   
    LineObj *obj = [[LineObj alloc]init];
    obj.startPoint = lastPoint;
    obj.endPoint = point;
    [_prepareDrawArr addObject:obj];
    
    lastPoint = point;
    
    [self setNeedsDisplay];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    [_drawedArr addObjectsFromArray:_prepareDrawArr];
//    [_prepareDrawArr removeAllObjects];
}

@end
