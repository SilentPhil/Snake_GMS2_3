#import <AVFoundation/AVFoundation.h>

@interface ForegroundWatcher : UIViewController
- (void) subscribeApplicationEvents;
- (void) enterForeground:(NSNotification*) notification;
@end
