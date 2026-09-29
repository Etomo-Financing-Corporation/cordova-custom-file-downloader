#import <Cordova/Cordova.h>

@interface CustomFileDownloader : CDVPlugin

@property (nonatomic, strong) NSURL *previewFileURL;

- (void)download:(CDVInvokedUrlCommand *)command;
- (void)open:(CDVInvokedUrlCommand *)command;

@end
