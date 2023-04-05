/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#ifndef __ROLLINGFILEAPPENDER_H__
#define __ROLLINGFILEAPPENDER_H__
#pragma once
#include "stdafx.h"
#include "FileAppenderConfig.h"
#include "FileAppender.h"
#include "RollingFileAppenderConfig.h"

namespace FaceCat{
    /*
    * 滚动文件输出型日志
    */
    class RollingFileAppender : public FileAppender{
    public:
        /*
        * 构造函数
        */
        RollingFileAppender();
        /*
        * 构造函数
        */
        RollingFileAppender(RollingFileAppenderConfig *fileAppenderConfig);
        /*
        * 构造函数
        */
        RollingFileAppender(const String &configPath);
        /*
        * 析构函数
        */
        virtual ~RollingFileAppender();
    private:
        /*
        * 滚动日志文件的基础日志文件名称
        */
        String m_baseLogFileName;
        /*
        * 配置文件
        */
        RollingFileAppenderConfig *m_fileAppenderConfig;
        /*
        * 当前备份的文件的个数
        */
        int m_curSizeRollBackups;
    public:
        /*
        * 最大尺寸
        */
        long m_maxFileSize;
    public:
        /*
         * 追加日志之前,调整日志文件
         * @param logFile 日志文件
         */
        virtual void adjustFileBeforeAppend(const String &logFile);
        /*
        * 向文件中追加内容
        * @param logFile 日志文件
        * @param content 内容
        */
        bool append(const String &logFile, const String &content);
        /*
        * 计算日志文件的大小
        */
        virtual void calculateLogFileSize();
    private:
        /*
        * 合并目录
        * @param path1 目录1
        * @param path2 目录2
        */
        String combinePath(const String &path1, const String &path2);
    public:
        /*
        * 删除文件
        * @param fileName 文件名
        */
        void deleteFile(const String &fileName);
    private:
        /*
        * 检测当前滚动文件信息
        */
        void determineCurSizeRollBackups();
    public:
        /*
        * 资源释放
        */
        void dispose();
    private:
        /*
        * 获取当前滚动日志文件的索引
        * @param curFileName 当前文件
        */
        int getBackUpIndex(const String &curFileName);
        /*
        * 获取文件名
        * @param filePath 文件路径
        */
        String getFileNameFromFilePath(const String &filePath);
        /*
        * 从文件名里取得index
        * @param curFileName 当前文件
        * @param baseFileName 基础文件名
        * @param index 返回索引
        */
        bool getIndexFromFileName(const String &curFileName, const String &baseFileName, int *index);
    private:
        /*
        * 初始化单个日志文件信息
        * @param baseFile 基础文件
        * @param curFileName 当前文件
        */
        void initializeFromOneFile(const String &baseFile, const String &curFileName);
        /*
        * 初始化滚动文件信息
        * @param baseFile 基础文件
        * @param arrayFiles 文件数组
        */
        void initializeRollBackups(const String &baseFile, ArrayList<String> *arrayFiles);
    public:
        /*
        * 初始化当前日志文件
        */
        void initExistingLog();
        /*
        * 滚动文件
        * @param fromFile 源文件
        * @param toFile 目标文件
        */
        void rollFile(const String &fromFile, const String &toFile);
        /*
        * 滚动重新命名文件的名称
        */
        void rollOverRenameFiles(const String &baseFileName);
    public:
        /*
        * 输出调试日志
        * @param message 消息
        */
        void debug(const String &message);
        /*
        * 输出错误日志
        * @param message 消息
        */
        void error(const String &message);
        /*
        * 输出致命错误日志
        * @param message 消息
        */
        void fatal(const String &message);
        /*
        * 输出信息日志
        * @param message 消息
        */
        void info(const String &message);
        /*
        * 输出日志
        * @param logType 日志类型
        * @param message 消息
        */
        void log(int logType, const String &message);
        /*
        * 输出警告日志
        * @param message 消息
        */
        void warn(const String &message);
    };
}
#endif
