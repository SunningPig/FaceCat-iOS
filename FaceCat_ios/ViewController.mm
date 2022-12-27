/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#import "ViewController.h"
#import "FCUIView.h"
#include "DataCenter.h"
#import "SafeCompile.h"
#include "UIXmlEx.h"
#import "FCFile.h"
#import "MainFrame.h"

ViewController *instance;

@interface ViewController (){
    
}
@end

@implementation ViewController

//垃圾回收警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

/*
 窗口加载方法
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    FCTextBox::setMobile(true);
    instance = self;
    FCUIView *view = [[FCUIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size
                                                               .width, self.view.frame.size
                                                               .height)];
    [view setViewController:self];
    [self.view addSubview:view];
    [view onLoad:true];
    [view setAllowScroll:false];
    FCNative *native = [view getNative];
    DataCenter::startService();
    MainFrame *mainFrame = new MainFrame;
    mainFrame->setNative(native);
    String wPath = FCTran::stringToString(DataCenter::getAppPath()) + L"/mainframe.xml";
    mainFrame->loadFile(wPath, 0);
    native->update();
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}
@end
