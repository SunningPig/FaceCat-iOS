/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#include "stdafx.h"
#include "ScrollButtonM.h"
#include "FCDraw.h"

ScrollButtonM::ScrollButtonM(){
    setBorderColor(FCColor_None);
}

ScrollButtonM::~ScrollButtonM(){
}

void ScrollButtonM::onPaintBackground(FCPaint *paint, const FCRect& clipRect){
    FCView *parent = getParent();
    if(parent){
        FCScrollBar *scrollBar = dynamic_cast<FCScrollBar*>(parent->getParent());
        bool  show = false;
        if(scrollBar->getAddSpeed() != 0){
            show = true;
        }
        FCDiv *div = dynamic_cast<FCDiv*>(scrollBar->getParent());
        if(div->isDragScrolling()){
            show = true;
        }
        if(show){
            int width = getWidth(), height = getHeight();
            FCRect drawRect = {0, 0, width, height};
            int cornerRadis = 4;
            if (allowDrag() && this == m_native->getHoveredView())
            {
                paint->fillRoundRect(USERCOLOR5, drawRect, cornerRadis);
            }
            else
            {
                if (MyColor::getStyle() == 0 || MyColor::getStyle() == 1 || MyColor::getStyle() == 6)
                {
                    paint->fillRoundRect(FCColor_Border, drawRect, cornerRadis);
                }
                else
                {
                    paint->fillRoundRect(USERCOLOR74, drawRect, cornerRadis);
                }
            }
        }
    }
}
