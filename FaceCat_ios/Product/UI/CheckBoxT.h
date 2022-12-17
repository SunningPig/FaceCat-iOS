
#ifndef __CHECKBOXT__H__
#define __CHECKBOXT__H__
#pragma once
#include "stdafx.h"

class CheckBoxT : public FCCheckBox
{
private:
    int m_currentX;
    int m_timerID;
public:
    CheckBoxT();
    virtual ~CheckBoxT();
public:
    virtual void onClick(FCTouchInfo touchInfo);
    virtual void onPaintCheckButton(FCPaint *paint, const FCRect& clipRect);
    virtual void onRemove();
    virtual void onTimer(int timerID);
};

#endif
