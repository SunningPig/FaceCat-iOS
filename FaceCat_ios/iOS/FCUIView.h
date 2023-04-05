/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#ifndef FCUIVIEW_h
#define FCUIVIEW_h
#import <UIKit/UIKit.h>
#include "IOSHost.h"
#import <WebKit/WebKit.h>

/*
 * 原生视图
 */
@interface FCUIView : UIView<UITextFieldDelegate>
/*
 * 获取设备
 */
-(IOSHost*)getHost;
/*
 * 获取方法库
 */
-(FCNative*)getNative;
/*
 * 获取绘图对象
 */
-(FCPaint*)getPaint;
/*
 * 获取上次焦点的视图
 */
-(FCView*)getLastFocusedView;
/*
 * 获取输入文本框
 */
-(UITextField*)getUITextField;
/*
 * 加载方法
 */
-(void)onLoad:(bool)allowZoom;
/*
 * 绘图方法
 * @param rect 矩形
 */
-(void)onPaint:(CGRect)rect;
/*
 * 设置滚动视图
 */
-(void)setScrollView:(UIScrollView*)scrollView;
/*
 * 获取滚动视图
 */
-(UIScrollView*)getScrollView;
/*
 * 设置是否允许滚动
 */
-(void)setAllowScroll:(bool)allowScroll;
/*
 * 添加WebView
 */
-(void)addWebView:(WKWebView*)webView;
/*
 * 是否包含视图
 */
-(BOOL)containsView:(UIView*)view;
/*
 * 获取缩放比例
 */
-(double)getScaleFactor;
/*
 * 设置缩放比例
 */
-(void)setScaleFactor:(double)scaleFactor;
/*
 * 获取系统主视图
 */
-(UIViewController*)getViewController;
/*
 * 设置系统主视图
 */
-(void)setViewController:(UIViewController*)viewController;
@end


#endif
