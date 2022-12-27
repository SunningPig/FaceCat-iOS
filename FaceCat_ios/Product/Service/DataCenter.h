/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#ifndef __DATACENTERCT_H__
#define __DATACENTERCT_H__
#pragma once
#include "stdafx.h"


class DataCenter{
public:
    DataCenter();
    virtual ~DataCenter();
    static string getAppPath();
    static string getUserPath();
    static string getGuid();
public:
    static void startService();
};
#endif
