
#import "ToastMessage.h"
#import "FCUIView.h"

@interface ToastMessage()
{
    UIViewController *m_view;
}
@end
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@implementation ToastMessage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 25.0f;
        self.alpha = 0.0f;//这里的透明度是将整个控件的透明度都改了，包括前景色
        /*
         * 不用这段代码：self.layer.backgroundColor = [UIColor blackColor].CGColor;而用下一行代码
         * 因为我希望，hud背景是半透明的，但是文字前景色是完全不透明的，所以需要将背景独立出来设置初始透明度
         */
//      self.layer.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0.4f].CGColor;
        self.layer.backgroundColor = [UIColor grayColor].CGColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

+(instancetype)shareHudWithTitle:(NSString*)title
{
    ToastMessage* hud = [[ToastMessage alloc] init];
    NSString* str = [NSString stringWithFormat:@"%@",title];
    hud.text = str;
    UIFont *font = [UIFont fontWithName:hud.font.fontName size:[UIFont labelFontSize]-3];
    hud.font = font;
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize detailSize = [str sizeWithAttributes:dict];
//    hud.frame = CGRectMake(80, 250, screenW*0.8, 50);
    if(detailSize.width > screenW){
        hud.numberOfLines = 0;
        hud.frame = CGRectMake(10, 250, screenW - 20, 80);
    }else{
        hud.frame = CGRectMake(80, 250, 80 + detailSize.width + 20, 50);
        hud.center = CGPointMake(screenW*0.5, screenH*0.5 - 70);
    }
    return hud;
}

-(void)show
{
    [UIView animateWithDuration:0.6
                     animations:^{ self.alpha = 1.0f; }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.6
                                               delay:1.5
                                             options:kNilOptions
                                          animations:^{ self.alpha = 0.0f; }
                                          completion:^(BOOL){
                                              [self removeFromSuperview];
                                          }];
                     }];
}

+(void)showMissMessage:(FCUIView*)view:(NSString*)message
{
    if([NSThread isMainThread])
    {
        ToastMessage *hud = [ToastMessage shareHudWithTitle:message];
        [view addSubview:hud];
        [hud show ];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            ToastMessage *hud = [ToastMessage shareHudWithTitle:message];
            [view addSubview:hud];
            [hud show ];
        });
    }
}

@end










