#import "PhotoEditorPlugin.h"
#if __has_include(<photo_editor/photo_editor-Swift.h>)
#import <photo_editor/photo_editor-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "photo_editor-Swift.h"
#endif

@implementation PhotoEditorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhotoEditorPlugin registerWithRegistrar:registrar];
}
@end
