/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#include "stdafx.h"
#include "DateTimeButton.h"

DateTimeButton::DateTimeButton(){
    m_dateMode = L"Date";
    setBorderColor(FCColor_None);
}

DateTimeButton::~DateTimeButton(){
}

String DateTimeButton::getDateMode(){
    return m_dateMode;
}

void DateTimeButton::setDateMode(const String& dateMode){
    m_dateMode = dateMode;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void DateTimeButton::getAttribute(const String& name, String *value, String *type){
    if (name == L"datemode"){
        *type = L"string";
        *value = getDateMode();
    }
    else{
        FCView::getAttribute(name, value, type);
    }
}

ArrayList<String> DateTimeButton::getAttributeNames(){
    ArrayList<String> propertyNames = FCView::getAttributeNames();
    propertyNames.add(L"DateMode");
    return propertyNames;
}

void DateTimeButton::onPaintBackground(FCPaint *paint, const FCRect& clipRect){
    String text = getText();
    int width = getWidth(), height = getHeight();
    FCRect drawRect ={0, 0, width, height};
    paint->fillRoundRect(getPaintingBackColor(), drawRect, 4);
    if (paint->supportTransparent()){
        FCNative *inative = getNative();
        if (this == inative->getPushedView()){
            //paint->fillRect(FCCOLORS_BACKCOLOR6, drawRect);
        }
        else if (this == inative->getHoveredView()){
            //paint->fillRect(FCCOLORS_BACKCOLOR5, drawRect);
        }
    }
}

void DateTimeButton::setAttribute(const String& name, const String& value){
    if (name == L"datemode"){
        setDateMode(value);
    }
    else{
        FCView::setAttribute(name, value);
    }
}
