/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#import <Foundation/Foundation.h>
#import "FCUIView.h"
#include "UIXmlEx.h"
#include "SYDatePicker.h"
#include "DataCenter.h"
#include "DateTimeButton.h"

#define USE_INVISIBLE_SHOWTEXTBOX_TODD

@interface FCUIView ()<SYDatePickerDelegate>
{
    bool m_allowScroll;
    ContextPaintEx *m_ContextPaintEx;
    //UIDatePicker *m_datePicker;
    SYDatePicker *m_datePicker;
    DateTimeButton *m_editingDateTimeButton;
    FCTextBox *m_editingTextBox;
    IOSHost *m_host;
    FCNative *m_native;
    FCPaint *m_paint;
    UIScrollView *m_scrollView;
    UITextField *m_textBox;
    ArrayList<WKWebView*> m_webViews;
    FCLock m_webViewsLock;
    FCView *m_oldFocusedControl;
    double m_scaleFactor;
    UIViewController *m_viewController;
    void *m_menuTarget;
}
@end

@implementation FCUIView

- (void)printString:(NSString*)paramString{
    if(m_host){
        m_host->onTimer();
        [self performSelector : @selector (printString : ) withObject : @ "" afterDelay : 0.01 ];
    }
}

-(void)setAllowScroll: (bool)allowScroll
{
    m_allowScroll = allowScroll;
}

-(void)drawRect:(CGRect)rect
{
    [self onPaint:rect];
}

-(IOSHost*)getHost
{
    return m_host;
}

-(FCNative*)getNative
{
    return m_native;
}

-(FCPaint*)getPaint
{
    return m_paint;
}

-(FCView*)getLastFocusedView{
    return m_oldFocusedControl;
}

-(UITextField*)getUITextField{
    return m_textBox;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetLayout];
}

-(double)getScaleFactor{
    return m_scaleFactor;
}

-(void)setScaleFactor:(double)scaleFactor{
    m_scaleFactor = scaleFactor;
    [self resetLayout];
}

-(void)resetLayout
{
    if(m_native)
    {
        FCSize oldScaleSize = m_native->getScaleSize();
        FCSize size = IOSHost::getSize(self.frame.size);
        if(m_scaleFactor == 0){
            NSString *deviceType = [UIDevice currentDevice].model;
            if([deviceType isEqualToString:@"iPhone"]) {
                //iPhone
                m_scaleFactor = 1;
            }
            else if([deviceType isEqualToString:@"iPod touch"]) {
                //iPod Touch
                m_scaleFactor = 1;
            }
            else if([deviceType isEqualToString:@"iPad"]) {
                //iPad
                m_scaleFactor = 1.6;
            }else{
                m_scaleFactor = 1;
            }
        }
        double rate = m_scaleFactor;
        if(m_host->getAllowZoom())
        {
            FCSize scaleSize = {(int)(size.cx / rate), (int)(size.cy / rate)};
            if(oldScaleSize.cx != scaleSize.cx || oldScaleSize.cy != scaleSize.cy)
            {
                if(rate != 1.0)
                {
                    m_native->setAllowScaleSize(true);
                }else{
                    m_native->setAllowScaleSize(false);
                }
                m_native->setScaleSize(scaleSize);
                m_native->update();
            }
        }
    }
}

-(void)onLoad:(bool)allowZoom
{
    m_allowScroll = true;
    if(!m_native)
    {
        m_native = new FCNative;
        m_host = new IOSHost;
        m_host->setAllowZoom(allowZoom);
        m_ContextPaintEx = new ContextPaintEx;
        m_paint = m_ContextPaintEx;
        m_native->setHost(m_host);
        m_native->setPaint(m_ContextPaintEx);
        m_host->setNative(m_native);
        m_host->setView(self);
        FCSize size = IOSHost::getSize(self.frame.size);
        m_native->setSize(size);
        m_native->update();
        [self resetLayout];
        [self performSelector : @selector (printString : ) withObject : @ "" afterDelay : 0.01 ];
        [self performSelector : @selector (printString : ) withObject : @ "" afterDelay : 0.01 ];
        //增加监听，当键盘出现或改变时收出消息
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
            
            //增加监听，当键退出时收出消息
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
    }
}

-(void)onPaint:(CGRect)rect
{
    int width = rect.size.width, height = rect.size.height;
    if(m_host)
    {
        FCRect pRect = {(int)rect.origin.x, (int)rect.origin.y, (int)(rect.origin.x + rect.size.width), (int)(rect.origin.y + rect.size.height)};
        double scaleFactorX = 1, scaleFactorY = 1;
        FCSize clientSize = m_host->getClientSize();
        if (m_native->allowScaleSize())
        {
            if (clientSize.cx > 0 && clientSize.cy > 0)
            {
                FCSize scaleSize = m_native->getScaleSize();
                scaleFactorX = (double)(clientSize.cx) / scaleSize.cx;
                scaleFactorY = (double)(clientSize.cy) / scaleSize.cy;
            }
        }
        FCRect newRect = {0};
        if(scaleFactorX > 0 && scaleFactorY > 0)
        {
            newRect.left = floor(pRect.left / scaleFactorX);
            newRect.top = floor(pRect.top / scaleFactorY);
            newRect.right = ceil(pRect.right / scaleFactorX);
            newRect.bottom = ceil(pRect.bottom / scaleFactorY);
        }
        m_host->onPaint(newRect);
    }
}

-(void)setScrollView:(UIScrollView*)scrollView
{
    m_scrollView = scrollView;
}

-(UIScrollView*)getScrollView
{
    return m_scrollView;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(m_editingTextBox)
    {
        if([textField superview])
        {
            string text = [[m_textBox text] UTF8String];
            String wText = FCTran::stringToString(text);
            m_editingTextBox->setText(wText);
            int textLength = (int)wText.length();
            if(textLength > 0)
            {
                m_editingTextBox->setSelectionStart(textLength + 1);
            }
            m_native->invalidate();
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideTextBox:m_editingTextBox];
    return YES;
}

- (void)changeTime:(UIDatePicker*)sender
{
    if(m_editingDateTimeButton)
    {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        if(FCTran::toLower(m_editingDateTimeButton->getDateMode()) == L"time")
        {
            [formater setDateFormat:@"HH:mm:ss"];
        }
        else
        {
            [formater setDateFormat:@"yyyy-MM-dd"];
        }
        NSString *dateStr = [formater stringFromDate:m_datePicker.picker.date];
        string text = [dateStr UTF8String];
        String wText = FCTran::stringToString(text);
        m_editingDateTimeButton->setText(wText);
        m_native->invalidate();
    }
}

- (void)picker:(UIDatePicker *)picker ValueChanged:(NSDate *)date{
    
    if(m_editingDateTimeButton)
    {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        if(FCTran::toLower(m_editingDateTimeButton->getDateMode()) == L"time")
        {
            [formater setDateFormat:@"HH:mm"];
        }
        else
        {
            [formater setDateFormat:@"yyyy-MM-dd"];
        }
        NSString *dateStr = [formater stringFromDate:date];
        string text = [dateStr UTF8String];
        String wText = FCTran::stringToString(text);
        m_editingDateTimeButton->setText(wText);
        m_native->invalidate();
    }
}

-(void)showDatePicker:(DateTimeButton*)dateTimeButton
{
    if(!m_datePicker)
    {
        m_datePicker = [[ SYDatePicker alloc] initWithFrame:CGRectMake(0, 300, self.frame.size.width, 200)];
        m_datePicker.delegate = self;
    }
    
    UIDatePickerMode mode = UIDatePickerModeDate;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"]];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    if(FCTran::toLower(dateTimeButton->getDateMode()) == L"time")
    {
        mode = UIDatePickerModeTime;
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else
    {
        mode = UIDatePickerModeDate;
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    String text = dateTimeButton->getText();
    if((int)text.length() > 0)
    {
        NSString *string = IOSHost::getNSString(text.c_str());
        NSDate *date = [dateFormatter dateFromString:string];
        m_datePicker.dates = date;
    }
    if(![m_textBox superview])
    {
        [m_datePicker showInView:self withFrame:CGRectMake(0, 300, self.frame.size.width, 200) andDatePickerMode:mode];
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    if(m_textBox){
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;   //height 就是键盘的高度
        int width = keyboardRect.size.width;     //width  键盘宽度
        if(m_textBox.frame.origin.y + m_textBox.frame.size.height >= self.frame.size.height - height){
            self.frame = CGRectMake(0, -height, self.frame.size.width, self.frame.size.height);
        }
    }
}
 
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
}

-(void)showTextBox:(FCTextBox*)textBox
{
    float scaleFactorX = 1, scaleFactorY = 1;
    if(m_native->allowScaleSize())
    {
        FCSize scaleSize = m_native->getScaleSize();
        FCSize size = m_host->getClientSize();
        if (size.cx > 0 & size.cy > 0)
        {
            scaleFactorX = (float)scaleSize.cx / (float)size.cx;
            scaleFactorY = (float)scaleSize.cy / (float)size.cy;
        }
    }
    m_host->setAllowPartialPaint(false);
    int subWidth = 0;
    ArrayList<FCView*> subControls = textBox->m_views;
    int subControlsSize = (int)subControls.size();
    for(int i = 0; i < subControlsSize; i++)
    {
        FCView *control = subControls.get(i);
        if(control->isVisible())
        {
            subWidth += control->getWidth();
        }
    }
    int clx = textBox->getNative()->clientX(textBox) + textBox->getPadding().left;
    FCSpin *spin = dynamic_cast<FCSpin*>(textBox);
    if(spin && spin->getDownButton()->isVisible())
    {
        clx += 36;
    }
    float x = (clx / scaleFactorX) + 1;
    int clientY = textBox->getNative()->clientY(textBox);
    float cx = ((textBox->getWidth() - subWidth - textBox->getPadding().right - 2) / scaleFactorX);
    if(textBox->getPadding().right > 0){
        cx = ((textBox->getWidth() - subWidth - textBox->getPadding().right) / scaleFactorX);
    }
    float y = (clientY / scaleFactorY) + 2;
    float cy = (textBox->getHeight() / scaleFactorY) - 4;
    CGRect rect  = CGRectMake(x , y , cx, cy);
    if(!m_textBox)
    {
        m_textBox = [[UITextField alloc] initWithFrame:rect];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(textValueChanged:) name:UITextFieldTextDidChangeNotification object:m_textBox];
        //m_textBox.clearButtonMode = UITextFieldViewModeWhileEditing;
        m_textBox.borderStyle = UITextBorderStyleNone;
        m_textBox.layer.masksToBounds = YES;
        m_textBox.layer.borderColor = [UIColor redColor].CGColor;
    }
    //UIButton *clearButton = [m_textBox valueForKey:@"_clearButton"];
    FCPaint *paint = m_native->getPaint();
    if(textBox->getBackColor() != FCColor_None){
        int a = 0, r = 0, g = 0, b = 0;
        Long backColor = paint->getPaintColor(textBox->getBackColor());
        FCColor::toRgba(m_native->getPaint(), backColor, &r, &g, &b, &a);
        m_textBox.backgroundColor = [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
    }else{
        m_textBox.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:41.0/255.0 alpha:1.0];
    }
    if(textBox->getTextColor() != FCColor_None){
        int a = 0, r = 0, g = 0, b = 0;
        Long textColor = paint->getPaintColor(textBox->getTextColor());
        FCColor::toRgba(m_native->getPaint(), textColor, &r, &g, &b, &a);
        m_textBox.textColor = [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a/255.0];
    }else{
        m_textBox.textColor = [UIColor whiteColor];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [self createCloseImage];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.layer.allowsEdgeAntialiasing = YES;
    m_textBox.rightView = imageView;
    m_textBox.rightViewMode = UITextFieldViewModeAlways;
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView)]];
    //[clearButton setImage:scaleImage forState:0];
    //[clearButton setImage:scaleImage forState:1];
    FCFont *font = textBox->getFont();
    float fontSize = (float) (font->m_fontSize / ((scaleFactorX + scaleFactorY) / 2));
    String fontFamily = font->m_fontFamily;
    if(fontFamily == L"Default"){
        fontFamily = MyColor::getSystemFont();
    }
    string fstr = FCTran::StringTostring(fontFamily);
    NSString *nsstr = [NSString stringWithUTF8String:fstr.c_str()];
    m_textBox.font = [UIFont fontWithName:nsstr size:fontSize];
    if(textBox->getPasswordChar() != L'\0')
    {
        m_textBox.secureTextEntry = YES;
    }
    else
    {
        m_textBox.secureTextEntry = NO;
    }
    NSString *text = IOSHost::getNSString(textBox->getText().c_str());
    FCSpin *spina = dynamic_cast<FCSpin*>(textBox);
    if(spina)
    {
        [m_textBox setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];

        double value = spina->getValue();
        if(value == 0.0)
        {
            text = @"";
        }
        else
        {
            String strDouble = FCTran::doubleToStr(value);
            text = [NSString stringWithUTF8String: FCTran::StringTostring(strDouble).c_str()];
        }
        m_textBox.keyboardType = UIKeyboardTypeDecimalPad;
        int a = 0, r = 0, g = 0, b = 0;
        //FCColor::toRgba(m_paint, FCCOLORS_FORECOLOR, &r, &g, &b, &a);
        spina->setTextColor(FCColor::rgba(0, r, g, b));
    }
    else
    {
        m_textBox.keyboardType = UIKeyboardTypeDefault;
        if(textBox->getName() == L"withdrawnum" || textBox->getName() == L"txtValidateCode")
        {
            m_textBox.keyboardType = UIKeyboardTypeDecimalPad;
        }
    }
    String value;
    String type;
    textBox->getAttribute(L"keyboardtype", &value, &type);
    if(value == L"num")
    {
        m_textBox.keyboardType = UIKeyboardTypeDecimalPad;
    }
    m_textBox.delegate = self;
    m_textBox.text = text;
    if(m_scrollView)
    {
        if(!spina)
        {
            m_scrollView.contentOffset = CGPointMake(0, rect.origin.y - 360);
        }
    }
    if(![m_textBox superview])
    {
        [self addSubview:m_textBox];
    }
    [m_textBox becomeFirstResponder];
}

- (UIImage *)createCloseImage
{
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, rect);
    UIColor *uiColor = [UIColor colorWithRed:255 / 255.0 green:80 / 255.0 blue:80 / 255.0 alpha:255/255.0];
    [uiColor set];
    CGContextFillPath(context);
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, rect.origin.x + 6, rect.origin.y + 6);
    CGContextAddLineToPoint(context, rect.size.width - 6, rect.size.height - 6);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, rect.origin.x + 6, rect.size.height - 6);
    CGContextAddLineToPoint(context, rect.size.width - 6, rect.origin.y + 6);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //m_textBox.layer.borderWidth = 0.5;
    //m_textBox.layer.borderColor = [UIColor grayColor].CGColor;
    return YES;
}

- (void)textValueChanged:(NSNotification *)notice
{
    if(m_editingTextBox)
    {
        NSString *text = ((UITextField*)notice.object).text;
        String wText = FCTran::stringToString([text UTF8String]);
        m_editingTextBox->setText(wText);
    }
}

-(void)hideDatePicker:(DateTimeButton*)dateTimeButton
{
    if(m_datePicker)
    {
        if([m_datePicker superview])
        {
            if(dateTimeButton)
            {
                NSDateFormatter *formater = [[NSDateFormatter alloc] init];
                if(FCTran::toLower(m_editingDateTimeButton->getDateMode()) == L"time")
                {
                    [formater setDateFormat:@"HH:mm"];
                }
                else
                {
                    [formater setDateFormat:@"yyyy-MM-dd"];
                }
                NSString *dateStr = [formater stringFromDate:m_datePicker.picker.date];
                string text = [dateStr UTF8String];
                String wText = FCTran::stringToString(text);
                dateTimeButton->setText(wText);
                m_editingDateTimeButton = 0;
            }
            [m_datePicker removeFromSuperview];
            m_native->invalidate();
        }
    }
}

-(void)hideTextBox:(FCTextBox*)textBox
{
    m_host->setAllowPartialPaint(true);
    if(m_textBox)
    {
        if([m_textBox superview])
        {
            if(textBox)
            {
                //textBox->show();
                textBox->setFocused(false);
                string text = [[m_textBox text] UTF8String];
                String wText = FCTran::stringToString(text);
                FCSpin *spin = dynamic_cast<FCSpin*>(textBox);
                if(spin)
                {
                    String szValue = FCTran::getValueByDigit(FCTran::strToDouble(wText.c_str()), spin->getDigit());
                    wText = szValue;
                }
                textBox->setText(wText);
                int textLength = (int)textBox->getText().length();
                if(textLength > 0)
                {
                    m_editingTextBox->setSelectionStart(textLength + 1);
                    m_editingTextBox->setSelectionLength(0);
                }
                m_editingTextBox = 0;
            }
            [m_textBox removeFromSuperview];
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            m_textBox = nil;
            m_native->invalidate();
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_native)
    {
        m_oldFocusedControl = m_native->getFocusedView();
        NSArray *touchArray = [event.allTouches allObjects];
        UITouch *touch = [touchArray objectAtIndex:0];
        m_host->setTouchPoint(IOSHost::getPoint([touch locationInView:self]));
        FCTouchInfo touchInfo;
        m_host->getTouches(touchArray, &touchInfo);
        m_native->onTouchBegin(touchInfo);
        //vector<CTouch> ctouches;
        //m_host->GetTouches(touchArray, &ctouches);
        
        //m_native->OnTouchBegin(&ctouches);
        FCView *newFocusedControl = m_native->getFocusedView();
        if(newFocusedControl)
        {
            bool scrollEnabled = true;
            if(newFocusedControl->allowDrag())
            {
                scrollEnabled = false;
            }
            else
            {
                FCChart *chart = dynamic_cast<FCChart*>(newFocusedControl);
                bool parentIsChart = false;
                if(!chart && newFocusedControl->getParent())
                {
                    chart = dynamic_cast<FCChart*>(newFocusedControl->getParent());
                    parentIsChart = true;
                }
                if(chart)
                {
                    if(parentIsChart)
                    {
                        scrollEnabled = false;
                    }
                    else
                    {
                        if(chart->isOperating() || chart->isShowCrossLine())
                        {
                            scrollEnabled = false;
                        }
                    }
                }
                FCView *previewsControl = m_host->findPreviewsControl(newFocusedControl);
                if(!previewsControl)
                {
                    previewsControl = newFocusedControl;
                }
                FCDiv *div = dynamic_cast<FCDiv*>(previewsControl);
                if(div && div->allowDragScroll())
                {
                    if((div->getVScrollBar() && div->getVScrollBar()->isVisible())
                       || (div->getHScrollBar() && div->getHScrollBar()->isVisible()))
                    {
                        scrollEnabled = false;
                    }
                }
                
            }
            if(m_allowScroll && scrollEnabled)
            {
                m_scrollView.scrollEnabled = YES;
            }
            else
            {
                m_scrollView.scrollEnabled = NO;
            }
        }
        if(touchArray.count == 1)
        {
            //FCPoint mp = m_native->GetMousePoint();
            FCTextBox *oldTextBox = 0;
            DateTimeButton *oldDateTimeButton = 0;
            if(newFocusedControl && m_oldFocusedControl)
            {
                oldTextBox = dynamic_cast<FCTextBox*>(m_oldFocusedControl);
                oldDateTimeButton = dynamic_cast<DateTimeButton*>(m_oldFocusedControl);
            }
            bool showTextBox = false;
            bool showDatePicker = false;
            if(newFocusedControl)
            {
                if(m_editingTextBox)
                {
                    bool canHide = true;
                   if(canHide){
                       [self hideTextBox:m_editingTextBox];
                   }else {
                       showTextBox = true;
                   }
                }
                if(m_editingDateTimeButton)
                {
                    [self hideDatePicker:m_editingDateTimeButton];
                }
                FCTextBox *textBox = dynamic_cast<FCTextBox*>(newFocusedControl);
                if(textBox && textBox->isEnabled() && !textBox->isReadOnly())
                {
                    m_editingTextBox = textBox;
                    //m_editingTextBox->SetFocused(false);
                    [self showTextBox:m_editingTextBox];
                    showTextBox = true;
                }
                DateTimeButton *dateTimeButton = dynamic_cast<DateTimeButton*>(newFocusedControl);
                if(dateTimeButton && dateTimeButton->isEnabled())
                {
                    m_editingDateTimeButton = dateTimeButton;
                    dateTimeButton->setFocused(false);
                    [self showDatePicker:m_editingDateTimeButton];
                    showDatePicker = true;
                }
            }
            if(!showTextBox)
            {
                [self hideTextBox:oldTextBox];
            }
            if(!showDatePicker)
            {
                [self hideDatePicker:oldDateTimeButton];
            }
        }
        m_native->invalidate();
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_allowScroll)
    {
        m_scrollView.scrollEnabled = YES;
    }
    NSArray *touchArray = [event.allTouches allObjects];
    UITouch *touch = [touchArray objectAtIndex:0];
    m_host->setTouchPoint(IOSHost::getPoint([touch locationInView:self]));
    FCView *mouseDownControl = m_native->m_touchDownView;
    if(mouseDownControl)
    {
        FCTouchInfo touchInfo;
        m_host->getTouches(touchArray, &touchInfo);
        mouseDownControl->onTouchLeave(touchInfo);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_allowScroll)
    {
        m_scrollView.scrollEnabled = YES;
    }
    NSArray *touchArray = [event.allTouches allObjects];
    UITouch *touch = [touchArray objectAtIndex:0];
    m_host->setTouchPoint(IOSHost::getPoint([touch locationInView:self]));
    FCTouchInfo touchInfo;
    m_host->getTouches(touchArray, &touchInfo);
    if(m_native){
        m_native->onTouchEnd(touchInfo);
    }
    //vector<CTouch> ctouches;
    //m_host->GetTouches(touchArray, &ctouches);
    //m_native->OnTouchEnd(&ctouches);
    //ctouches.clear();
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *touchArray = [event.allTouches allObjects];
    UITouch *touch = [touchArray objectAtIndex:0];
    m_host->setTouchPoint(IOSHost::getPoint([touch locationInView:self]));
    FCView *newFocusedControl = m_native->getFocusedView();
    if(newFocusedControl)
    {
        bool scrollEnabled = true;
        if(newFocusedControl->allowDrag())
        {
            scrollEnabled = false;
        }
        else
        {
            FCChart *chart = dynamic_cast<FCChart*>(newFocusedControl);
            bool parentIsChart = false;
            if(!chart && newFocusedControl->getParent())
            {
                chart = dynamic_cast<FCChart*>(newFocusedControl->getParent());
                parentIsChart = true;
            }
            if(chart)
            {
                if(parentIsChart)
                {
                    scrollEnabled = false;
                }
                else
                {
                    if(chart->isOperating() || chart->isShowCrossLine())
                    {
                        scrollEnabled = false;
                    }
                }
            }
            FCView *previewsControl = m_host->findPreviewsControl(newFocusedControl);
            if(!previewsControl)
            {
                previewsControl = newFocusedControl;
            }
            FCDiv *div = dynamic_cast<FCDiv*>(previewsControl);
            if(div && div->allowDragScroll())
            {
                if((div->getVScrollBar() && div->getVScrollBar()->isVisible())
                   || (div->getHScrollBar() && div->getHScrollBar()->isVisible()))
                {
                    scrollEnabled = false;
                }
            }
            
        }
        if(m_allowScroll && scrollEnabled)
        {
            m_scrollView.scrollEnabled = YES;
        }
        else
        {
            m_scrollView.scrollEnabled = NO;
        }
    }
    FCTouchInfo touchInfo;
    m_host->getTouches(touchArray, &touchInfo);
    m_native->onTouchMove(touchInfo);
    //vector<CTouch> ctouches;
    //m_host->GetTouches(touchArray, &ctouches);
    //m_native->OnTouchMove(&ctouches);
    //ctouches.clear();
}

-(UIViewController*)getViewController{
    return m_viewController;
}

-(void)setViewController:(UIViewController*)viewController{
    m_viewController = viewController;
}

- (BOOL)canBecomeFirstResponder
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if ([window isKeyWindow] == NO){
        [window becomeKeyWindow];
        [window makeKeyAndVisible];
    }
   return YES;
}

@end

