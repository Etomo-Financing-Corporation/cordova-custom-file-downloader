#import "CustomFileDownloader.h"

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
