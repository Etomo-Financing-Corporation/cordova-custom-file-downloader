#import "CustomFileDownloader.h"
#import <UIKit/UIKit.h>

@implementation CustomFileDownloader

- (void)download:(CDVInvokedUrlCommand *)command
{
    NSString *urlString = [command.arguments firstObject];

    if (![urlString isKindOfClass:[NSString class]] || urlString.length == 0) {
        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                              messageAsString:@"Invalid URL"];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
        return;
    }

    NSURL *url = [NSURL URLWithString:urlString];

    if (!url) {
        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                              messageAsString:@"Invalid URL"];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
        return;
    }

    NSURLSessionDownloadTask *task =
        [[NSURLSession sharedSession]
            downloadTaskWithURL:url
            completionHandler:^(NSURL *location,
                                NSURLResponse *response,
                                NSError *error) {

        if (error) {
            CDVPluginResult *result =
                [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                  messageAsString:error.localizedDescription];

            [self.commandDelegate sendPluginResult:result
                                        callbackId:command.callbackId];
            return;
        }

        if (!location) {
            CDVPluginResult *result =
                [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                  messageAsString:@"Downloaded file location is unavailable"];

            [self.commandDelegate sendPluginResult:result
                                        callbackId:command.callbackId];
            return;
        }

        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSURL *documentsDirectory =
            [fileManager URLsForDirectory:NSDocumentDirectory
                                inDomains:NSUserDomainMask].firstObject;

        if (!documentsDirectory) {
            CDVPluginResult *result =
                [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                  messageAsString:@"Documents directory is unavailable"];

            [self.commandDelegate sendPluginResult:result
                                        callbackId:command.callbackId];
            return;
        }

        NSString *fileName = response.suggestedFilename;

        if (fileName.length == 0) {
            fileName = @"download.pdf";
        }

        if (![fileName.pathExtension.lowercaseString isEqualToString:@"pdf"]) {
            fileName = [fileName stringByAppendingPathExtension:@"pdf"];
        }

        NSURL *destinationURL =
            [documentsDirectory URLByAppendingPathComponent:fileName];

        NSError *fileError = nil;

        if ([fileManager fileExistsAtPath:destinationURL.path]) {

            [fileManager removeItemAtURL:destinationURL
                                    error:&fileError];

            if (fileError) {
                CDVPluginResult *result =
                    [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                      messageAsString:fileError.localizedDescription];

                [self.commandDelegate sendPluginResult:result
                                            callbackId:command.callbackId];
                return;
            }
        }

        [fileManager moveItemAtURL:location
                             toURL:destinationURL
                             error:&fileError];

        if (fileError) {
            CDVPluginResult *result =
                [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                  messageAsString:fileError.localizedDescription];

            [self.commandDelegate sendPluginResult:result
                                        callbackId:command.callbackId];
            return;
        }

        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                              messageAsString:destinationURL.path];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    }];

    [task resume];
}

- (void)open:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *result =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                          messageAsString:@"OPEN NATIVE METHOD REACHED"];

    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}

@end
```

Build this exact version.

**Don't change the JavaScript.** If the build succeeds, run the test again. We specifically want to see whether the third alert becomes:

`OPEN SUCCESS — OPEN NATIVE METHOD REACHED`

That will tell us whether `open()` itself is being dispatched.
