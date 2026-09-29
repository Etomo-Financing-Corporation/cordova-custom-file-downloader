#import "CustomFileDownloader.h"
#import <UIKit/UIKit.h>

@interface CustomFileDownloader () <UIDocumentInteractionControllerDelegate>
@end

@implementation CustomFileDownloader

- (void)download:(CDVInvokedUrlCommand *)command
{
    NSString *urlString = [command.arguments objectAtIndex:0];
    NSString *customFileName = [command.arguments objectAtIndex:1];

    if (![urlString isKindOfClass:[NSString class]] || urlString.length == 0) {
        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                              messageAsString:@"Invalid URL"];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
        return;
    }

    if (![customFileName isKindOfClass:[NSString class]] ||
        customFileName.length == 0) {
        customFileName = @"download.pdf";
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

        NSString *finalFileName = customFileName;

        if (![finalFileName.pathExtension.lowercaseString isEqualToString:@"pdf"]) {
            finalFileName =
                [finalFileName stringByAppendingPathExtension:@"pdf"];
        }

        NSURL *destinationURL =
            [documentsDirectory URLByAppendingPathComponent:finalFileName];

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
    NSString *filePath = [command.arguments firstObject];

    if (![filePath isKindOfClass:[NSString class]] || filePath.length == 0) {
        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                              messageAsString:@"Invalid file path"];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
        return;
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                              messageAsString:@"PDF file does not exist"];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
        return;
    }

    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    dispatch_async(dispatch_get_main_queue(), ^{

        self.documentController =
            [UIDocumentInteractionController interactionControllerWithURL:fileURL];

        self.documentController.delegate = self;

        BOOL opened =
            [self.documentController presentPreviewAnimated:YES];

        if (!opened) {

            CDVPluginResult *result =
                [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                  messageAsString:@"Unable to open PDF viewer"];

            [self.commandDelegate sendPluginResult:result
                                        callbackId:command.callbackId];

            return;
        }

        CDVPluginResult *result =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                              messageAsString:@"PDF viewer opened"];

        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    });
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:
    (UIDocumentInteractionController *)controller
{
    return self.viewController;
}

@end
