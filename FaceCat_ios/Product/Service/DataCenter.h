/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#ifndef __DATACENTERCT_H__
#define __DATACENTERCT_H__
#pragma once
#include "stdafx.h"

/*
 * 程序入口
 */
class DataCenter{
public:
    /*
     * 构造函数
     */
    DataCenter();
    /*
     * 析构函数
     */
    virtual ~DataCenter();
    /*
     * 获取启动路径
     */
    static std::string getAppPath();
    /*
     * 获取用户数据路径
     */
    static std::string getUserPath();
    /*
     * 获取GUID
     */
    static std::string getGuid();
public:
    /*
     * 启动服务
     */
    static void startService();
};
#endif
