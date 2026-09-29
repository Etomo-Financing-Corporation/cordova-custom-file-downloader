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

        if ([fileManager fileExists]()
