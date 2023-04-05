/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#ifndef ARROWBUTTONM_h
#define ARROWBUTTONM_h
#pragma once
#include "stdafx.h"
#include "FCDraw.h"

/*
 * 箭头按钮
 */
class ArrowButtonM : public FCButton{
private:
    /*
     * 箭头类型
     */
    int m_arrowType;
public:
    /*
     * 构造函数
     */
    ArrowButtonM();
    /*
     * 析构函数
     */
    virtual ~ArrowButtonM();
public:
    /*
     * 获取箭头类型
     */
    int getArrowType();
    /*
     * 设置箭头类型
     */
    void setArrowType(int value);
public:
    /*
     * 重绘背景色方法
     */
    virtual void onPaintBackground(FCPaint *paint, const FCRect& clipRect);
};
#endif
