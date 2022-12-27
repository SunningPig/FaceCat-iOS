/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#include "stdafx.h"
#include "ArrowButtonM.h"

ArrowButtonM::ArrowButtonM(){
    m_arrowType = 0;
    setBorderColor(FCColor_None);
}

ArrowButtonM::~ArrowButtonM(){
}

int ArrowButtonM::getArrowType(){
    return m_arrowType;
}

void ArrowButtonM::setArrowType(int arrowType){
    m_arrowType = arrowType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void ArrowButtonM::onPaintBackground(FCPaint *paint, const FCRect& clipRect){
    String text = getText();
    int width = getWidth(), height = getHeight();
    int mw = width / 2, mh = height / 2 + 2;
    FCRect drawRect ={0, 0, width, height};
    if (m_arrowType > 0){
        FCPoint points[3] = {0};
        int ts = min(mw, mh) / 2 + 2;
        switch (m_arrowType){
            //向左
            case 1:
                points[0] = {mw - ts, mh};
                points[1] = {mw + ts, mh - ts};
                points[2] = {mw + ts, mh + ts};
                break;
            //向右
            case 2:
                points[0] = {mw + ts, mh};
                points[1] = {mw - ts, mh - ts};
                points[2] = {mw - ts, mh + ts};
                break;
            //向上
            case 3:
                points[0] = {mw, mh - ts};
                points[1] = {mw - ts, mh + ts};
                points[2] = {mw + ts, mh + ts};
                break;
            //向下
            case 4:
                points[0] = {mw, mh + ts - 3};
                points[1] = {mw - ts + 3, mh - ts + 3};
                points[2] = {mw + ts - 3, mh - ts  + 3};
                break;
        }
        paint->fillPolygon(FCColor::rgba(54, 138, 212, 255), points, 3);
    }
}
