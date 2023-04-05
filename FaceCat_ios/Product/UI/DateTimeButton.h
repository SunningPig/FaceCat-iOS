/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#ifndef DATETIMEBUTTON_h
#define DATETIMEBUTTON_h
#pragma once
#include "stdafx.h"
#include "FCDraw.h"

/*
 * 日期按钮
 */
class DateTimeButton : public FCButton{
private:
    /*
     * 日期模式
     */
    String m_dateMode;
public:
    /*
     * 构造函数
     */
    DateTimeButton();
    /*
     * 析构函数
     */
    virtual ~DateTimeButton();
    /*
     * 获取日期模式
     */
    String getDateMode();
    /*
     * 设置日期模式
     */
    void setDateMode(const String& dateMode);
public:
    /*
     * 获取属性
     */
    virtual void getAttribute(const String& name, String *value, String *type);
    /*
     * 获取属性列表
     */
    virtual ArrayList<String> getAttributeNames();
    /*
     * 重绘背景
     */
    virtual void onPaintBackground(FCPaint *paint, const FCRect& clipRect);
    /*
     * 设置属性
     */
    virtual void setAttribute(const String& name, const String& value);
};

#endif
