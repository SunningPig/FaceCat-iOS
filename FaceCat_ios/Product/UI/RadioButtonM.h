

#ifndef RadioButtonM_h
#define RadioButtonM_h
#pragma once
#include "stdafx.h"

class RadioButtonM : public FCRadioButton
{
private:
    String m_image;
public:
    RadioButtonM();
    virtual ~RadioButtonM();
    String getImage();
    void setImage(const String& image);
public:
     virtual void onPaintCheckButton(FCPaint *paint, const FCRect& clipRect);
     virtual void onPaintForeground(FCPaint *paint, const FCRect& clipRect);
public:
    virtual void getAttribute(const String& name, String *value, String *type);
    virtual ArrayList<String> getAttributeNames();
    virtual void setAttribute(const String& name, const String& value);
};

#endif
