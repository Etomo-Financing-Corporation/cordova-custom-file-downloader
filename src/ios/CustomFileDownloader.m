#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cordova/Cordova.h>

@interface CustomFileDownloader : CDVPlugin

- (void)download:(CDVInvokedUrlCommand *)command;

@end

@implementation CustomFileDownloader

- (void)download:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *result =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                          messageAsString:@"NATIVE METHOD REACHED"];

    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}

@end
