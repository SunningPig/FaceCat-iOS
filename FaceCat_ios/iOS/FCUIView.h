/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#ifndef FCUIVIEW_h
#define FCUIVIEW_h
#import <UIKit/UIKit.h>
#include "IOSHost.h"
#import <WebKit/WebKit.h>

@interface FCUIView : UIView<UITextFieldDelegate>
-(IOSHost*)getHost;
-(FCNative*)getNative;
-(FCPaint*)getPaint;
-(FCView*)getLastFocusedView;
-(UITextField*)getUITextField;
-(void)onLoad:(bool)allowZoom;
-(void)onPaint:(CGRect)rect;
-(void)setScrollView:(UIScrollView*)scrollView;
-(UIScrollView*)getScrollView;
-(void)setAllowScroll:(bool)allowScroll;
-(void)addWebView:(WKWebView*)webView;
-(BOOL)containsView:(UIView*)view;
-(double)getScaleFactor;
-(void)setScaleFactor:(double)scaleFactor;
-(UIViewController*)getViewController;
-(void)setViewController:(UIViewController*)viewController;
@end


#endif
