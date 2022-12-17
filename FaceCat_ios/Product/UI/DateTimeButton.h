/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#ifndef DATETIMEBUTTON_h
#define DATETIMEBUTTON_h
#pragma once
#include "stdafx.h"
#include "FCDraw.h"

class DateTimeButton : public FCButton{
private:
    String m_dateMode;
public:
    DateTimeButton();
    virtual ~DateTimeButton();
    String getDateMode();
    void setDateMode(const String& dateMode);
public:
    virtual void getAttribute(const String& name, String *value, String *type);
    virtual ArrayList<String> getAttributeNames();
    virtual void onPaintBackground(FCPaint *paint, const FCRect& clipRect);
    virtual void setAttribute(const String& name, const String& value);
};

#endif
