

#import <UIKit/UIKit.h>
#import "FCUIView.h"

@interface ToastMessage : UILabel

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

+(instancetype)shareHudWithTitle:(NSString*)title;

+(instancetype)showMissMessage:(FCUIView*)view:(NSString*)message;

-(void)show;

@end
