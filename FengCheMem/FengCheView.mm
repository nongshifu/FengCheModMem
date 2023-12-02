
//  Created by 江湖 on 2022/3/14.
//  Copyright © 2022 zibeike. All rights reserved.
//


#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AdSupport/AdSupport.h>
#import <AVKit/AVKit.h>
#import "FengCheView.h"

#import "YMUIWindow.h"
#import "Window.h"


#define CurrentViewSize self.view.frame.size
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface FengCheView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) FengCheActionBlock actionBlock;
@property (nonatomic, strong) UIButton *touxiang;

@property (nonatomic,  assign) float 统一圆角;
@end
static UITextField*bgTextField;
static UIView *菜单视图;
static UITableView *表格视图;
static float 比例 = 1;
static UIView*图标视图;
static UIWindow *跟视图;
BOOL 验证状态;//验证成功后赋值给YES
NSString* 验证信息,*到期时间;//验证成功后赋值给到期时间 服务器验证返回值赋值给验证信息
@implementation FengCheView
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FengCheView *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        跟视图 = [Window sharedInstance];
    });
    return sharedInstance;
}

+(UIView *)getSecureView{
    bgTextField = [[UITextField alloc] init];
    bgTextField.secureTextEntry = YES;
    UIView *bgView = bgTextField.subviews.firstObject;
    [bgView setUserInteractionEnabled:YES];
    // 创建一个捏合手势识别器========
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    // 将捏合手势识别器添加到视图中
    [bgView addGestureRecognizer:pinchGesture];
    return bgView;
}

// 处理捏合放大缩小手势
+(void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        // 缩放视图
        view.transform = CGAffineTransformScale(view.transform, gesture.scale, gesture.scale);
        gesture.scale = 1.0;
    }
}
//菜单视图
- (void)添加菜单:(NSString *)Title
                             IconURL:(NSString *)IconURL
                             IconRect:(CGRect )IconRect
                             memRect:(CGRect )memRect
                             memRadius:(float)memRadius
                         actionBlock:(FengCheActionBlock)actionBlock{
    self.统一圆角 = memRadius;
    // 保存按钮点击事件的闭包
    self.actionBlock = actionBlock;
    [self 菜单:Title IconURL:IconURL memRect:memRect memRadius:memRadius];
    [self 图标:IconURL IconRect:IconRect];
    
}
-(void)菜单:(NSString *)Title IconURL:(NSString *)IconURL memRect:(CGRect )memRect memRadius:(float)memRadius{
    //  NSLog(@"菜单跟视图");
    if(!菜单视图){
        菜单视图 = [FengCheView getSecureView];
    }
    菜单视图.frame= memRect;
    菜单视图.backgroundColor=[UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:245 / 255.0 alpha:0];
    
    菜单视图.layer.cornerRadius = self.统一圆角;
    菜单视图.layer.masksToBounds = NO;
    菜单视图.hidden=NO;
    菜单视图.center = 跟视图.center;
    菜单视图.alpha = 0.0f;
    //   NSLog(@"菜单拖动事件");
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movingBtn:)];
    [菜单视图 addGestureRecognizer:pan];
    [跟视图 addSubview:菜单视图];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.clipsToBounds = YES;
    visualView.frame = 菜单视图.bounds;
    visualView.layer.cornerRadius = self.统一圆角;
    [菜单视图 addSubview:visualView];
    
    //顶部背景 拖动
    UIView *h = [[UIView alloc]
                 initWithFrame:CGRectMake(0,0, 菜单视图.frame.size.width, 40)];
    h.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    // 设置左上角和右下角为圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:h.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(self.统一圆角, self.统一圆角)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = h.bounds;
    maskLayer.path = maskPath.CGPath;
    h.layer.mask = maskLayer;
    NSLog(@"菜单圆角设置");
    [菜单视图 addSubview:h];
    
    
    //顶部文字
    UILabel *BT = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, h.frame.size.width, 30)];
    BT.numberOfLines = 0;
    BT.lineBreakMode = NSLineBreakByCharWrapping;
    BT.text = Title;//绘制名字
    BT.textAlignment = NSTextAlignmentCenter;
    BT.font = [UIFont boldSystemFontOfSize:15];
    BT.textColor = [UIColor blackColor];
    [h addSubview:BT];
    
    //菜单上图标
    self.touxiang = [[UIButton alloc]
                initWithFrame:CGRectMake(10,-25, 50, 50)];
    self.touxiang.backgroundColor=[UIColor clearColor];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:IconURL]];
        UIImage *decodedImage = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{self.touxiang.layer.contents = (id)decodedImage.CGImage;});});
    self.touxiang.clipsToBounds = YES;
    self.touxiang.layer.cornerRadius = CGRectGetWidth(self.touxiang.bounds) / 2;
    [菜单视图 addSubview:self.touxiang];
    
    
    //关闭按钮
    UIButton *关闭 = [[UIButton alloc]
                    initWithFrame:CGRectMake(h.frame.size.width-30,10, 20, 20)];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:GuanBi options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *decodedImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{关闭.layer.contents = (id)decodedImage.CGImage;});});
    关闭.clipsToBounds = YES;
    关闭.layer.cornerRadius = CGRectGetWidth(关闭.bounds) / 2;
    [关闭 addTarget:self action:@selector(关闭菜单) forControlEvents:UIControlEventTouchUpInside];
    [h addSubview:关闭];
        NSLog(@"初始化表格视图");
    表格视图 = [[UITableView alloc]initWithFrame:CGRectMake(5,45,菜单视图.frame.size.width-10,菜单视图.frame.size.height-50) style:UITableViewStyleGrouped];
    表格视图.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:245 / 255.0 alpha:0];
    表格视图.bounces = YES;
    表格视图.clipsToBounds = YES;
    表格视图.layer.cornerRadius = self.统一圆角/2;
       NSLog(@"表格视图代理协议");
    表格视图.dataSource = self;
    表格视图.delegate = self;
    
    表格视图.showsVerticalScrollIndicator = NO;
    表格视图.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSLog(@"表格背景样式");
    if (@available(iOS 13.0, *)) {
        // 在 iOS 13.0 及更高版本上设置用户界面样式
        表格视图.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // 在较旧版本的 iOS 上设置用户界面样式（例如，iOS 12 及更早版本）
        表格视图.backgroundColor = [UIColor whiteColor];
    }
       NSLog(@"表格添加到视图");
    [菜单视图 addSubview:表格视图];
    
}

-(void)图标:(NSString *)IconURL IconRect:(CGRect )IconRect{
     NSLog(@"初始化图标");
    跟视图 = [Window sharedInstance];
    跟视图.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    NSLog(@"获取跟视图 附带HOOK 触摸穿透");
    图标视图 = [FengCheView getSecureView];
    
       NSLog(@"获取跟过直播视图");
    图标视图.frame = IconRect;
    图标视图.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    图标视图.clipsToBounds = YES;
    图标视图.layer.cornerRadius = 图标视图.frame.size.width/2;
    
    
    //图标背景图
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
           NSLog(@"读取网络图标");
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:IconURL]];
        UIImage *decodedImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView*imgview=[[UIImageView alloc]init];
            imgview.frame=图标视图.bounds;
            imgview.image=decodedImage;
            imgview.clipsToBounds = YES;
            imgview.layer.cornerRadius = 图标视图.frame.size.width/2;
            [图标视图 addSubview:imgview];
            
        });
    });
    [跟视图 addSubview:图标视图];
    
    //拖动图标
    NSLog(@"图标拖动事件");
    
    [self startAudioSession];
}


//监听音量
- (void)startAudioSession {
    
    NSLog(@"监听音量变化");
    // 监听音量变化
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movingBtn:)];
    [图标视图 addGestureRecognizer:pan];
    
    //点击图标
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;//点击次数
    tap.numberOfTouchesRequired = 1;//手指数
    [tap addTarget:self action:@selector(点击图标)];
    [图标视图 addGestureRecognizer:tap];
    
}
- (void)volumeChanged:(NSNotification *)notification {
    [self 转圈圈];
    [UIView animateWithDuration:0.3 animations:^{
        图标视图.alpha=!图标视图.alpha;
    }];
}

- (void)点击图标{
    if (self.actionBlock) {
        NSLog(@"self.actionBlock");
        self.actionBlock();
    }
    NSLog(@"点击了图标");
    [UIView animateKeyframesWithDuration:0.7 delay:0 options:0 animations:^{
        菜单视图.alpha = 1;
        图标视图.alpha = 0;
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4 animations:^{
            菜单视图.transform = CGAffineTransformMakeScale(比例+0.05, 比例+0.05);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.7 animations:^{
            菜单视图.transform = CGAffineTransformMakeScale(比例, 比例);
        }];
    }completion:nil];
    [表格视图 reloadData];
    
}

- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    NSLog(@"描边函数");
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 5;
}

- (void)关闭菜单{
    NSLog(@"关闭菜单函数");
    [UIView animateWithDuration:0.5 animations:^{
        菜单视图.alpha = 0;
        图标视图.alpha = 1;
    }];
    
}

- (void)movingBtn:(UIPanGestureRecognizer *)recognizer{
    NSLog(@"movingBtn函数");
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view];
    if(recognizer.state == UIGestureRecognizerStateBegan){
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:view];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        CGFloat newX2=view.center.x;
        CGFloat newY2=view.center.y;
        view.center = CGPointMake(newX2, newY2);
        [recognizer setTranslation:CGPointZero inView:view];
    }
    //黏边效果
    
    [UIView animateWithDuration:0.5 animations:^{
        //超出屏幕左边
        if (view.frame.origin.x<0) {
            view.frame=CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
        //超出屏幕上面
        if (view.frame.origin.y<0) {
            view.frame=CGRectMake(view.frame.origin.x, 0, view.frame.size.width, view.frame.size.height);
        }
        //超出屏幕底部
        if (view.frame.origin.y+view.frame.size.height>kHeight) {
            view.frame=CGRectMake(view.frame.origin.x, kHeight-view.frame.size.height, view.frame.size.width, view.frame.size.height);
        }
        //超出屏幕右边
        if (view.frame.origin.x+view.frame.size.width>kWidth) {
            view.frame=CGRectMake(kWidth-view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
        
    }];
    [self 转圈圈];
}
- (void)过直播调用:(BOOL)开关{
    NSLog(@"过直播调用函数");
    [bgTextField setSecureTextEntry:开关];
}
-(void)转圈圈
{
    NSLog(@"转圈圈");
    self.touxiang.transform = CGAffineTransformMakeRotation(M_PI);
    图标视图.transform = CGAffineTransformMakeRotation(M_PI);
    [UIView animateWithDuration:0.5 animations:^{
        self.touxiang.transform = CGAffineTransformMakeRotation(M_PI*2);
        图标视图.transform = CGAffineTransformMakeRotation(M_PI*2);
    }];
    
}

#pragma mark - 各种UI添加操作===================
static UISwitch* switchView[1000];
static NSString*开关标题[1000];

static int 排序;
static NSString* UI类型[1000];
static BOOL 展开[100];
static int 分组数量;
static int 分组排序=0;
static int 功能数量[100];
static NSString*分组标题[100];
static NSString*分组副标题[100];
#pragma mark - 添加分组
+ (void)添加分组:(NSString *)标题 分组说明:(NSString *)分组说明 是否展开:(BOOL)是否展开 功能数:(int)功能数 子功能:(子功能)子功能
{
    NSLog(@"添加分组");
    展开[分组数量]=是否展开;
    分组数量++;
    分组排序++;
    功能数量[分组排序-1]=功能数+1;
    分组标题[分组排序-1]=标题;
    分组副标题[分组排序-1]=分组说明;
    子功能();
    排序=0;
    
}
#pragma mark - 添加开关
static int 操作ID;
static 开关执行函数 开关执行代码[2000];
+ (void)添加开关:(NSString *)标题 默认状态:(BOOL)默认状态 回调:(void (^)(BOOL 开关状态))回调{
    
    NSLog(@"添加开关");
    操作ID=分组排序*100+排序++;
    开关标题[操作ID]=标题;
    switchView[操作ID] = [[UISwitch alloc] init];
   
    switchView[操作ID].on=默认状态;
    switchView[操作ID].tag=操作ID;
    switchView[操作ID].thumbTintColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0
                                                      green:(arc4random() % 255) / 255.0
                                                       blue:(arc4random() % 255) / 255.0
                                                      alpha:0.7]; //没点击的颜色 随机色
    switchView[操作ID].onTintColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0
                                                      green:(arc4random() % 255) / 255.0
                                                       blue:(arc4random() % 255) / 255.0
                                                      alpha:0.1]; //没点击的颜色 随机色
    
    [switchView[操作ID] addTarget:self action:@selector(开关调用:) forControlEvents:UIControlEventValueChanged];
    
    UI类型[操作ID]=@"开关";
    // 设置开关状态变化的回调
    开关执行代码[操作ID] = 回调;
}

+(void)开关调用:(UISwitch*)Switch
{
    int tag=(int)Switch.tag;
    NSLog(@"开关tag=%d",tag);
    if (开关执行代码[tag]) {
        开关执行代码[tag](Switch.isOn);
        
    }

}
#pragma mark - 添加按钮
static UIButton* button[1000];
static NSString*按钮标题[1000];
static 执行函数 按钮执行[1000];
+ (void)添加按钮:(NSString *)说明 标题:(NSString*)标题 尺寸:(CGRect)Rect 点击操作:(执行函数)点击操作
{
    NSLog(@"添加按钮");
    操作ID=分组排序*100+排序++;
    
    按钮标题[操作ID]=说明;
    UI类型[操作ID]=@"按钮";
    按钮执行[操作ID]=点击操作;
    button[操作ID] = [[UIButton alloc]init];
    button[操作ID].layer.cornerRadius = 10.0;
    [button[操作ID] setTitle:标题 forState:UIControlStateNormal];
    [button[操作ID] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//p1颜色
    button[操作ID].backgroundColor = [UIColor colorWithRed:34/255.0 green:181/255.0 blue:115/250.0 alpha:1];
    button[操作ID].frame = Rect;
    button[操作ID].layer.borderColor = [[UIColor whiteColor] CGColor];//边框颜色
    button[操作ID].layer.borderWidth = 1.0f;//边框大小
    button[操作ID].tag=操作ID;
    [button[操作ID].titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
    [button[操作ID] addTarget:self action:@selector(按钮调用:) forControlEvents:UIControlEventTouchUpInside];
    
}
+(void)按钮调用:(UIButton*)Button
{
    int tag=(int)Button.tag;
    按钮执行[tag]();
    
}

static UIView* 自定义视图[1000];
+ (UIView *)添加自定义视图:(void (^)(UIView * _Nonnull))视图
{
    UIView *父视图 = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 调用自定义视图闭包，并传入父级视图参数
    if (视图) {
        视图(父视图);
    }
    
    操作ID=分组排序*100+排序++;
    自定义视图[操作ID]=父视图;
    UI类型[操作ID]=@"视图";
    return 自定义视图[操作ID];
}
+ (BOOL)判断颜色模式{
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleDark) {
          //  NSLog(@"深色模式");
            return YES;
        }
    }
    return NO;
}
#pragma mark - TbaleView的数据源代理方法实现==================
+ (void)刷新表格
{
   // NSLog(@"shuaxin");
    [表格视图 reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  NSLog(@"表格初始化函数");
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.textColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0
                                               green:(arc4random() % 255) / 255.0
                                                blue:(arc4random() % 255) / 255.0
                                               alpha:1]; //没点击的颜色 随机色
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];//文字大小
    for (int i=0; i<分组数量; i++) {
        if (indexPath.section==i) {
            //设置每个分组的标题
            if (indexPath.row==0) {
                cell.textLabel.text = 分组标题[i];
                if(!展开[i]){
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor=[UIColor systemRedColor];
                }
            }else if (indexPath.section==0 && 验证状态 && indexPath.row==1) {
                cell.textLabel.text = 到期时间;
                
            }else{
                //设置每个分组的子功能标题
                int cj=(((int)indexPath.section+1)*100)+(int)indexPath.row-1;
             //   NSLog(@"cj=%d section=%d",cj,(int)indexPath.section);
                if ([UI类型[cj] isEqual:@"开关"]) {
                    cell.textLabel.text = 开关标题[cj];
                    cell.accessoryView=switchView[cj];
                }
                if ([UI类型[cj] isEqual:@"按钮"]) {
                    cell.textLabel.text = 按钮标题[cj];
                    cell.accessoryView=button[cj];
                }
                if ([UI类型[cj] isEqual:@"视图"]) {
                    cell.textLabel.text = 按钮标题[cj];
                    [cell addSubview:自定义视图[cj]];
                    
                }
                
            }
            
        }
        
        
    }
    
    return cell;
}
#pragma mark - 分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   // NSLog(@"表格分组数量函数");
    if (分组数量==0) {
        return 1;
    }
    return 分组数量;
}
#pragma mark - 默认多少表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (分组数量!=0) {
        for (int i=0; i<分组数量; i++) {
            if(section==i) //展开的
            {
                if (展开[section]) {
                    return 功能数量[i];
                }
                return 1;
            }
        }
    }else{
        return 排序;
    }
    
    
    return 0;
}
#pragma mark - 默认单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
#pragma mark - 默认分组顶部部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
#pragma mark - 分组底部
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    footerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];//底部分组背景
    CGFloat cornerRadius = 10;
    UIRectCorner corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:footerView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = footerView.bounds;
    maskLayer.path = maskPath.CGPath;
    footerView.layer.mask = maskLayer;
    return footerView;
}
#pragma mark - 点击后操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        展开[indexPath.section]=!展开[indexPath.section];
    }
    [表格视图 reloadData];
}

#pragma mark - 默认分组顶部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}
#pragma mark - 默认顶部文字

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *headerLabel;
    for (int i=0; i<分组数量; i++) {
        if (section==i) {
            if(分组副标题[i])headerLabel = [NSString stringWithFormat:@"%@",分组副标题[i]];
            if (!验证状态 && i==0) {
                headerLabel=验证信息;
            }
        }
    }
    
    if (分组数量==0) {
        headerLabel=@"分组错误 请先添加分组 后添加功能";
    }
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    footerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-20, 20)];
    label.text = headerLabel;
    // footerView圆角弧度半径
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:footerView.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = cornerPath.CGPath;
    footerView.layer.mask = maskLayer;
    
    
    
    
    label.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [footerView addSubview:label];
    return footerView;
}

#pragma mark - 表格样式
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 移除之前添加的分割线图层
    for (CALayer *layer in cell.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]] && layer.name != nil && [layer.name isEqualToString:@"separatorLayer"]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    // 添加白色半透明背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    backgroundView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.2];
    cell.backgroundView = backgroundView;
    
    // 添加分割线
    CALayer *separatorLayer = [[CALayer alloc] init];
    separatorLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    separatorLayer.frame = CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1);
    separatorLayer.name = @"separatorLayer";
    
    [cell.layer addSublayer:separatorLayer];
}
+ (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 当前 VC 支持的屏幕方向
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 优先的屏幕方向
    return UIInterfaceOrientationLandscapeRight;
}


@end
