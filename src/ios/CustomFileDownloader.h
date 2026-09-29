#import <Cordova/Cordova.h>
#import <UIKit/UIKit.h>

@interface CustomFileDownloader : CDVPlugin

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

- (void)download:(CDVInvokedUrlCommand *)command;
- (void)open:(CDVInvokedUrlCommand *)command;

@end
