#import "FlutterUserAgentPlugin.h"

@implementation FlutterUserAgentPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_useragent"
            binaryMessenger:[registrar messenger]];
  FlutterUserAgentPlugin* instance = [[FlutterUserAgentPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getProperties" isEqualToString:call.method]) {
      [self constantsToExport:^(NSDictionary * _Nonnull constants) {
          result(constants);
      }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@synthesize isEmulator;
@synthesize webView;

//eg. Darwin/16.3.0
- (NSString *)darwinVersion
{
    struct utsname u;
    (void) uname(&u);
    return [NSString stringWithUTF8String:u.release];
}

//eg. iPhone5,2
- (NSString *)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);

    NSString* deviceIdentifier = [NSString stringWithUTF8String:systemInfo.machine];
    
    #if TARGET_IPHONE_SIMULATOR
        deviceIdentifier = [NSString stringWithFormat:@"%s", getenv("SIMULATOR_MODEL_IDENTIFIER")];
        self.isEmulator = YES;
    #else
        self.isEmulator = NO;
    #endif

    static NSDictionary* deviceNames = nil;

    if (!deviceNames) {

       deviceNames = @{
    // iPhones
    @"iPhone1,1": @"iPhone",
    @"iPhone1,2": @"iPhone/3G",
    @"iPhone2,1": @"iPhone/3GS",
    @"iPhone3,1": @"iPhone/4",
    @"iPhone3,2": @"iPhone/4_GSM_Rev_A",
    @"iPhone3,3": @"iPhone/4_CDMA",
    @"iPhone4,1": @"iPhone/4S",
    @"iPhone5,1": @"iPhone/5_GSM",
    @"iPhone5,2": @"iPhone/5_GSM_CDMA",
    @"iPhone5,3": @"iPhone/5C_GSM",
    @"iPhone5,4": @"iPhone/5C_Global",
    @"iPhone6,1": @"iPhone/5S_GSM",
    @"iPhone6,2": @"iPhone/5S_Global",
    @"iPhone7,1": @"iPhone/6_Plus",
    @"iPhone7,2": @"iPhone/6",
    @"iPhone8,1": @"iPhone/6s",
    @"iPhone8,2": @"iPhone/6s_Plus",
    @"iPhone8,4": @"iPhone/SE_GSM",
    @"iPhone9,1": @"iPhone/7",
    @"iPhone9,2": @"iPhone/7_Plus",
    @"iPhone9,3": @"iPhone/7",
    @"iPhone9,4": @"iPhone/7_Plus",
    @"iPhone10,1": @"iPhone/8",
    @"iPhone10,2": @"iPhone/8_Plus",
    @"iPhone10,3": @"iPhone/X_Global",
    @"iPhone10,4": @"iPhone/8",
    @"iPhone10,5": @"iPhone/8_Plus",
    @"iPhone10,6": @"iPhone/X_GSM",
    @"iPhone11,2": @"iPhone/XS",
    @"iPhone11,4": @"iPhone/XS_Max",
    @"iPhone11,6": @"iPhone/XS_Max_Global",
    @"iPhone11,8": @"iPhone/XR",
    @"iPhone12,1": @"iPhone/11",
    @"iPhone12,3": @"iPhone/11_Pro",
    @"iPhone12,5": @"iPhone/11_Pro_Max",
    @"iPhone12,8": @"iPhone/SE_2nd_Gen",
    @"iPhone13,1": @"iPhone/12_Mini",
    @"iPhone13,2": @"iPhone/12",
    @"iPhone13,3": @"iPhone/12_Pro",
    @"iPhone13,4": @"iPhone/12_Pro_Max",
    @"iPhone14,2": @"iPhone/13_Pro",
    @"iPhone14,3": @"iPhone/13_Pro_Max",
    @"iPhone14,4": @"iPhone/13_Mini",
    @"iPhone14,5": @"iPhone/13",
    @"iPhone14,6": @"iPhone/SE_3rd_Gen",
    @"iPhone14,7": @"iPhone/14",
    @"iPhone14,8": @"iPhone/14_Plus",
    @"iPhone15,2": @"iPhone/14_Pro",
    @"iPhone15,3": @"iPhone/14_Pro_Max",
    @"iPhone15,4": @"iPhone/15",
    @"iPhone15,5": @"iPhone/15_Plus",
    @"iPhone16,1": @"iPhone/15_Pro",
    @"iPhone16,2": @"iPhone/15_Pro_Max",
    @"iPhone17,1": @"iPhone/16_Pro",
    @"iPhone17,2": @"iPhone/16_Pro_Max",
    @"iPhone17,3": @"iPhone/16",
    @"iPhone17,4": @"iPhone/16_Plus",

    // iPods
    @"iPod1,1": @"iPod/1st_Gen",  // iPod 1st Generation
    @"iPod2,1": @"iPod/2nd_Gen",  // iPod 2nd Generation
    @"iPod3,1": @"iPod/3rd_Gen",  // iPod 3rd Generation
    @"iPod4,1": @"iPod/4th_Gen",  // iPod 4th Generation
    @"iPod5,1": @"iPod/5th_Gen",  // iPod 5th Generation
    @"iPod7,1": @"iPod/6th_Gen",  // iPod 6th Generation
    @"iPod9,1": @"iPod/7th_Gen",  // iPod 7th Generation

    // iPads
    @"iPad1,1": @"iPad",
    @"iPad1,2": @"iPad_3G",
    @"iPad2,1": @"iPad/2nd_Gen",
    @"iPad2,2": @"iPad/2nd_Gen_GSM",
    @"iPad2,3": @"iPad/2nd_Gen_CDMA",
    @"iPad2,4": @"iPad/2nd_Gen_New_Revision",
    @"iPad3,1": @"iPad/3rd_Gen",
    @"iPad3,2": @"iPad/3rd_Gen_CDMA",
    @"iPad3,3": @"iPad/3rd_Gen_GSM",
    @"iPad2,5": @"iPad/Mini",
    @"iPad2,6": @"iPad/Mini_GSM_LTE",
    @"iPad2,7": @"iPad/Mini_CDMA_LTE",
    @"iPad3,4": @"iPad/4th_Gen",
    @"iPad3,5": @"iPad/4th_Gen_GSM_LTE",
    @"iPad3,6": @"iPad/4th_Gen_CDMA_LTE",
    @"iPad4,1": @"iPad_Air_WiFi",
    @"iPad4,2": @"iPad_Air_GSM_CDMA",
    @"iPad4,3": @"iPad_Air_China",
    @"iPad4,4": @"iPad_Mini_Retina_WiFi",
    @"iPad4,5": @"iPad_Mini_Retina_GSM_CDMA",
    @"iPad4,6": @"iPad_Mini_Retina_China",
    @"iPad4,7": @"iPad_Mini_3_WiFi",
    @"iPad4,8": @"iPad_Mini_3_GSM_CDMA",
    @"iPad4,9": @"iPad_Mini_3_China",
    @"iPad5,1": @"iPad_Mini_4_WiFi",
    @"iPad5,2": @"iPad_4th_Gen_Mini_WiFi_Cellular",
    @"iPad5,3": @"iPad_Air_2_WiFi",
    @"iPad5,4": @"iPad_Air_2_Cellular",
    @"iPad6,3": @"iPad_Pro_9.7_inch_WiFi",
    @"iPad6,4": @"iPad_Pro_9.7_inch_WiFi_LTE",
    @"iPad6,7": @"iPad_Pro_12.9_inch_WiFi",
    @"iPad6,8": @"iPad_Pro_12.9_inch_WiFi_LTE",
    @"iPad6,11": @"iPad_2017",
    @"iPad6,12": @"iPad_2017",
    @"iPad7,1": @"iPad_Pro_2nd_Gen_WiFi",
    @"iPad7,2": @"iPad_Pro_2nd_Gen_WiFi_Cellular",
    @"iPad7,3": @"iPad_Pro_10.5_inch_2nd_Gen",
    @"iPad7,4": @"iPad_Pro_10.5_inch_2nd_Gen",
    @"iPad7,5": @"iPad_6th_Gen_WiFi",
    @"iPad7,6": @"iPad_6th_Gen_WiFi_Cellular",
    @"iPad7,11": @"iPad_7th_Gen_10.2_inch_WiFi",
    @"iPad7,12": @"iPad_7th_Gen_10.2_inch_WiFi_Cellular",
    @"iPad8,1": @"iPad_Pro_11_inch_3rd_Gen_WiFi",
    @"iPad8,2": @"iPad_Pro_11_inch_3rd_Gen_1TB_WiFi",
    @"iPad8,3": @"iPad_Pro_11_inch_3rd_Gen_WiFi_Cellular",
    @"iPad8,4": @"iPad_Pro_11_inch_3rd_Gen_1TB_WiFi_Cellular",
    @"iPad8,5": @"iPad_Pro_12.9_inch_3rd_Gen_WiFi",
    @"iPad8,6": @"iPad_Pro_12.9_inch_3rd_Gen_1TB_WiFi",
    @"iPad8,7": @"iPad_Pro_12.9_inch_3rd_Gen_WiFi_Cellular",
    @"iPad8,8": @"iPad_Pro_12.9_inch_3rd_Gen_1TB_WiFi_Cellular",
    @"iPad8,9": @"iPad_Pro_11_inch_4th_Gen_WiFi",
    @"iPad8,10": @"iPad_Pro_11_inch_4th_Gen_WiFi_Cellular",
    @"iPad8,11": @"iPad_Pro_12.9_inch_4th_Gen_WiFi",
    @"iPad8,12": @"iPad_Pro_12.9_inch_4th_Gen_WiFi_Cellular",
    @"iPad11,1": @"iPad_Mini_5th_Gen_WiFi",
    @"iPad11,2": @"iPad_Mini_5th_Gen",
    @"iPad11,3": @"iPad_Air_3rd_Gen_WiFi",
    @"iPad11,4": @"iPad_Air_3rd_Gen",
    @"iPad11,6": @"iPad_8th_Gen_WiFi",
    @"iPad11,7": @"iPad_8th_Gen_WiFi_Cellular",
    @"iPad12,1": @"iPad_9th_Gen_WiFi",
    @"iPad12,2": @"iPad_9th_Gen_WiFi_Cellular",
    @"iPad14,1": @"iPad_Mini_6th_Gen_WiFi",
    @"iPad14,2": @"iPad_Mini_6th_Gen_WiFi_Cellular",
    @"iPad13,1": @"iPad_Air_4th_Gen_WiFi",
    @"iPad13,2": @"iPad_Air_4th_Gen_WiFi_Cellular",
    @"iPad13,4": @"iPad_Pro_11_inch_5th_Gen",
    @"iPad13,5": @"iPad_Pro_11_inch_5th_Gen",
    @"iPad13,6": @"iPad_Pro_11_inch_5th_Gen",
    @"iPad13,7": @"iPad_Pro_11_inch_5th_Gen",
    @"iPad13,8": @"iPad_Pro_12.9_inch_5th_Gen",
    @"iPad13,9": @"iPad_Pro_12.9_inch_5th_Gen",
    @"iPad13,10": @"iPad_Pro_12.9_inch_5th_Gen",
    @"iPad13,11": @"iPad_Pro_12.9_inch_5th_Gen",
    @"iPad13,16": @"iPad_Air_5th_Gen_WiFi",
    @"iPad13,17": @"iPad_Air_5th_Gen_WiFi_Cellular",
    @"iPad13,18": @"iPad_10th_Gen",
    @"iPad13,19": @"iPad_10th_Gen",
    @"iPad14,3": @"iPad_Pro_11_inch_4th_Gen",
    @"iPad14,4": @"iPad_Pro_11_inch_4th_Gen",
    @"iPad14,5": @"iPad_Pro_12.9_inch_6th_Gen",
    @"iPad14,6": @"iPad_Pro_12.9_inch_6th_Gen",
    @"iPad14,8": @"iPad_Air_6th_Gen",
    @"iPad14,9": @"iPad_Air_6th_Gen",
    @"iPad14,10": @"iPad_Air_7th_Gen",
    @"iPad14,11": @"iPad_Air_7th_Gen",
    @"iPad16,1": @"iPad_Mini_7th_Gen_WiFi",
    @"iPad16,2": @"iPad_Mini_7th_Gen_WiFi_Cellular",
    @"iPad16,3": @"iPad_Pro_11_inch_5th_Gen",
    @"iPad16,4": @"iPad_Pro_11_inch_5th_Gen",
    @"iPad16,5": @"iPad_Pro_12.9_inch_7th_Gen",
    @"iPad16,6": @"iPad_Pro_12.9_inch_7th_Gen"
    
    // Apple TVs
    @"AppleTV2,1": @"AppleTV",
    @"AppleTV3,1": @"AppleTV",
    @"AppleTV3,2": @"AppleTV",
    @"AppleTV5,3": @"AppleTV",
    @"AppleTV6,2": @"AppleTV_4K",
    @"AppleTV11,1": @"AppleTV_4K_2nd_Gen",
    @"AppleTV14,1": @"AppleTV_4K_3rd_Gen"
};


    }

     NSString* deviceName = [deviceNames objectForKey:deviceIdentifier];

     if (!deviceName) {
        if ([deviceIdentifier rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod";
        }
        else if([deviceIdentifier rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([deviceIdentifier rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else if([deviceIdentifier rangeOfString:@"AppleTV"].location != NSNotFound){
            deviceName = @"AppleTV";
        }
    }

    return deviceName;

}

- (void)getWebViewUserAgent:(void (^ _Nullable)(NSString * _Nullable webViewUserAgent, NSError * _Nullable error))completionHandler
{
    if (@available(ios 8.0, *)) {
        if (self.webView == nil) {
            // retain because `evaluateJavaScript:` is asynchronous
            self.webView = [[WKWebView alloc] init];
        }
        // Not sure if this is really neccesary
        [self.webView loadHTMLString:@"<html></html>" baseURL:nil];

        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:completionHandler];
    }
}

- (void)constantsToExport:(void  (^ _Nullable)(NSDictionary * _Nonnull constants))completionHandler
{
    UIDevice *currentDevice = [UIDevice currentDevice];

    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] ?: [NSNull null];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: [NSNull null];
    NSString *buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] ?: [NSNull null];
    NSString *darwinVersion = [self darwinVersion];
    NSString *cfnVersion = [NSBundle bundleWithIdentifier:@"com.apple.CFNetwork"].infoDictionary[@"CFBundleShortVersionString"];
    NSString *deviceName = [self deviceName];

    NSString *userAgent = [NSString stringWithFormat:@"CFNetwork/%@ Darwin/%@ (%@ %@/%@)", cfnVersion, darwinVersion, deviceName, currentDevice.systemName, currentDevice.systemVersion];

    [self getWebViewUserAgent:^(NSString * _Nullable webViewUserAgent, NSError * _Nullable error) {
        completionHandler(@{
          @"isEmulator": @(self.isEmulator),
          @"systemName": currentDevice.systemName,
          @"systemVersion": currentDevice.systemVersion,
          @"applicationName": appName,
          @"applicationVersion": appVersion,
          @"buildNumber": buildNumber,
          @"darwinVersion": darwinVersion,
          @"cfnetworkVersion": cfnVersion,
          @"deviceName": deviceName,
          @"packageUserAgent": [NSString stringWithFormat:@"%@/%@.%@ %@", appName, appVersion, buildNumber, userAgent],
          @"userAgent": userAgent,
          @"webViewUserAgent": webViewUserAgent ?: [NSNull null]
        });
    }];
}

@end
