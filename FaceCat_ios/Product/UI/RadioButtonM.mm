
#include "stdafx.h"
#include "RadioButtonM.h"

RadioButtonM::RadioButtonM()
{
    FCSize cSize = {25, 25};
    setButtonSize(cSize);
}

RadioButtonM:: ~RadioButtonM()
{

}

String RadioButtonM::getImage()
{
   return m_image;
}

void RadioButtonM::setImage(const String& image)
{
    m_image = image;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void RadioButtonM::getAttribute(const String& name, String *value, String *type)
{
    if (name == L"image")
    {
        *type = L"string";
        *value = getImage();
    }
    else
    {
        FCView::getAttribute(name, value, type);
    }
}

ArrayList<String> RadioButtonM::getAttributeNames()
{
    ArrayList<String> propertyNames = FCView::getAttributeNames();
    propertyNames.add(L"Image");
    return propertyNames;
    
}

void RadioButtonM::setAttribute(const String& name, const String& value)
{
    if (name == L"image")
    {
        setImage(value);
    }
    else
    {
        FCView::setAttribute(name, value);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void RadioButtonM::onPaintForeground(FCPaint *paint, const FCRect& clipRect)
{
    bool ck = isChecked();
    String text = getText();
    FCFont *font = getFont();
    Long backColor = FCColor::rgb(204, 204, 204);
    int width = getWidth(), height = getHeight();
    FCRect buttonRect = {5, (height - m_buttonSize.cy) / 2, 5 + m_buttonSize.cx, (height + m_buttonSize.cy) / 2};
    if (m_buttonAlign == FCHorizontalAlign_Center)
    {
        buttonRect.left = (width - m_buttonSize.cx) / 2;
        buttonRect.right = (width + m_buttonSize.cx) / 2;
    }
    else if (m_buttonAlign == FCHorizontalAlign_Right)
    {
        buttonRect.left = width - m_buttonSize.cx - 5;
        buttonRect.right = width - 5;
    }
    paint->fillRoundRect(backColor, buttonRect, 5);
    if (ck)
    {
        Long checkedColor = FCColor::rgb(215, 85, 22);
        FCSize buttonSize = {16, 16};
        FCRect innerRect = {buttonRect.left + buttonSize.cx / 4, buttonRect.top + buttonSize.cy / 4,
            buttonRect.right - buttonSize.cx / 4, buttonRect.bottom - buttonSize.cy / 4};
        paint->fillRoundRect(checkedColor, innerRect, 4);
    }
    int startX = buttonRect.right + 2;
    int length = 30;
    if(m_image.size() > 0)
    {
        FCRect imageRect = {startX, 0, startX + length, height};
        paint->drawImage(m_image.c_str(), imageRect);
        startX = startX + length + 2;
    }
    FCSize size = paint->textSize(text.c_str(), font, -1);
    FCRect textRect = {startX, height / 2 - size.cy / 2, startX + size.cx, height / 2 + size.cy / 2};
    paint->drawText(text.c_str(), getTextColor(), font, textRect, -1);
}

void RadioButtonM::onPaintCheckButton(FCPaint *paint, const FCRect& clipRect)
{
}
