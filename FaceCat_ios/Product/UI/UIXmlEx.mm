/*
* FaceCat图形通讯框架(非开源)
* 著作权编号:2015SR229355+2020SR0266727
* 上海卷卷猫信息技术有限公司
*/

#include "stdafx.h"
#include "UIXmlEx.h"
#include "RibbonButton.h"
#include "RibbonButton2.h"
#include "FaceCatScript.h"
#include "CheckBoxT.h"
#include "RadioButtonM.h"

namespace FaceCat{
    static HashMap<String, IOutReWrite*> m_outReWrites;

    UIXmlEx::UIXmlEx(){
        m_xmlDoc = 0;
    }
    
    UIXmlEx::~UIXmlEx(){
        if(m_xmlDoc){
            xmlFreeDoc(m_xmlDoc);
            m_xmlDoc = 0;
        }
        m_viewsMap.clear();
        m_tempTabPages.clear();
    }
    
    void UIXmlEx::autoSelectFirstRow(FCGrid *grid){
        int rowsSize = (int)grid->m_rows.size();
        if(rowsSize > 0){
            ArrayList<FCGridRow*> selectedRows = grid->getSelectedRows();
            int selectedRowsSize = (int)selectedRows.size();
            if(selectedRowsSize == 0)
            {
                selectedRows.add(grid->m_rows.get(0));
                grid->setSelectedRows(selectedRows);
            }
        }
    }
    
    void UIXmlEx::autoSelectLastRow(FCGrid *grid){
        int rowsSize = (int)grid->m_rows.size();
        if(rowsSize > 0){
            ArrayList<FCGridRow*> selectedRows;
            selectedRows.add(grid->m_rows.get(rowsSize - 1));
            grid->setSelectedRows(selectedRows);
        }
    }
    
    FCView* UIXmlEx::createView(xmlNodePtr node, const String& type){
        int typeLen = (int)type.length();
        switch(typeLen){
            case 4;
            case 5:
            {
                if (type == L"input" || type == "view")
                {
                    HashMap<String, String> attributes = getAttributes(node);
                    if (attributes.containsKey(L"type"))
                    {
                        String inputType = attributes.get(L"type");
                        if (inputType == L"button")
                        {
                            return new FCButton;
                        }
                        else if (inputType == L"checkbox")
                        {
                            return new CheckBoxT;
                        }
                        else if (inputType == L"datetime")
                        {
                            return new FCDateTimePicker;
                        }
                        else if (inputType == L"radio")
                        {
                            return new RadioButtonM;
                        }
                        else if (inputType == L"range")
                        {
                            return new FCSpin;
                        }
                        else if (inputType == L"text")
                        {
                            return new FCTextBox;
                        }
                        else if(inputType == L"custom")
                        {
                            return createCustomView(node);
                        }
                    }
                    attributes.clear();
                }
                break;
            }
        }
        if(typeLen > 9){
            if (type == L"ribbonbutton")
            {
                return new RibbonButton();
            }
            else if (type == L"ribbonbutton2")
            {
                return new RibbonButton2();
            }
        }
        return FCUIXml::createView(node, type);
    }
    
    FCView* UIXmlEx::findView(const String& name){
        FCView *view = 0;
        map<String, FCView*>::iterator sIter = m_viewsMap.find(name);
        if(sIter != m_viewsMap.end()){
            view = sIter->second;
        }
        if(!view){
            view = FCUIXml::findView(name);
            m_viewsMap[name] = view;
        }
        if(!view){
            view = m_native->findView(name);
            m_viewsMap[name] = view;
        }
        return view;
    }
    
    int UIXmlEx::getColumnsIndex(FCGrid *grid, map<int, FCGridColumn*> *columnsIndex){
        ArrayList<FCGridColumn*> columns = grid->m_columns;
        for(int c = 0; c < columns.size(); c++){
            FCGridColumn *column = columns.get(c);
            (*columnsIndex)[FCTran::strToInt(column->getName().substr(4))] = column;
        }
        return 1;
    }
    
    void UIXmlEx::loadData(){
    }
    
    void UIXmlEx::loadFile(const String& fileName, FCView *view){
        m_viewsMap.clear();
        if(m_xmlDoc){
            xmlFreeDoc(m_xmlDoc);
            m_xmlDoc = 0;
        }
        m_viewsMap.clear();
        string xmlFileName = FCTran::StringTostring(fileName);
        m_xmlDoc = xmlReadFile(xmlFileName.c_str(), 0, XML_PARSE_NOBLANKS);
        if(m_xmlDoc){
            xmlNodePtr node = xmlDocGetRootElement(m_xmlDoc);
            xmlNodePtr spChildNode = node->children;
            while (spChildNode){
                String nodeName = FCTran::stringToString((char*)spChildNode->name);
                if(nodeName == L"body"){
                    readBody(spChildNode, view);
                }
                else if(nodeName == L"head"){
                    readHead(spChildNode, view);
                }
                spChildNode = spChildNode->next;
            }
        }
        m_tempTabPages.clear();
    }
    
    void UIXmlEx::onAddView(FCView *view, xmlNodePtr node){
        m_viewsMap[view->getName()] = view;
        FCUIXml::onAddView(view, node);
    }

    FCView* UIXmlEx::readNode(xmlNodePtr node, FCView* parent){
        String nodeName = FCTran::stringToString((char*)node->name);
        nodeName = FCTran::toLower(nodeName);
        if (nodeName == L"remotescript")
        {
            HashMap<String, String> attributesR = getAttributes(node);
            m_remoteScripts.put(attributesR.get(L"name"), FCTran::stringToString((char*)node->children->content));
            return 0;
        }
        String cid = L"";
        HashMap<String, String> attributes = getAttributes(node);
        if (attributes.containsKey(L"cid"))
        {
            cid = attributes.get(L"cid");
        }
        IOutReWrite *outReWrite = 0;
        if (m_outReWrites.containsKey(nodeName))
        {
            outReWrite = m_outReWrites.get(nodeName);
        }
        else if (m_outReWrites.containsKey(cid))
        {
            outReWrite = m_outReWrites.get(cid);
        }
        FCView *view = 0;
        if (outReWrite)
        {
           view = outReWrite->createView(this, node);
           if (!view)
           {
               view = createView(node, nodeName);
           }
        }
        else
        {
           view = createView(node, nodeName);
        }
        m_newViews.add(view);
        if(view){
            view->setNative(m_native);
            if (parent){
                parent->addView(view);
            }
            else{
                m_native->addView(view);
            }
            bool mAnalysis = false;
            if (outReWrite)
            {
               if (outReWrite->moreAnalysis(view, this, node))
               {
                   mAnalysis = true;
               }
            }
            if(!mAnalysis){
                setAttributesBefore(node, view);
                if(dynamic_cast<FCSplitLayoutDiv*>(view)){
                    createSplitLayoutSubAttribute(node, dynamic_cast<FCSplitLayoutDiv*>(view));
                }else if (dynamic_cast<FCChart*>(view)){
                    createChartSubAttribute(node, dynamic_cast<FCChart*>(view));
                }
                else if (dynamic_cast<FCTableLayoutDiv*>(view)){
                    createTableLayoutSubAttribute(node, dynamic_cast<FCTableLayoutDiv*>(view));
                }
                else{
                    readChildNodes(node, view);
                }
                setAttributesAfter(node, view);
            }
            view->update();
            onAddView(view, node);
        }
        else{
            createSubAttribute(node, parent);
        }
        return view;
    }

    void UIXmlEx::addOutReWrite(String name, IOutReWrite *iOutReWrite){
        m_outReWrites.put(name, iOutReWrite);
    }

    static bool m_isClickRunning = false;

    bool UIXmlEx::isClickRunning(){
        return m_isClickRunning;
    }

    void UIXmlEx::setClickRunning(bool value){
        m_isClickRunning = value;
    }

    bool UIXmlEx::goBack(){
        return false;
    }

    bool UIXmlEx::goForward(){
        return false;
    }

    bool UIXmlEx::canGoBack(){
        return false;
    }

    bool UIXmlEx::canGoForward(){
        return false;
    }
}
