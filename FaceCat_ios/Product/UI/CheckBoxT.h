
#ifndef __CHECKBOXT__H__
#define __CHECKBOXT__H__
#pragma once
#include "stdafx.h"

/*
 * 复选按钮
 */
class CheckBoxT : public FCCheckBox
{
private:
    /*
     * 当前横向偏移
     */
    int m_currentX;
    /*
     * 秒表ID
     */
    int m_timerID;
public:
    /*
     * 构造函数
     */
    CheckBoxT();
    /*
     * 析构函数
     */
    virtual ~CheckBoxT();
public:
    /*
     * 点击事件
     */
    virtual void onClick(FCTouchInfo touchInfo);
    /*
     * 重绘复选按钮
     */
    virtual void onPaintCheckButton(FCPaint *paint, const FCRect& clipRect);
    /*
     * 移除事件
     */
    virtual void onRemove();
    /*
     * 秒表事件
     */
    virtual void onTimer(int timerID);
};

#endif
