/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#include "stdafx.h"
#include "IOSHost.h"
#include "RibbonButton.h"
#include "ArrowButtonM.h"
#include "ScrollButtonM.h"
#include "DataCenter.h"

IOSTimer::IOSTimer(){
    m_interval = 1000;
    m_tick = 0;
    m_timerID = 0;
}

IOSTimer::~IOSTimer(){
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FCSize IOSHost::getClientSize(){
    FCSize size ={0};
    if(m_view){
        size = getSize(m_view.frame.size);
    }
    return size;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

IOSHost::IOSHost(){
    m_allowOperate = true;
    m_allowPartialPaint = true;
    m_allowZoom = true;
    m_isViewAppear = true;
    m_touchPoint.x = 0;
    m_touchPoint.y = 0;
    m_native = 0;
    m_view = 0;
}

IOSHost::~IOSHost(){
    m_native = 0;
    map<int, IOSTimer*>::iterator sIter = m_timers.begin();
    for(; sIter != m_timers.end(); ++sIter){
        delete sIter->second;
    }
    m_timers.clear();
    m_view = 0;
}

bool IOSHost::isViewAppear(){
    return m_isViewAppear;
}

void IOSHost::setViewAppear(bool isViewAppear){
    m_isViewAppear = isViewAppear;
}

FCNative* IOSHost::getNative(){
    return m_native;
}

void IOSHost::setNative(FCNative *native){
    m_native = native;
}

UIView* IOSHost::getView(){
    return m_view;
}

void IOSHost::setView(UIView *view){
    m_view = view;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CGPoint IOSHost::getCGPoint(const FCPoint& point){
    return CGPointMake(point.x, point.y);
}

CGRect IOSHost::getCGRect(const FCRect& rect){
    int rw = rect.right - rect.left;
    int rh = rect.bottom - rect.top;
    if(rw < 0){
        rw = 0;
    }
    if(rh < 0){
        rh = 0;
    }
    return CGRectMake(rect.left, rect.top, rw, rh);
}

CGSize IOSHost::getCGSize(const FCSize& size){
    return CGSizeMake(size.cx, size.cy);
}

NSString* IOSHost::getNSString(const wchar_t *str){
    string fstr = FCTran::StringTostring(str);
    return [NSString stringWithUTF8String:fstr.c_str()];
}

FCPoint IOSHost::getPoint(CGPoint cgPoint){
    FCPoint point ={(int)cgPoint.x, (int)cgPoint.y};
    return point;
}

FCRect IOSHost::getRect(CGRect cgRect){
    FCRect rect ={(int)cgRect.origin.x, (int)cgRect.origin.y, (int)(cgRect.origin.x + cgRect.size.width),
        (int)(cgRect.origin.x + cgRect.size.height)};
    return rect;
}

FCSize IOSHost::getSize(CGSize cgSize){
    FCSize size ={(int)cgSize.width, (int)cgSize.height};
    return size;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool IOSHost::allowOperate(){
    return m_allowOperate;
}

bool IOSHost::allowPartialPaint(){
    return m_allowPartialPaint;
}

bool IOSHost::getAllowZoom(){
    return m_allowZoom;
}

void IOSHost::setAllowZoom(bool allowZoom){
    m_allowZoom = allowZoom;
}

void IOSHost::beginInvoke(FCView *control, void *args){
    if([NSThread isMainThread] == YES){
        control->onInvoke(args);
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            control->onInvoke(args);
        });
    }
}

void IOSHost::copy(string text){
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    if(paste){
        NSString *nsStr = [NSString stringWithUTF8String:text.c_str()];
        [paste setString:nsStr];
    }
}

FCView* IOSHost::createInternalView(FCView *parent, const String& clsid){
    FCCalendar *calendar = dynamic_cast<FCCalendar*>(parent);
    if (calendar){
        if (clsid == L"datetitle"){
            return new DateTitle(calendar);
        }
        else if (clsid == L"headdiv"){
            HeadDiv *headDiv = new HeadDiv(calendar);
            headDiv->setWidth(parent->getWidth());
            headDiv->setDock(FCDockStyle_Top);
            return headDiv;
        }
        else if (clsid == L"lastbutton"){
            return new ArrowButton(calendar);
        }
        else if (clsid == L"nextbutton"){
            ArrowButton *nextBtn = new ArrowButton(calendar);
            nextBtn->setToLast(false);
            return nextBtn;
        }
    }
    FCSplitLayoutDiv *splitLayoutDiv = dynamic_cast<FCSplitLayoutDiv*>(parent);
    if (splitLayoutDiv){
        if (clsid == L"splitter"){
            FCButton *splitter = new FCButton();
            splitter->setBackColor(USERCOLOR6);
            splitter->setBorderColor(USERCOLOR14);
            splitter->setSize({5, 5});
            return splitter;
        }
    }
    FCScrollBar *scrollBar = dynamic_cast<FCScrollBar*>(parent);
    if (scrollBar){
        scrollBar->setBackColor(FCColor_None);
        scrollBar->setBorderColor(FCColor_None);
        scrollBar->setSize({8, 8});
        if (clsid == L"addbutton"){
            RibbonButton *addButton = new RibbonButton;
            addButton->setSize({8, 8});
            if (dynamic_cast<FCHScrollBar*>(scrollBar)){
                addButton->setWidth(0);
                addButton->setArrowType(2);
            }
            else{
                addButton->setHeight(0);
                addButton->setArrowType(4);
            }
            return addButton;
        }
        else if (clsid == L"backbutton"){
            FCButton *backButton = new FCButton;
            backButton->setBackColor(FCColor_None);
            backButton->setBorderColor(FCColor_None);
            return backButton;
        }
        else if (clsid == L"scrollbutton"){
            ScrollButtonM *scrollButton = new ScrollButtonM();
            scrollButton->setAllowDrag(true);
            scrollButton->setBackColor(USERCOLOR74);
            scrollButton->setBorderColor(FCColor_None);
            scrollButton->setCornerRadius(0);
            return scrollButton;
        }
        else if (clsid == L"reducebutton"){
            RibbonButton *reduceButton = new RibbonButton;
            reduceButton->setSize({8, 8});
            if (dynamic_cast<FCHScrollBar*>(scrollBar)){
                reduceButton->setWidth(0);
                reduceButton->setArrowType(1);
            }
            else{
                reduceButton->setHeight(0);
                reduceButton->setArrowType(3);
            }
            return reduceButton;
        }
    }
    FCTabPage *tabPage = dynamic_cast<FCTabPage*>(parent);
    if (tabPage){
        if (clsid == L"headerbutton"){
            RibbonButton *button = new RibbonButton;
            button->setAllowDrag(true);
            FCSize size = {100, 30};
            button->setSize(size);
            return button;
        }
    }
    FCComboBox *comboBox = dynamic_cast<FCComboBox*>(parent);
    if (comboBox){
        if (clsid == L"dropdownbutton"){
            ArrowButtonM *dropDownButton = new ArrowButtonM;
            dropDownButton->setArrowType(4);
            dropDownButton->setDisplayOffset(false);
            int width = comboBox->getWidth();
            int height = comboBox->getHeight();
            FCPoint location ={width - 25, 0};
            dropDownButton->setLocation(location);
            FCSize size ={25, height};
            dropDownButton->setSize(size);
            return dropDownButton;
        }
        else if (clsid == L"dropdownmenu"){
            FCComboBoxMenu *comboBoxMenu = new FCComboBoxMenu;
            comboBoxMenu->setComboBox(comboBox);
            comboBoxMenu->setPopup(true);
            FCSize size ={100, 200};
            comboBoxMenu->setSize(size);
            return comboBoxMenu;
        }
    }
    FCDateTimePicker *datePicker = dynamic_cast<FCDateTimePicker*>(parent);
    if (datePicker){
        if (clsid == L"dropdownbutton"){
            RibbonButton *dropDownButton = new RibbonButton;
            dropDownButton->setArrowType(4);
            dropDownButton->setDisplayOffset(false);
            int width = datePicker->getWidth();
            int height = datePicker->getHeight();
            FCPoint location ={width - 16, 0};
            dropDownButton->setLocation(location);
            FCSize size ={16, height};
            dropDownButton->setSize(size);
            return dropDownButton;
        }
        else if (clsid == L"dropdownmenu"){
            FCMenu *dropDownMenu = new FCMenu();
            FCPadding padding(1);
            dropDownMenu->setPadding(padding);
            dropDownMenu->setPopup(true);
            FCSize size ={200, 200};
            dropDownMenu->setSize(size);
            return dropDownMenu;
        }
    }
    FCSpin *spin = dynamic_cast<FCSpin*>(parent);
    if (spin){
        if (clsid == L"downbutton"){
            return new FCButton;
        }
        else if (clsid == L"upbutton"){
            return new FCButton;
        }
    }
    FCDiv *div = dynamic_cast<FCDiv*>(parent);
    if (div){
        if (clsid == L"hscrollbar"){
            FCHScrollBar *hScrollBar = new FCHScrollBar;
            hScrollBar->setVisible(false);
            FCSize size ={4, 4};
            hScrollBar->setSize(size);
            return hScrollBar;
        }
        else if (clsid == L"vscrollbar"){
            FCVScrollBar *vScrollBar = new FCVScrollBar;
            vScrollBar->setVisible(false);
            FCSize size ={4, 4};
            vScrollBar->setSize(size);
            return vScrollBar;
        }
    }
    FCGrid *grid = dynamic_cast<FCGrid*>(parent);
    if(grid){
        if(clsid == L"edittextbox"){
            FCTextBox *editTextBox = new FCTextBox;
            return editTextBox;
        }
    }
    return 0;
}

FCView* IOSHost::findPreviewsControl(FCView *control){
    if(control->allowPreviewsEvent()){
        return control;
    }
    else{
        FCView *parent = control->getParent();
        if(parent){
            return findPreviewsControl(parent);
        }
        else{
            return 0;
        }
    }
}

FCCursors IOSHost::getCursor(){
    return FCCursors_Arrow;
}

int IOSHost::getIntersectRect(FCRect *lpDestRect, const FCRect *lpSrc1Rect, const FCRect *lpSrc2Rect){
    lpDestRect->left = max(lpSrc1Rect->left, lpSrc2Rect->left);
    lpDestRect->right = min(lpSrc1Rect->right, lpSrc2Rect->right);
    lpDestRect->top = max(lpSrc1Rect->top, lpSrc2Rect->top);
    lpDestRect->bottom = min(lpSrc1Rect->bottom, lpSrc2Rect->bottom);
    if(lpDestRect->right >= lpDestRect->left && lpDestRect->bottom >= lpDestRect->top){
        return 1;
    }
    else{
        lpDestRect->left = 0;
        lpDestRect->right = 0;
        lpDestRect->top = 0;
        lpDestRect->bottom = 0;
        return 0;
    }
}

FCPoint IOSHost::getTouchPoint(){
    FCPoint mp = m_touchPoint;
    if (m_native->allowScaleSize()){
        FCSize clientSize = getClientSize();
        if (clientSize.cx > 0 && clientSize.cy > 0){
            FCSize scaleSize = m_native->getScaleSize();
            mp.x = mp.x * scaleSize.cx / clientSize.cx;
            mp.y = mp.y * scaleSize.cy / clientSize.cy;
        }
    }
    return mp;
}

double IOSHost::getScaleRate(){
    UIView *view = getView();
    CGRect frame = view.frame;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    int minSize = width < height ? width : height;
    if(!isPad && width > 400){
        return 1;
    }
    if(isPad){
        double rate = (double)minSize / 500;
        return rate;
    }
    else{
        double rate = (double)minSize / 400;
        return rate;
    }
}

FCSize IOSHost::getSize(){
    if (m_native->allowScaleSize()){
        return m_native->getScaleSize();
    }
    else{
        return getClientSize();
    }
}

int IOSHost::getTouches(NSArray *touchArray, FCTouchInfo *touchInfo){
    int touchesSize = (int)touchArray.count;
     for(int i = 0; i < touchesSize; i++){
         UITouch *touch = [touchArray objectAtIndex:i];
         FCPoint mp = getPoint([touch locationInView:m_view]);
         if (m_native->allowScaleSize()){
             FCSize clientSize = getClientSize();
             if (clientSize.cx > 0 && clientSize.cy > 0){
                 FCSize scaleSize = m_native->getScaleSize();
                 mp.x = mp.x * scaleSize.cx / clientSize.cx;
                 mp.y = mp.y * scaleSize.cy / clientSize.cy;
             }
         }
         touchInfo->m_clicks = (int)touch.tapCount;
     //ctouch.m_timestamp = touch.timestamp;
        if(i == 0)
        {
            touchInfo->m_firstPoint = mp;
            touchInfo->m_firstTouch = true;
        }else if(i == 1){
            touchInfo->m_secondPoint = mp;
            touchInfo->m_secondTouch = true;
        }
     }
     return 1;
 }

int IOSHost::getUnionRect(FCRect *lpDestRect, const FCRect *lpSrc1Rect, const FCRect *lpSrc2Rect){
    return 0;
}

void IOSHost::invalidate(){
    if(m_isViewAppear){
        m_clipBounds.clear();
        m_clipBounds.add({0, 0, m_native->getSize().cx, m_native->getSize().cy});
        [m_view setNeedsDisplay];
    }
}

void IOSHost::invalidate(const FCRect& rect){
    if(m_isViewAppear){
        if(m_allowPartialPaint){
            FCSize displaySize = m_native->getSize();
            double scaleFactorX = 1, scaleFactorY = 1;
            FCSize clientSize = getClientSize();
            if (m_native->allowScaleSize()){
                if (clientSize.cx > 0 && clientSize.cy > 0){
                    FCSize scaleSize = m_native->getScaleSize();
                    scaleFactorX = (double)(clientSize.cx) / scaleSize.cx;
                    scaleFactorY = (double)(clientSize.cy) / scaleSize.cy;
                }
            }
            FCRect newRect = rect;
            if(scaleFactorX > 0 && scaleFactorY > 0){
                newRect.left = floor(newRect.left * scaleFactorX);
                newRect.top = floor(newRect.top * scaleFactorY);
                newRect.right = ceil(newRect.right * scaleFactorX);
                newRect.bottom = ceil(newRect.bottom * scaleFactorY);
            }
            m_clipBounds.add({rect.left >= 0 ? rect.left : 0, rect.top >= 0 ? rect.top : 0, rect.right <= displaySize.cx ? rect
                .right : displaySize.cx, rect.bottom <= displaySize.cy ? rect.bottom : displaySize.cy});
            [m_view setNeedsDisplayInRect:getCGRect(newRect)];
        }
        else{
            invalidate();
        }
    }
}

void IOSHost::invoke(FCView *control, void *args){
    if([NSThread isMainThread] == YES){
        control->onInvoke(args);
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            control->onInvoke(args);
        });
    }
}


void IOSHost::onPaint(const FCRect& rect){
    FCSize displaySize = m_native->getSize();
    double scaleFactorX = 1, scaleFactorY = 1;
    FCSize clientSize = getClientSize();
    if (m_native->allowScaleSize()){
        if (clientSize.cx > 0 && clientSize.cy > 0){
            FCSize scaleSize = m_native->getScaleSize();
            scaleFactorX = (double)(clientSize.cx) / scaleSize.cx;
            scaleFactorY = (double)(clientSize.cy) / scaleSize.cy;
        }
    }
    FCPaint *paint = m_native->getPaint();
    FCRect wRect = {0, 0, clientSize.cx, clientSize.cy};
    paint->setScaleFactor(scaleFactorX, scaleFactorY);
    /*FCRect clipRect = rect;
    if (clipRect.left < 0)
    {
        clipRect.left = 0;
    }
    if (clipRect.top < 0)
    {
        clipRect.top = 0;
    }
    if (clipRect.right * scaleFactorX > clientSize.cx)
    {
        clipRect.right = (int)(clientSize.cx / scaleFactorX);
    }
    if (clipRect.bottom * scaleFactorY > clientSize.cy)
    {
        clipRect.bottom = (int)(clientSize.cy / scaleFactorY);
    }*/
    int clipBoundsSize = m_clipBounds.size();
    FCRect clipRect = {0};
    if (clipBoundsSize > 0) {
        for (int i = 0; i < clipBoundsSize; i++) {
            FCRect clipBounds = m_clipBounds.get(i);
            if (i == 0) {
                clipRect = {clipBounds.left, clipBounds.top, clipBounds.right, clipBounds.bottom};
            } else {
                if (clipRect.left > clipBounds.left) {
                    clipRect.left = clipBounds.left;
                }
                if (clipRect.right < clipBounds.right) {
                    clipRect.right = clipBounds.right;
                }
                if (clipRect.top > clipBounds.top) {
                    clipRect.top = clipBounds.top;
                }
                if (clipRect.bottom < clipBounds.bottom) {
                    clipRect.bottom = clipBounds.bottom;
                }
            }
        }
    } else {
        clipRect = {0, 0, displaySize.cx, displaySize.cy};
    }
    m_clipBounds.clear();
    paint->beginPaint(0, wRect, clipRect);
    m_native->onPaint(clipRect);
    paint->endPaint();
}

void IOSHost::onTimer(){
    if(m_native){
        if(m_isViewAppear){
            ArrayList<int> timerIDs;
            map<int, IOSTimer*>::iterator sIter = m_timers.begin();
            for(; sIter != m_timers.end(); ++sIter){
                IOSTimer *timer = sIter->second;
                if (timer->m_tick % timer->m_interval == 0){
                    timerIDs.add(timer->m_timerID);
                    
                }
                timer->m_tick++;
            }
            for(int i = 0; i < timerIDs.size(); i++){
                m_native->onTimer(timerIDs.get(i));
            }
            timerIDs.clear();
        }
    }
}

string IOSHost::paste(){
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if(pasteboard && pasteboard.string){
        return [pasteboard.string UTF8String];
    }else{
        return "";
    }
}

void IOSHost::setAllowOperate(bool allowOperate){
    m_allowOperate = allowOperate;
}

void IOSHost::setAllowPartialPaint(bool allowPartialPaint){
    m_allowPartialPaint = allowPartialPaint;
}

void IOSHost::setCursor(FCCursors cursor){
}

void IOSHost::setTouchPoint(const FCPoint& mp){
    m_touchPoint = mp;
}

void IOSHost::startTimer(int timerID, int interval){
    interval = interval / 10;
    if(interval < 1){
        interval = 1;
    }
    //m_lock.lock();
    map<int, IOSTimer*>::iterator sIter = m_timers.find(timerID);
    if(sIter != m_timers.end()){
        sIter->second->m_interval = interval;
        sIter->second->m_tick = 0;
    }
    else{
        IOSTimer *timer = new IOSTimer;
        timer->m_interval = interval;
        timer->m_timerID = timerID;
        m_timers[timerID] = timer;
    }
    //m_lock.unLock();
}

void IOSHost::stopTimer(int timerID){
    //m_lock.lock();
    map<int, IOSTimer*>::iterator sIter = m_timers.find(timerID);
    if(sIter != m_timers.end()){
        delete sIter->second;
        m_timers.erase(sIter);
    }
    //m_lock.unLock();
}
