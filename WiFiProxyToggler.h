#import <Foundation/Foundation.h>

@interface WiFiProxyToggler : NSObject

+ (void)setProxy:(NSString *)ipaddr port:(NSUInteger)port;
+ (void)disableProxy;

@end