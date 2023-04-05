

#import <UIKit/UIKit.h>
#import "FCUIView.h"

/*
 * 提示框
 */
@interface ToastMessage : UILabel
/*
 * 初始化
 */
- (instancetype)init;
/*
 * 根据矩形初始化
 */
- (instancetype)initWithFrame:(CGRect)frame;

/*
 * 设置标题
 */
+(instancetype)shareHudWithTitle:(NSString*)title;

/*
 * 显示
 */
+(instancetype)showMissMessage:(FCUIView*)view:(NSString*)message;

-(void)show;

@end
