#include "stdafx.h"
#include "RibbonButton2.h"

RibbonButton2::RibbonButton2(){
    setBorderColor(FCColor_None);
    setTextColor(USERCOLOR84);
    FCFont font(L"Default", 12, false, false, false);
    setFont(&font);
    setBackColor(USERCOLOR83);
    setCornerRadius(4);
}

RibbonButton2::~RibbonButton2(){
}

void RibbonButton2::onPaint(FCPaint *paint, const FCRect& clipRect){
    int width = getWidth(), height = getHeight();
    FCRect drawRect = {1, 1, width - 1, height - 1};
    FCFont *tFont = getFont();
    FCSize tSize = paint->textSize(getText(), tFont);
    FCRect tRect = {(width - tSize.cx) / 2, (height - tSize.cy) / 2, (width + tSize.cx) / 2, (height + tSize.cy) / 2};
    if (this == m_native->getPushedView())
    {
        paint->fillRoundRect(USERCOLOR82, drawRect, getCornerRadius());
    }
    else if (this == m_native->getHoveredView())
    {
        paint->fillRoundRect(USERCOLOR81, drawRect, getCornerRadius());
    }
    else
    {
        if(MyColor::getStyle() == 0 || MyColor::getStyle() == 1 || MyColor::getStyle() == 6){
            paint->fillRoundRect(getPaintingBackColor(), drawRect, getCornerRadius());
        }else{
            paint->fillRoundRect(USERCOLOR79, drawRect, getCornerRadius());
        }
    }
    paint->drawText(getText(), getPaintingTextColor(), tFont, tRect);
}

