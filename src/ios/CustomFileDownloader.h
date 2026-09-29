```objc
#import <Cordova/Cordova.h>

@class UIDocumentInteractionController;

@interface CustomFileDownloader : CDVPlugin

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

- (void)download:(CDVInvokedUrlCommand *)command;
- (void)open:(CDVInvokedUrlCommand *)command;

@end
```
