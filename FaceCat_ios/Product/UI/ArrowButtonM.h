/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#ifndef ARROWBUTTONM_h
#define ARROWBUTTONM_h
#pragma once
#include "stdafx.h"
#include "FCDraw.h"

class ArrowButtonM : public FCButton{
private:
    int m_arrowType;
public:
    ArrowButtonM();
    virtual ~ArrowButtonM();
public:
    int getArrowType();
    void setArrowType(int value);
public:
    virtual void onPaintBackground(FCPaint *paint, const FCRect& clipRect);
};
#endif
