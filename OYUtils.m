//
//  OYUtils.m
//  AnlatBanaNew
//
//  Created by Orcun Yuksel on 20/06/2017.
//  Copyright © 2017 Orçun Yüksel. All rights reserved.
//

#import "OYUtils.h"
#import <sys/utsname.h>

static OYUtils *_shared = nil;

@implementation OYUtils

+ (BOOL)isTest{
#ifdef DEBUG
    return true;
#endif
    return false;
}

+ (BOOL)isEmptyOrNullString:(NSString *)string{
    if ((NSNull*)string == [NSNull null]){
        return YES;
    }
    
    if ([string respondsToSelector:@selector(length)])
        return [string length] == 0;
    else return YES;
}

+ (BOOL)isValidUrl: (NSString *) candidate{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

+ (BOOL)isValidEmail:(NSString *)checkString{
    if([OYUtils isEmptyOrNullString:checkString]){
        return NO;
    }
    
    checkString = [checkString lowercaseString];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL)isValidPhoneNumber:(NSString *)checkString{
    if([OYUtils isEmptyOrNullString:checkString]){
        return NO;
    }
    
    NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:checkString];
}

+ (BOOL)IsValidPasswordFormat:(NSString *)checkString{
    if([OYUtils isEmptyOrNullString:checkString]){
        return NO;
    }
    
    NSString *checkRegex = @"^[a-zA-Z0-9\\-\\._!# ]{6,32}$";
    NSPredicate *checkPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", checkRegex];
    return [checkPredicate evaluateWithObject: checkString];
}

+ (CGSize)getScreenSize{
    float SW;
    float SH;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (( [[[UIDevice currentDevice] systemVersion] floatValue]<8)  && UIInterfaceOrientationIsLandscape(orientation)){
        SW = [[UIScreen mainScreen] bounds].size.height;
        SH = [[UIScreen mainScreen] bounds].size.width;
    }else{
        SW = [[UIScreen mainScreen] bounds].size.width;
        SH = [[UIScreen mainScreen] bounds].size.height;
    }
    return CGSizeMake(SW, SH);
}

+ (void)pushViewController:(UIViewController *)vc withStoryboardName:(NSString *)storyboard withIdentifier:(NSString *)identifier{
    [vc.navigationController pushViewController:[[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identifier] animated:YES];
}

+ (void)activateEdgeSwipe:(UIViewController *)vc isActive:(BOOL)active{
    if (active) {
        vc.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)vc;
        vc.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
    } else{
        vc.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

+ (UIAlertController *)showAlertMessage:(NSString *)message
                              withTitle:(NSString *)title
                          okButtonTitle:(NSString *)okTitle
                  withCancelButtonTitle:(NSString *)cancelTitle{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    
    if (![OYUtils isEmptyOrNullString:cancelTitle]){
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        
        [alert addAction:cancelAction];
    }
    
    [alert addAction:okAction];
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];

    return alert;
}

+ (void)setView:(UIView*)view hidden:(BOOL)hidden withOptions:(UIViewAnimationOptions)option animationDuration:(double)duration{
    [UIView transitionWithView:view duration:duration options:option animations:^(void){
        [view setHidden:hidden];
    } completion:nil];
}

#pragma mark - Date
//========================================================================
+ (NSString *)dateToStringAndTime:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SZ";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getTimeFromEpoch:(NSDate *)date{
    return [NSString stringWithFormat:@"%.f", [date timeIntervalSince1970]];
}

+ (NSString *)timeDiffrenceFromDate:(NSDate *)from{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:kCFCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:from toDate:[NSDate date] options:0];
    
    if (components.day > 0) {
        return [NSString stringWithFormat:@"%li gün",components.day];
    } else if (components.hour > 0){
        return [NSString stringWithFormat:@"%li saat",components.hour];
    } else if (components.minute > 0){
        return [NSString stringWithFormat:@"%li dk.",components.minute];
    } else{
        return @"1 dk.";
    }
}

+ (NSString *)timeFromString:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SZ";
    
    NSDate *thisTime = [dateFormatter dateFromString:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:kCFCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:thisTime];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    return [NSString stringWithFormat:@"%li:%li",hour,minute];
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd.MM.yyyy";
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SZ";
    return [dateFormatter dateFromString:date];
}

+(OYUtils *)sharedObject{
    @synchronized([OYUtils class]){
        if(!_shared) {
            (void)[[self alloc] init];
        }
        return _shared;
    }
    return nil;
}

#pragma mark - Shared Object Singleton
//========================================================================
+(id) alloc {
    @synchronized([OYUtils class]) {
        NSAssert(_shared == nil, @"Attempted to allocate second instance");
        _shared = [super alloc];
        return _shared;
    }
    return nil;
}

+(id) init {
    [super init];
    if(self != nil) {
    }
    return self;
}

//#pragma mark - Google Analytics
////========================================================================
//+ (void)analyticsSetScreenName:(NSString *)name{
//    [FIRAnalytics setScreenName:name screenClass:nil];
//}
//
//+ (void)analyticsLogEventWithName:(NSString *)name{
//    [FIRAnalytics logEventWithName:kFIREventSelectContent
//                        parameters:@{
//                                     kFIRParameterItemID:name
//                                     }];
//}
//
//+ (void)analyticsSetUserProperty:(NSString *)property forName:(NSString *)name{
//    [FIRAnalytics setUserPropertyString:property forName:name];
//}

#pragma mark - Device
//========================================================================
+ (NSString *)deviceNameComputer{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)deviceNameHuman{
    struct utsname systemInfo;
    static NSDictionary* deviceNamesByCode = nil;
    uname(&systemInfo);
    
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if (!deviceNamesByCode) {
        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              
                              @"iPod1,1"   : @"iPod Touch",        // (Original)
                              @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad 2",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone 4",          // (GSM)
                              @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone 4S",         //
                              @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone 6 Plus",     //
                              @"iPhone7,2" : @"iPhone 6",          //
                              @"iPhone8,1" : @"iPhone 6S",         //
                              @"iPhone8,2" : @"iPhone 6S Plus",    //
                              @"iPhone8,4" : @"iPhone SE",         //
                              @"iPhone9,1" : @"iPhone 7",          //
                              @"iPhone9,3" : @"iPhone 7",          //
                              @"iPhone9,2" : @"iPhone 7 Plus",     //
                              @"iPhone9,4" : @"iPhone 7 Plus",     //
                              @"iPhone10,1": @"iPhone 8",          // CDMA
                              @"iPhone10,4": @"iPhone 8",          // GSM
                              @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                              @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                              @"iPhone10,3": @"iPhone X",          // CDMA
                              @"iPhone10,6": @"iPhone X",          // GSM
                              
                              @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    NSString *deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        } else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        } else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        } else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}

@end
