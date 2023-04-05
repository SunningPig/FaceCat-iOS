

#ifndef RadioButtonM_h
#define RadioButtonM_h
#pragma once
#include "stdafx.h"

/*
 * 单选按钮
 */
class RadioButtonM : public FCRadioButton
{
private:
    /*
     * 图片
     */
    String m_image;
public:
    /*
     * 构造函数
     */
    RadioButtonM();
    /*
     * 析构函数
     */
    virtual ~RadioButtonM();
    /*
     * 获取图片
     */
    String getImage();
    /*
     * 设置图片
     */
    void setImage(const String& image);
public:
    /*
     * 绘制复选按钮
     */
     virtual void onPaintCheckButton(FCPaint *paint, const FCRect& clipRect);
    /*
     * 重绘前景
     */
     virtual void onPaintForeground(FCPaint *paint, const FCRect& clipRect);
public:
    /*
     * 获取属性
     */
    virtual void getAttribute(const String& name, String *value, String *type);
    /*
     * 获取所有属性
     */
    virtual ArrayList<String> getAttributeNames();
    /*
     * 设置属性
     */
    virtual void setAttribute(const String& name, const String& value);
};

#endif
