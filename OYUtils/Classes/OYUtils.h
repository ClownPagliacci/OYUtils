//
//  OYUtils.h
//  AnlatBanaNew
//
//  Created by Orcun Yuksel on 20/06/2017.
//  Copyright © 2017 Orçun Yüksel. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MBProgressHUD/MBProgressHUD.h>

//@import Firebase;

@interface OYUtils : NSObject

//#define SHOW_HUD [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
//#define HIDE_HUD [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define SYSTEM_NAME [[UIDevice currentDevice] systemName]
#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion],

#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_BUILD_NUMBER [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define DEVICE_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define DEVICE_NAME [OYUtils deviceNameHuman]
#define DEVICE_TYPE [OYUtils deviceNameComputer]

#define OLOG(x) NSLog(@"🍎🍎🍎🍎🍎 --- %@",x)
#define OLOG_F(x) NSLog(@"🍏🍏🍏🍏🍏 --- %f",x)
#define OLOG_I(x) NSLog(@"🍏🍏🍏🍏🍏 --- %i",x)

+ (BOOL)isTest;
+ (BOOL)isValidUrl: (NSString *) candidate;
+ (BOOL)isValidEmail:(NSString *)checkString;
+ (BOOL)isValidPhoneNumber:(NSString *)checkString;
+ (BOOL)IsValidPasswordFormat : (NSString *)checkString;
+ (BOOL)isEmptyOrNullString:(NSString *)string;

+ (CGSize)getScreenSize;
+ (void)activateEdgeSwipe:(UIViewController *)vc isActive:(BOOL)active;
+ (void)pushViewController:(UIViewController *)vc withStoryboardName:(NSString *)storyboard withIdentifier:(NSString *)identifier;
+ (void)setView:(UIView*)view hidden:(BOOL)hidden withOptions:(UIViewAnimationOptions)option animationDuration:(double)duration;
+ (UIAlertController *)showAlertMessage:(NSString *)message
                              withTitle:(NSString *)title
                          okButtonTitle:(NSString *)okTitle
                  withCancelButtonTitle:(NSString *)cancelTitle;

#pragma mark - Date
//========================================================================
+ (NSString *)dateToStringAndTime:(NSDate *)date;
+ (NSString *)getTimeFromEpoch:(NSDate *)date;
+ (NSString *)timeDiffrenceFromDate:(NSDate *)from;
+ (NSString *)timeFromString:(NSString *)date;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)date;

#pragma mark - Device
//========================================================================
+ (NSString *)deviceNameComputer;
+ (NSString *)deviceNameHuman;

#pragma mark - Google Analytics
//========================================================================
//+ (void)analyticsSetScreenName:(NSString *)name;
//+ (void)analyticsLogEventWithName:(NSString *)name;
//+ (void)analyticsSetUserProperty:(NSString *)property forName:(NSString *)name;

#pragma mark - Shared Object Singleton
//========================================================================
+ (OYUtils *)sharedObject;

@property (nonatomic,strong) NSDictionary *selectedCategory;
@property (nonatomic) BOOL isPaymentView;

@end
