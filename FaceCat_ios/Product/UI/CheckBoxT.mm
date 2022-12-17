
#include "stdafx.h"
#include "CheckBoxT.h"
#include "FCDraw.h"

CheckBoxT::CheckBoxT()
{
    m_currentX = -1;
    m_timerID = FCView::getNewTimerID();
    FCSize cSize = {40, 22};
    setButtonSize(cSize);
    setBorderColor(FCColor_None);
}

CheckBoxT:: ~CheckBoxT()
{
    
}

void CheckBoxT::onClick(FCTouchInfo touchInfo)
{
    bool oldChecked = isChecked();
    FCCheckBox::onClick(touchInfo);
    bool newChecked = isChecked();
    if(oldChecked != newChecked)
    {
        if(oldChecked)
        {
            m_currentX = getButtonSize().cx - 22;
            startTimer(m_timerID, 20);
        }
        else
        {
            m_currentX = -(getButtonSize().cx - 22);
            startTimer(m_timerID, 20);
        }
    }
}

void CheckBoxT::onPaintCheckButton(FCPaint *paint, const FCRect& clipRect)
{
    FCRect drawRect = clipRect;
    int width = getWidth(), height = getHeight();
    bool is = isChecked();
    int d = 22;
    int pHeight = 10;
    int round = 4;
    FCRect pRect = {1, height / 2 - pHeight / 2,  drawRect.right - 1, height / 2 + pHeight / 2};
    Long backColor = FCColor::rgb(106, 108, 118);

    if(is)
    {
        backColor = FCColor::rgb(20, 99, 177);
    }
    paint->fillRoundRect(backColor, pRect, round);
    FCRect ellipseRect = {1, (height - d) / 2, 1 + d, (height + d) / 2};
    Long backColor1 = FCColor::rgb(152, 152, 161);
    if(is)
    {
        backColor = FCColor::rgb(20, 99, 177);
        backColor1 = FCColor::rgb(20, 138, 253);
        ellipseRect.left = drawRect.right - 1 - d;
        ellipseRect.right = drawRect.right - 1;
    }
    if(m_currentX != -1)
    {
        ellipseRect.left += m_currentX;
        ellipseRect.right += m_currentX;
    }
    paint->fillEllipse(backColor1, ellipseRect);
}

void CheckBoxT::onRemove()
{
    FCCheckBox::onRemove();
    stopTimer(m_timerID);
}

void CheckBoxT::onTimer(int timerID)
{
    FCCheckBox::onTimer(timerID);
    if(m_timerID == timerID)
    {
        int aimLeft = 0;
        if(m_currentX != -1)
        {
            int xSub = aimLeft - m_currentX;
            if(xSub != 0)
            {
                if(xSub > 0)
                {
                    m_currentX += 2;
                }
                else if(xSub < 0)
                {
                    m_currentX -= 2;
                }
                if(abs(aimLeft - m_currentX) < 3)
                {
                    m_currentX = aimLeft;
                    stopTimer(m_timerID);
                }
                invalidate();
            }
        }
    }
}


