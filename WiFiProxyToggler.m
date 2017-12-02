#import <Foundation/Foundation.h>
#import "WiFiProxyToggler.h"
#import "SCNetworkHeader.h"


@implementation WiFiProxyToggler

+ (void)setProxy:(NSString *)ipaddr port:(NSUInteger)port {
    [self setProxy:ipaddr port:port enabled:YES];
}

+ (void)disableProxy {
    [self setProxy:nil port:0 enabled:NO];
}

+ (void)setProxy:(NSString *)ipaddr port:(NSUInteger)port enabled:(BOOL)enabled {
    SCPreferencesRef prefRef = SCPreferencesCreate(NULL, CFSTR("test_proxy"), NULL);
    SCPreferencesLock(prefRef, true);
    CFStringRef currentSetPath = SCPreferencesGetValue(prefRef, kSCPrefCurrentSet);

    NSDictionary *currentSet = (__bridge NSDictionary *)SCPreferencesPathGetValue(prefRef, currentSetPath);

    if (currentSet) {
        NSDictionary *currentSetServices = currentSet[cfs2nss(kSCCompNetwork)][cfs2nss(kSCCompService)];
        NSDictionary *services = (__bridge NSDictionary *)SCPreferencesGetValue(prefRef, kSCPrefNetworkServices);

        NSString *wifiServiceKey = nil;
        for (NSString *key in currentSetServices) {
            NSDictionary *service = services[key];
            NSString *name = service[cfs2nss(kSCPropUserDefinedName)];
            if (service && [@"Wi-Fi" isEqualToString: name]) {
                wifiServiceKey = key;
                break;
            }
        }

        if (wifiServiceKey) {
            NSData *data = [NSPropertyListSerialization dataWithPropertyList:services
                                                                      format:NSPropertyListBinaryFormat_v1_0
                                                                     options:0
                                                                       error:nil];
            NSMutableDictionary *nservices = [NSPropertyListSerialization propertyListWithData:data
                                                                                       options:NSPropertyListMutableContainersAndLeaves
                                                                                        format:NULL
                                                                                         error:nil];
            NSMutableDictionary *proxies = nservices[wifiServiceKey][(__bridge NSString *)kSCEntNetProxies];
            [proxies setObject:enabled ? @(1) : @(0) forKey:cfs2nss(kSCPropNetProxiesHTTPEnable)];
            [proxies setObject:enabled ? @(1) : @(0) forKey:cfs2nss(kSCPropNetProxiesHTTPSEnable)];
            if (enabled) {
                if (ipaddr) {
                    [proxies setObject:ipaddr forKey:cfs2nss(kSCPropNetProxiesHTTPProxy)];
                    [proxies setObject:ipaddr forKey:cfs2nss(kSCPropNetProxiesHTTPSProxy)];    
                }
                [proxies setObject:@(port) forKey:cfs2nss(kSCPropNetProxiesHTTPPort)];
                [proxies setObject:@(port) forKey:cfs2nss(kSCPropNetProxiesHTTPSPort)];
            }
            SCPreferencesSetValue(prefRef, kSCPrefNetworkServices, (__bridge CFPropertyListRef)nservices);
            SCPreferencesCommitChanges(prefRef);
            SCPreferencesApplyChanges(prefRef);
        }
    }
    SCPreferencesUnlock(prefRef);
    CFRelease(prefRef);
}

@end
