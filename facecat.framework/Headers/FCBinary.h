/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#ifndef __FCBINARY_H__
#define __FCBINARY_H__
#include "stdafx.h"
#include "FCTran.h"
#pragma once
#define    DATA_LACK -1
#define PAGE_Size 8192
typedef unsigned char BYTE;
typedef BYTE *PBYTE;

namespace FaceCat{
    /**
     * 流解析
     */
    class FCBinary{
    public:
        PBYTE m_pBase;
        unsigned int m_nDataSize;
        unsigned int m_nSize;
        unsigned int m_nInitSize;
        bool m_bSustainSize;
        static unsigned int m_dwPageSize;
        unsigned int deAllocateBuffer(unsigned int nRequestedSize);
        unsigned int getMemSize();
    public:
        /**
         * 创建流
         */
        FCBinary();
        /*
         * 析构函数
         */
        virtual ~FCBinary();
        const FCBinary& operator+(FCBinary& buff);
        bool m_bSingleRead;
        unsigned int m_nReadPos;
    public:
        /*
         * 清除
         */
        void clearBytes();
        /*
         * 拷贝
         */
        void copy(FCBinary& buffer);
        /*
         * 清除缓存
         */
        unsigned int deleteBuffer(unsigned int nSize);
        /*
         * 清除末尾
         */
        unsigned int deleteEnd(unsigned int nSize);
        /*
         * 读取文件
         */
        void fileRead(const String& strFileName);
        /*
         * 写文件
         */
        void fileWrite(const String& strFileName);
        /*
         * 获取流文件
         */
        PBYTE getBytes(unsigned int nPos = 0);
        /*
         * 获取流的长度
         */
        unsigned int getBytesLen();
        /*
         * 初始化
         */
        void initialize(unsigned int nInitsize, bool bSustain);
        /*
         * 插入
         */
        unsigned int insert(const void *pData, unsigned int nSize);
        /*
         * 插入
         */
        unsigned int insert(String& strData);
        /*
         * 读取
         */
        unsigned int read(void *pData, unsigned int nSize);
        /**
         * 读取Char数据
         */
        char readChar();
        /**
         * 读取Double数据
         */
        double readDouble();
        /**
         * 读取Float数据
         */
        float readFloat();
        /**
         * 读取Int数据
         */
        int readInt();
        /**
         * 读取Long数据
         */
        Long readLong();
        /**
         * 读取Short数据
         */
        short readShort();
        /**
         * 读取字符串数据
         */
        String readString();
        /**
         * 读取字符串数据
         */
        std::string readString2();
        /*
         * 重新开辟内存
         */
        unsigned int reAllocateBuffer(unsigned int nRequestedSize);
        /*
         * 跳过数据
         */
        unsigned int skipData(int nSize);
        /**
         * 写入流
         * @param pData  流
         * @param nSize   长度
         */
        unsigned int write(const void *pData, unsigned int nSize);
        /*
         * 写入String型数据
         */
        unsigned int write(String& strData);
        /**
         * 写入Char型数据
         * @param cValue   Char型数据
         */
        void writeChar(char cValue);
        /**
         * 写入Double型数据
         * @param dValue   Double型数据
         */
        void writeDouble(double dValue);
        /**
         * 写入Float型数据
         * @param fValue   Float型数据
         */
        void writeFloat(float fValue);
        /**
         * 写入Int型数据
         * @param nValue   Int型数据
         */
        void writeInt(int nValue);
        /**
         * 写入Long型数据
         * @param hValue   Long型数据
         */
        void writeLong(Long hValue);
        /**
         * 写入Short型数据
         * @param sValue   Short型数据
         */
        void writeShort(short sValue);
        /**
         * 写入字符串数据
         * @param strData   字符串数据
         */
        unsigned int writeString(const String& strData);
        /**
         * 写入字符串数据
         * @param val   字符串数据
         */
        unsigned int writeString(const std::string& strData);
    };
}

#endif
