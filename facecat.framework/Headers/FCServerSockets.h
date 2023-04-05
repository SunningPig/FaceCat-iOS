/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#ifndef __FCSERVERSOCKETS_H__
#define __FCSERVERSOCKETS_H__
#pragma once
#include "stdafx.h"
#include "FCClientSockets.h"

namespace FaceCat
{
    typedef void (*RecvMsg)(int socketID, int localSID, const char *str, int len);

    typedef void (*WriteServerLog)(int socketID, int localSID, int state, const char *str);

    /*
    * 服务端套接字连接管理
    */
    class FCServerSockets
    {
    public:
        /*
        * 消息回调
        */
        static void recvClientMsg(int socketID, int localSID, const char *str, int len);
        /*
        * 日志回调
        */
        static void writeLog(int socketID, int localSID, int state, const char *log);
    public:
        /*
        * 关闭服务
        */
        static int close(int socketID);
        /*
        * 关闭客户端
        */
        static int closeClient(int socketID, int clientSocketID);
        /*
        * 注册日志回调
        */
        static void registerLog(WriteServerLog writeLogCallBack);
        /*
        * 注册消息回调
        */
        static void registerRecv(RecvMsg recvMsgCallBack);
        /*
        * 发送消息
        */
        static int send(int socketID, const char *str, int len);
        /*
        * 启动服务端
        */
        static int start(int port, char *token);
        /*
         * 设置限制
         */
        static int setLimit(int socketID, int limitTimes, int interval);
        /*
         * 添加黑名单
         */
        static int addBlackIP(int socketID, std::string ip);
        /*
         * 移除黑名单
         */
        static int removeBlackIP(int socketID, std::string ip);
    };
}
#endif
