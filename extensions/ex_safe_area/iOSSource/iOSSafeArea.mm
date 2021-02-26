#import "iOSSafeArea.h"

@implementation iOSSafeArea

@synthesize topPadding, bottomPadding, leftPadding, rightPadding;

- (NSString *) get_safe_area {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat screenScale = [[UIScreen mainScreen] nativeScale];
        topPadding = window.safeAreaInsets.top * screenScale;
        bottomPadding = window.safeAreaInsets.bottom * screenScale;
        leftPadding = window.safeAreaInsets.left * screenScale;
        rightPadding = window.safeAreaInsets.right * screenScale;

        NSString *retString = [NSString stringWithFormat:@"%@%f%@%f%@%f%@%f%@", @"{\"detected\":1,\"top\":", topPadding, @",\"bottom\":", bottomPadding, @",\"left\":", leftPadding, @",\"right\":", rightPadding, @"}"];
        return retString;
    } else {
        topPadding = 0.0;
        bottomPadding = 0.0;
        leftPadding = 0.0;
        rightPadding = 0.0;

        return @"{\"detected\":0,\"top\":0,\"bottom\":0,\"left\":0,\"right\":0";
    }
}
@end
