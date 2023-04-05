#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenObject : NSObject

//判断刘海屏，返回YES表示是 非刘海屏   NO刘海屏
+ (BOOL)isNotchScreen;

@end

NS_ASSUME_NONNULL_END
