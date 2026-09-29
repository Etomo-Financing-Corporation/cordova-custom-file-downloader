
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>

@interface CustomFileDownloader : CDVPlugin

- (void)download:(CDVInvokedUrlCommand *)command;

@end

@implementation CustomFileDownloader

- (void)download:(CDVInvokedUrlCommand *)command
{
    NSString *urlString = [command.arguments firstObject];

    if (![urlString isKindOfClass:[NSString class]] || urlString.length == 0) {

        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                              messageAs:@"Invalid URL"];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
        return;
    }

    NSURL *url = [NSURL URLWithString:urlString];

    if (!url) {

        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                              messageAs:@"Invalid URL"];

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
                                  messageAs:error.localizedDescription];

            [self.commandDelegate sendPluginResult:result
                                        callbackId:command.callbackId];
            return;
        }

        if (!location) {

            CDVPluginResult *result =
                [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                  messageAs:@"Downloaded file location is unavailable"];

            [self.commandDelegate sendPluginResult:result
                                        callbackId:command.callbackId];
            return;
        }

        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSURL *documentsDirectory =
            [fileManager URLsForDirectory:NSDocumentDirectory
                                inDomains:NSUserDomainMask].firstObject;

        NSString *fileName = response.suggestedFilename;

        if (fileName.length == 0) {
            fileName = @"download.pdf";
        }

        NSURL *destinationURL =
            [documentsDirectory URLByAppendingPathComponent:fileName];

        NSError *fileError = nil;

        if ([fileManager fileExistsAtPath:destinationURL.path]) {
            [fileManager removeItemAtURL:destinationURL error:&fileError];

            if (fileError) {

                CDVPluginResult *result =
                    [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                      messageAs:fileError.localizedDescription];

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
                                  messageAs:fileError.localizedDescription];

            [self.commandDelegate sendPluginResult:result
                                        callbackId:command.callbackId];
            return;
        }

        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                              messageAs:destinationURL.absoluteString];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    }];

    [task resume];
}

@end
