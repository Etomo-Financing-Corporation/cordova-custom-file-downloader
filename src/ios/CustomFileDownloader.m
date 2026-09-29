#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>

@interface CustomFileDownloader : CDVPlugin

@end

@implementation CustomFileDownloader

CDV_EXPORT_METHOD(download:)

- (void)download:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *result =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                          messageAsString:@"NATIVE METHOD REACHED"];

    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}

@end
