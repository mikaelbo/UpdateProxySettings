#import <Foundation/Foundation.h>
#import "WiFiProxyToggler.h"

int main(int argc, char **argv, char **envp) {
    if (argc == 3) {
        NSString *server = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding]; 
        int port;
        sscanf(argv[2],"%d",&port);
        [WiFiProxyToggler setProxy:server port:port];
    } else if (argc == 2) {
        NSString *argument = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
        if ([argument.lowercaseString isEqualToString:@"off"]) {
            [WiFiProxyToggler disableProxy];
        }
    }
	
	return 0;
}