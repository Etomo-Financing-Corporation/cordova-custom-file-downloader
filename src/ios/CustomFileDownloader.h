#import <Cordova/Cordova.h>

@interface CustomFileDownloader : CDVPlugin

- (void)download:(CDVInvokedUrlCommand *)command;

@end
