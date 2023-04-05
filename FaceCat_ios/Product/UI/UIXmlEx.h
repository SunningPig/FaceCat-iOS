/*
* FaceCat图形通讯框架
* 上海卷卷猫信息技术有限公司
*/

#ifndef __UIXMLEX_H__
#define __UIXMLEX_H__
#pragma once
#include "stdafx.h"
#include "FCUIXml.h"

namespace FaceCat{
    class UIXmlEx;

    /*
     * 额外解析
     */
    class IOutReWrite{
    public:
        /*
         * 创建视图
         */
        virtual FCView* createView(UIXmlEx *uiXmlEx, xmlNodePtr node){return 0;}
        /*
         * 更多解析
         */
        virtual bool moreAnalysis(FCView *view, UIXmlEx *uiXmlEx, xmlNodePtr node){return false;}
    };

    /*
     * XML对象
     */
    class UIXmlEx : public FCUIXml{
    public:
        /*
         * 视图集合
         */
        std::map<String, FCView*> m_viewsMap;
        /*
         * 远程脚本
         */
        HashMap<String, String> m_remoteScripts;
        /*
         * 新的视图
         */
        ArrayList<FCView*> m_newViews;
        /*
         * XML对象
         */
        xmlDocPtr m_xmlDoc;
    public:
        /*
         * 构造函数
         */
        UIXmlEx();
        /*
         * 析构函数
         */
        virtual ~UIXmlEx();
    public:
        /*
         * 自动选中第一行
         */
        void autoSelectFirstRow(FCGrid *grid);
        /*
         * 自动选中最后一行
         */
        void autoSelectLastRow(FCGrid *grid);
        /*
         * 创建控件
         */
        virtual FCView* createView(xmlNodePtr node, const String& type);
        /*
         * 查找控件
         */
        virtual FCView* findView(const String& name);
        /*
         * 获取列的索引
         */
        int getColumnsIndex(FCGrid *grid, std::map<int, FCGridColumn*> *columnsIndex);
        /*
         * 加载数据
         */
        virtual void loadData();
        /*
         * 加载文件
         */
        virtual void loadFile(const String& fileName, FCView *view);
        /*
         * 控件被添加方法
         */
        virtual void onAddView(FCView *view, xmlNodePtr node);
        /*
         * 读取节点
         */
        virtual FCView* readNode(xmlNodePtr node, FCView* parent);
        /*
         * 添加额外解析
         */
        static void addOutReWrite(String name, IOutReWrite *iOutReWrite);
    };
}
#endif
