#import "ForegroundWatcher.h"

extern "C" int dsMapCreate();
extern "C" void dsMapAddString(int _dsMap, char* _key, char* _value);
extern "C" void createSocialAsyncEventWithDSMap(int dsmapindex);

@implementation ForegroundWatcher

- (void) subscribeApplicationEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void) appWillEnterForeground:(NSNotification*) notification {
    int dsMapIndex = dsMapCreate();
    dsMapAddString(dsMapIndex, "type", "ex_foreground_watcher");
    dsMapAddString(dsMapIndex, "data", "foreground");
    createSocialAsyncEventWithDSMap(dsMapIndex);
    NSLog(@"will enter foreground notification");
}

@end
