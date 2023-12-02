#import "Window.h"
#import <UIKit/UIKit.h>
#import "FengCheView.h"
#import "NSObject+main.h"
//#import "WX_NongShiFu123.h"
#include <sys/mount.h>
#import "NSObject+main.h"
#import "YMUIWindow.h"

#import <objc/runtime.h>

@implementation NSObject (main)

+(void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 验证状态=YES;//强制设置验证为YES 方便调试而已 验证开启记得注释
            [NSObject 调用菜单测试];
//            NSString*km=[[NSUserDefaults standardUserDefaults] objectForKey:@"km"];
//            [[WX_NongShiFu123 alloc] yanzhengAndUseIt:km];
//            getGame();
            
        });
        
    });
}

UITextField*TextField;
-(void)调用菜单测试
{
    
    [[FengCheView sharedInstance] 添加菜单:@"鸡腿绘制"
                                      IconURL:@"https://img1.baidu.com/it/u=776700165,2685582112&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500"
                                     IconRect:CGRectMake(150, 100, 50, 50)
                                      memRect:CGRectMake(150, 100, 350, 350)
                                    memRadius:5
                                  actionBlock:^{
        //点击显示菜单后调用的代码 比如跨进程注销生效防止天卡永久使用 点击菜单就会验证一次卡密
        NSString * km =[[NSUserDefaults standardUserDefaults] objectForKey:@"km"];//读取本地储存卡密
//        [[WX_NongShiFu123 alloc] yanzhengAndUseIt:km];//调用验证函数
        
    }];
   
    
    [FengCheView 添加分组:@"验证功能" 分组说明:@"人生入戏 全靠演技咯" 是否展开:NO 功能数:5  子功能:^{
        [FengCheView 添加自定义视图:^(UIView * viewst) {
            //创建一个输入框例子===================================
            
            viewst.frame=CGRectMake(10, 0, 280, 30);
            TextField=[[UITextField alloc] initWithFrame:CGRectMake(0, 5, 180, 30)];
            TextField.placeholder = @"请输入激活码";
            TextField.font = [UIFont systemFontOfSize:12];
            TextField.textColor = [UIColor redColor];
            NSString*km=[[NSUserDefaults standardUserDefaults] objectForKey:@"km"];
            
            if (km.length>5) {
                TextField.text=km;
            }
            TextField.clearButtonMode = UITextFieldViewModeAlways;
            TextField.borderStyle = UITextBorderStyleRoundedRect;
            [viewst addSubview:TextField];
            
            
            //添加一个按钮 传送的是按钮在表格单元格的坐标系 例子===================================
            UIButton*but = [[UIButton alloc]init];
            but.layer.cornerRadius = 10.0;
            [but setTitle:@"激活" forState:UIControlStateNormal];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//p1颜色
            but.backgroundColor = [UIColor colorWithRed:34/255.0 green:181/255.0 blue:115/250.0 alpha:1];
            but.frame = CGRectMake(190, 5, 80, 25);
            but.layer.borderColor = [[UIColor whiteColor] CGColor];//边框颜色
            but.layer.borderWidth = 1.0f;//边框大小
            
            [but.titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
            [but addTarget:self action:@selector(按钮调用) forControlEvents:UIControlEventTouchUpInside];
            [viewst addSubview:but];
        }];
        
        
        [FengCheView 添加按钮:@"一键注销" 标题:@"注销设备" 尺寸:(CGRectMake(0, 0, 100, 30)) 点击操作:^{
            exit(0);
        }];
        
        [FengCheView 添加开关:@"直播开关" 默认状态:YES 回调:^(BOOL 开关状态) {
//            [ImGuiMem sybs].secureTextEntry =开关状态;
            [[FengCheView alloc] 过直播调用:开关状态];
        }];
        
        
        
    }];
    [FengCheView 添加分组:@"绘制功能" 分组说明:@"基础绘制功能" 是否展开:NO 功能数:11 子功能:^{
        [FengCheView 添加开关:@"总开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            绘制总开关 = 开关状态;
//            getGame();
//            [[YMUIWindow sharedInstance] addSubview:[ImGuiMem sybs]];
//
//            NSLog(@"绘制总开关=%d",绘制总开关);
        }];
        
        [FengCheView 添加开关:@"附近人数开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            附近人数开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"射线开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            射线开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"方框开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            方框开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"上身骨骼开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            上身骨骼开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"下身骨骼开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            下身骨骼开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"血条开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            血条开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"名字开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            名字开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"距离开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            距离开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"手持开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            手持开关 = 开关状态;
        }];
        
        
    }];
    [FengCheView 添加分组:@"枪械功能" 分组说明:@"枪械相关功能" 是否展开:NO 功能数:6 子功能:^{
        [FengCheView 添加开关:@"无后座开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            无后座开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"聚点开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            聚点开关 = 开关状态;
        }];
        
        [FengCheView 添加开关:@"追踪开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            追踪开关 = 开关状态;
        }];
         
        [FengCheView 添加自定义视图:^(UIView * 父级视图4) {
            
            父级视图4.frame =CGRectMake(0, 0, 300, 40);
            父级视图4.backgroundColor=[UIColor clearColor];//随便设置个背景红色
            UILabel*位置=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 40)];
            位置.text=@"追踪位置";
            位置.tag =0001;
            位置.textColor=[UIColor systemBlueColor];
            [父级视图4 addSubview:位置];
            NSArray *array2 = [NSArray arrayWithObjects:@"头",@"胸",@"腰",@"脚", nil];
            UISegmentedControl *segment2 = [[UISegmentedControl alloc]initWithItems:array2];
            segment2.frame = CGRectMake(150,5,160,30);
//            segment2.selectedSegmentIndex = 追踪位置;
            segment2.apportionsSegmentWidthsByContent = YES;
            
            [segment2 addTarget:self action:@selector(追踪位置调用:) forControlEvents:UIControlEventValueChanged];
            [父级视图4 addSubview:segment2];
        }];
       
        [FengCheView 添加自定义视图:^(UIView * 父级视图5) {
            
            父级视图5.frame=CGRectMake(0, 0, 300, 40);
            父级视图5.backgroundColor=[UIColor clearColor];//随便设置个背景红色
            
            UISlider *mySlider = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, 160, 40)];
            mySlider.minimumValue = 0.0;
            mySlider.maximumValue = 300.0;
            mySlider.value =  [[NSUserDefaults standardUserDefaults] floatForKey:@"追踪距离"];
            [mySlider addTarget:self action:@selector(追踪距离调用:) forControlEvents:UIControlEventValueChanged];
            [父级视图5 addSubview:mySlider];
            
            UILabel*滑条值=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 40)];
            滑条值.text=@"追踪距离";
            滑条值.tag=1111;
            滑条值.textColor=[UIColor systemBlueColor];
            [父级视图5 addSubview:滑条值];
            
        }];
        
        [FengCheView 添加自定义视图:^(UIView * 父级视图6) {
            
            父级视图6.frame=CGRectMake(0, 0, 300, 40);
            父级视图6.backgroundColor=[UIColor clearColor];//随便设置个背景红色
            UILabel*滑条值2=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 40)];
            滑条值2.text=@"追踪圈圈半径";
            滑条值2.tag = 2222;
            滑条值2.textColor=[UIColor systemBlueColor];
            [父级视图6 addSubview:滑条值2];
            UISlider *mySlider1 = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, 160, 40)];
            mySlider1.minimumValue = 0.0;
            mySlider1.maximumValue = 300.0;
            mySlider1.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"追踪圈圈半径"];
            [mySlider1 addTarget:self action:@selector(追踪圆圈半径调用:) forControlEvents:UIControlEventValueChanged];
            [父级视图6 addSubview:mySlider1];
        }];
         
         
        
    }];
    [FengCheView 添加分组:@"物资绘制"  分组说明:@"物质绘制功能" 是否展开:NO 功能数:5 子功能:^{
        [FengCheView 添加开关:@"物资总开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            物资总开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"枪械物资开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            枪械物资开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"防具物资开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            防具物资开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"药品物资开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            药品物资开关 = 开关状态;
        }];
        [FengCheView 添加开关:@"车辆物资开关" 默认状态:NO 回调:^(BOOL 开关状态) {
//            车辆物资开关 = 开关状态;
        }];
       
    }];
    [FengCheView 添加分组:@"漏打功能"  分组说明:@"漏打功能：高级版解锁" 是否展开:NO 功能数:5  子功能:^{
       
        NSString *plistPath = @"/var/mobile/Library/Preferences/kk.plist";
        NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSNumber *switchState = preferences[@"自瞄总开关"]; // 请将键替换为实际的键
        
        [FengCheView 添加开关:@"自瞄开关" 默认状态:switchState 回调:^(BOOL 开关状态) {
//            自瞄开关 = 开关状态;
        }];

        [FengCheView 添加自定义视图:^(UIView * 父级视图8) {
            int aimPositionValue = [self readFloatValueForKey:@"自瞄位置"];
            父级视图8.frame= CGRectMake(0, 0, 300, 40);//这个尺寸为在单元格中的坐标系
            父级视图8.backgroundColor=[UIColor clearColor];//随便设置个背景红色
            UILabel*位置=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 40)];
            位置.text=@"自瞄位置";
            位置.textColor=[UIColor systemBlueColor];
            [父级视图8 addSubview:位置];
            NSArray *array2 = [NSArray arrayWithObjects:@"头",@"胸", @"腰",@"随机", nil];
            
            UISegmentedControl *segment2 = [[UISegmentedControl alloc]initWithItems:array2];
            segment2.frame = CGRectMake(150,5,160,30);
            segment2.apportionsSegmentWidthsByContent = YES;
            segment2.tag=2;
            [segment2 addTarget:self action:@selector(自瞄位置调用:) forControlEvents:UIControlEventValueChanged];
            // 从 plist 中读取自瞄位置的值并设置默认选中的选项
           
            if (aimPositionValue == 6) {
                segment2.selectedSegmentIndex = 0; // 头
            } else if (aimPositionValue == 2) {
                segment2.selectedSegmentIndex = 1; // 胸
            } else if (aimPositionValue == 3) {
                segment2.selectedSegmentIndex = 2; // 腰
            } else if (aimPositionValue == 0) {
                segment2.selectedSegmentIndex = 3; // 随机
            }
            [父级视图8 addSubview:segment2];
        }];
        
        [FengCheView 添加自定义视图:^(UIView * 父级视图9) {
            int 自瞄速度 = [self readFloatValueForKey:@"自瞄速度"];
            NSString *自瞄速度String = [NSString stringWithFormat:@"%d", 自瞄速度];
            父级视图9.frame =CGRectMake(0, 0, 300, 40);
            父级视图9.backgroundColor=[UIColor clearColor];
            UILabel*滑条值3=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 40)];
            滑条值3.text= [NSString stringWithFormat:@"自瞄速度: %@", 自瞄速度String];
            滑条值3.textColor=[UIColor systemBlueColor];
            [父级视图9 addSubview:滑条值3];
            UISlider *mySlider3 = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, 160, 40)];
            mySlider3.minimumValue = 0.0;
            mySlider3.maximumValue = 20.0;
            mySlider3.value = 自瞄速度;
            mySlider3.tag=3;
            [mySlider3 addTarget:self action:@selector(自瞄速度调用:) forControlEvents:UIControlEventValueChanged];
            [父级视图9 addSubview:mySlider3];
        }];
        
        [FengCheView 添加自定义视图:^(UIView * 父级视图10) {
            //指针内容
            int 自瞄范围 = [self readFloatValueForKey:@"自瞄范围"];
            NSString *自瞄范围String = [NSString stringWithFormat:@"%d", 自瞄范围];
            父级视图10.frame=CGRectMake(0, 0, 300, 40);
            父级视图10.backgroundColor=[UIColor clearColor];
            UILabel*滑条值4=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 40)];
            滑条值4.text= [NSString stringWithFormat:@"自瞄范围: %@", 自瞄范围String];
            滑条值4.textColor=[UIColor systemBlueColor];
            [父级视图10 addSubview:滑条值4];
            UISlider *mySlider4 = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, 160, 40)];
            mySlider4.minimumValue = 0.0;
            mySlider4.maximumValue = 150.0;
            mySlider4.value = 自瞄范围;
            mySlider4.tag=4;
            [mySlider4 addTarget:self action:@selector(自瞄范围调用:) forControlEvents:UIControlEventValueChanged];
            [父级视图10 addSubview:mySlider4];
        }];
       
        [FengCheView 添加自定义视图:^(UIView * 父级视图11) {
            int 自瞄距离 = [self readFloatValueForKey:@"自瞄距离"];
            NSString *自瞄距离String = [NSString stringWithFormat:@"%d", 自瞄距离];
            父级视图11.frame=CGRectMake(0, 0, 300, 40);//这个尺寸为在单元格中的坐标系
            父级视图11.backgroundColor=[UIColor clearColor];//随便设置个背景红色
            UILabel*滑条值5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 40)];
            滑条值5.text= [NSString stringWithFormat:@"自瞄距离: %@", 自瞄距离String];
            滑条值5.textColor = [UIColor systemBlueColor];
            [父级视图11 addSubview:滑条值5];
            UISlider *mySlider5 = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, 160, 40)];
            mySlider5.minimumValue = 0.0;
            mySlider5.maximumValue = 300.0;
            mySlider5.value = 自瞄距离;
            mySlider5.tag=5;
            [mySlider5 addTarget:self action:@selector(自瞄距离调用:) forControlEvents:UIControlEventValueChanged];
            [父级视图11 addSubview:mySlider5];
        }];
        
    }];
    
}

-(void)按钮调用{
//    验证信息=@"请稍后。。";
//    [FengCheView 刷新表格];
//    NSString*km=TextField.text;
//    [[NSUserDefaults standardUserDefaults] setObject:km forKey:@"km"];
//    [[WX_NongShiFu123 alloc] yanzhengAndUseIt:km];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [FengCheView 刷新表格];
//    });
    
    
}

- (void)追踪位置调用:(UISegmentedControl *)segmentedControl {
    // 获取当前选中的选项索引
    NSInteger index = segmentedControl.selectedSegmentIndex;
    UILabel *sliderValueLabel = (UILabel *)[[UIApplication sharedApplication].keyWindow viewWithTag:0001];
    // 根据选项索引执行相应操作
    switch (index) {
        case 0:
            // 执行选项一的操作
//            追踪位置=6;
            if (sliderValueLabel) {
                sliderValueLabel.text = @"追踪位置：头";
            }
            
            break;
        case 1:
            // 执行选项二的操作
//            追踪位置=2;
            if (sliderValueLabel) {
                sliderValueLabel.text = @"追踪位置：胸";
            }
            break;
        case 2:
            // 执行选项三的操作
//            追踪位置=3;
            if (sliderValueLabel) {
                sliderValueLabel.text = @"追踪位置：腰";
            }
            break;
        case 3:
            // 执行选项三的操作
//            追踪位置=48;
            if (sliderValueLabel) {
                sliderValueLabel.text = @"追踪位置：脚";
            }
            break;
        default:
            break;
    }
    
}

- (void)追踪距离调用:(UISlider *)slider {
//    追踪距离 = slider.value;
//    NSLog(@"追踪距离=%f",追踪距离);
//    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"追踪距离"];
//    UILabel *sliderValueLabel = (UILabel *)[[UIApplication sharedApplication].keyWindow viewWithTag:1111];
//    if (sliderValueLabel) {
//        sliderValueLabel.text = [NSString stringWithFormat:@"追踪距离:%.2f", slider.value];
//    }
}
- (void)追踪圆圈半径调用:(UISlider *)slider {
//    追踪圆圈半径 = slider.value;
//    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"追踪圆圈半径"];
//    UILabel *sliderValueLabel = (UILabel *)[[UIApplication sharedApplication].keyWindow viewWithTag:2222];
//    if (sliderValueLabel) {
//        sliderValueLabel.text = [NSString stringWithFormat:@"追踪半径:%.2f", slider.value];
//    }
}


- (void)自瞄位置调用:(UISegmentedControl *)sender {
    // 根据选择的 segment 确定要写入的值
    int valueToWrite = 0;
    switch (sender.selectedSegmentIndex) {
        case 0:  // 头
            valueToWrite = 6;
            break;
        case 1:  // 胸
            valueToWrite = 2;
            break;
        case 2:  // 腰
            valueToWrite = 3;
            break;
        case 3:  //随机
            valueToWrite = 0;
            break;
        default:
            break;
    }
    
    // 将获取的值写入 plist
    [self writeIntValue:valueToWrite forKey:@"自瞄位置"];
    
}
- (void)自瞄速度调用:(UISlider *)slider {
    // 更新 plist 的值
    int value = (int)slider.value;
    [self writeIntValue:value forKey:@"自瞄速度"];
    
    // 找到相应的标签并更新显示的值
    UILabel *sliderValueLabel = (UILabel *)[slider.superview viewWithTag:111];
    if (sliderValueLabel) {
        sliderValueLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
    }
}
- (void)自瞄范围调用:(UISlider *)slider {
    // 更新 plist 的值
    int value = (int)slider.value;
    [self writeIntValue:value forKey:@"自瞄范围"];
    
    // 找到相应的标签并更新显示的值
    UILabel *sliderValueLabel = (UILabel *)[slider.superview viewWithTag:222];
    if (sliderValueLabel) {
        sliderValueLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
    }
}
- (void)自瞄距离调用:(UISlider *)slider {
    // 更新 plist 的值
    int value = (int)slider.value;
    [self writeIntValue:value forKey:@"自瞄距离"];
    
    // 找到相应的标签并更新显示的值
    UILabel *sliderValueLabel = (UILabel *)[slider.superview viewWithTag:333];
    if (sliderValueLabel) {
        sliderValueLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
    }
}

- (NSDictionary *)loadSettingsFromPlist {
    return [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/kk.plist"];
}

- (void)writeBoolValueToFile:(BOOL)boolValue forKey:(NSString *)key {
    // 获取文件路径
    NSString *plistPath = @"/var/mobile/Library/Preferences/kk.plist";
    
    // 读取现有的plist文件数据
    NSMutableDictionary *existingData = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    if (!existingData) {
        existingData = [NSMutableDictionary dictionary];
    }
    
    // 设置要写入的BOOL值
    [existingData setObject:@(boolValue) forKey:key];
    
    // 将数据写入plist文件
    BOOL success = [existingData writeToFile:plistPath atomically:YES];
    
    if (success) {
      
    } else {
        NSLog(@"%@ 写入失败", key);
    }
}

- (void)writeIntValue:(int)value forKey:(NSString *)key {
    // 检查 key 是否为空
    if (!key || [key isEqualToString:@""]) {
        NSLog(@"空的 key，跳过写入操作");
        return;
    }

    // 获取文件路径
    NSString *plistPath = @"/var/mobile/Library/Preferences/kk.plist";
    
    // 读取现有的 plist 文件数据
    NSMutableDictionary *existingData = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    if (!existingData) {
        existingData = [NSMutableDictionary dictionary];
    }
    
    // 设置要写入的整数值
    [existingData setObject:@(value) forKey:key];
    
    // 将数据写入 plist 文件
    BOOL success = [existingData writeToFile:plistPath atomically:YES];
    
    if (success) {
        NSLog(@"%@ 写入成功", key);
    } else {
        NSLog(@"%@ 写入失败", key);
    }
}


- (BOOL)readBoolValueForKey:(NSString *)key {
    // 获取文件路径
    NSString *plistPath = @"/var/mobile/Library/Preferences/kk.plist";
    
    // 读取现有的 plist 文件数据
    NSDictionary *existingData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 检查是否存在该键，并且将其转换为布尔值
    id value = existingData[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    
    // 如果找不到键或者无法转换为布尔值，返回默认值（例如NO）
    return NO;
}


- (float)readFloatValueForKey:(NSString *)key {
    // 获取文件路径
    NSString *plistPath = @"/var/mobile/Library/Preferences/kk.plist";
    
    // 读取现有的 plist 文件数据
    NSDictionary *existingData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return [existingData[key] floatValue];
    
}

@end
