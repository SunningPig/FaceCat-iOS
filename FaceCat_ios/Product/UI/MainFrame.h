/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#ifndef MAINFRAME_H
#define MAINFRAME_H
#pragma once
#include "stdafx.h"
#include "FCDraw.h"
#include "UIXmlEx.h"

/*
 * 主视图
 */
class MainFrame : public UIXmlEx{
public:
    /*
     * 构造函数
     */
    MainFrame();
    /*
     * 析构函数
     */
    virtual ~MainFrame();
};
#endif
