//
//  MacroDefinition.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/15.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

//导航栏 、系统状态栏高度
#define NAV_BAR_HEIGHT 44.0f
#define SYS_STATUS_BAR_HEIGHT 20.0f
#define HETHT_64 64.0f

//获取屏幕 宽度、高度
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CURRENT_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CURRENT_LANUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending).
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(N) [UIImage imageNamed:N]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define RGB_WHITE [UIColor whiteColor]
#define RGB_BLACK [UIColor blackColor]

#define RGB_PRIMARY RGBA(107.0f, 190.0f, 122.0f, 0.8f)
#define RGB_PRIMARY_A(a) RGBA(107.0f, 190.0f, 122.0f, a)
#define RGB_LINE_COLOR RGB(188.0f, 188.0f, 188.0f)
#define RGB_TEXT_COLOR RGB(128.0f, 128.0f, 128.0f)
#define RGB_TEXT_COLOR_2 RGB(153.0f, 153.0f,153.0f)
#define RGB_PRIMARY_GRAY RGBA(241.0f, 241.0f, 241.0f, 1.0f)

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

//系统默认字体
#define FONT(F) [UIFont systemFontOfSize:F]
#define FONT_BOLD(F) [UIFont boldSystemFontOfSize:F]

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//输出
#ifdef DEBUG

#define NSLog_INFO(xx, ...) NSLog(xx, ##__VA_ARGS__)
#define NSLog_DEBUG(xx, ...) NSLog(@"%@ %s %d: " xx, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __func__, __LINE__, ##__VA_ARGS__)

#else

#define NSLog_INFO(xx, ...)
#define NSLog_DEBUG(xx, ...)

#endif

//custom window level
#define UIWindowLevelHighestPriorit UIWindowLevelStatusBar + 1

//
#define USER_DEFAULT  [NSUserDefaults standardUserDefaults]
#define NSNOTIFY_CENTER [NSNotificationCenter defaultCenter]

#define APP_DELEGATE   (AppDelegate*)[[UIApplication sharedApplication] delegate]

//misc
#define IS_IPHONE_6_PLUS (fabs((double)    [[UIScreen mainScreen] bounds].size.height - (double)736.0f) < DBL_EPSILON)//判断是否是iPhone6 plus
#define IS_IPHONE_6      (fabs((double)    [[UIScreen mainScreen] bounds].size.height - (double)667.0f) < DBL_EPSILON)//判断是否是iPhone6
#define IS_IPHONE_5      (fabs((double)    [[UIScreen mainScreen] bounds].size.height - (double)568.0f) < DBL_EPSILON)//判断是否iPhone5
#define IS_IPHONE_4S     (fabs((double)    [[UIScreen mainScreen] bounds].size.height - (double)480.0f) < DBL_EPSILON)//判断是否是iPhone4s

#define IS_IOS_VENSION_8 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)//是否是iOS 8

#define MAIN_BLOCK(block) dispatch_async(dispatch_get_main_queue(), block)
#define DEFAULT_BLOCK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define STR(key) NSLocalizedString(key, @"")



#endif /* MacroDefinition_h */
