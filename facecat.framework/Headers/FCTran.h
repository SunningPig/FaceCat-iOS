/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#ifndef __CSTR_H__
#define __CSTR_H__
#pragma once
#include "stdafx.h"
#include "FCPaint.h"
#include "FCView.h"
#include "zlib.h"

namespace FaceCat{
    /*
     * 字符串处理
     */
    class FCTran{
    public:
        static double round(double x);
    public:
        /*
         * 连接字符串
         */
        static void contact(wchar_t *str, const wchar_t *str1, const wchar_t *str2, const wchar_t *str3);
        /**
         * 锚定信息转化为字符
         * @param anchor  锚定信息
         * @returns 字符
         */
        static String anchorToStr(const FCAnchor& anchor);
        /**
         * 布尔型数值转换为字符
         * @param value   数值
         * @returns 字符
         */
        static String boolToStr(bool value);
        /**
         * 颜色转换为字符
         * @param color  颜色
         * @returns 字符
         */
        static String colorToStr(Long color);
        /**
         * 内容布局转字符串
         * @param contentAlignment  内容布局
         * @returns 字符串
         */
        static String contentAlignmentToStr(FCContentAlignment contentAlignment);
        /*
         * 鼠标形状转为字符串
         */
        static String cursorToStr(FCCursors cursor);
        /**
         * 双精度浮点型数值转换为字符
         * @param value  数值
         * @returns 字符
         */
        static String doubleToStr(double value);
        /**
         * 绑定信息转换为字符
         * @param dock  绑定信息
         * @returns 字符
         */
        static String dockToStr(FCDockStyle dock);
        /**
         * 单精度浮动点型数值转换为字符
         * @param value  数值
         * @returns 字符
         */
        static String floatToStr(float value);
        /**
         * 字体转换为字符
         * @param font  字体
         * @returns 字符
         */
        static String fontToStr(FCFont *font);
        /**
         * 横向排列方式转换为字符
         * @param horizontalAlign  横向排列方式
         * @returns 字符
         */
        static String horizontalAlignToStr(FCHorizontalAlign horizontalAlign);
        /**
         * 整型数值转换为字符
         * @param value  数值
         * @returns 字符
         */
        static String intToStr(int value);
        /**
         * 布局样式转换为字符
         * @param layoutStyle  布局样式转
         * @returns 布局样式
         */
        static String layoutStyleToStr(FCLayoutStyle layoutStyle);
        /**
         * 长整型数值转换为字符
         * @param value   数值
         * @returns 字符串
         */
        static String longToStr(Long value);
        /**
         * 边距转换为字符
         * @param padding  边距
         * @returns 字符
         */
        static String paddingToStr(const FCPadding& padding);
        /**
         * 坐标转换为字符
         * @param mp  坐标
         * @returns 字符
         */
        static String pointToStr(const FCPoint& mp);
        /**
         * 矩形转换为字符
         * @param rect  矩形
         * @returns 字符
         */
        static String rectToStr(const FCRect& rect);
        /**
         * 大小转换为字符
         * @param size  大小
         * @returns 字符
         */
        static String sizeToStr(const FCSize& size);
        /**
         * 字符转换为锚定信息
         * @param str  字符
         * @returns 锚定信息
         */
        static FCAnchor strToAnchor(const String& str);
        /**
         * 字符转换为布尔型
         * @param str  字符
         * @returns 数值
         */
        static bool strToBool(const String& str);
        /**
         * 字符转换为颜色
         * @param str  字符
         * @returns 颜色
         */
        static Long strToColor(const String& str);
        /**
         * 字符串转内容布局
         * @param str  字符
         * @returns 字符串
         */
        static FCContentAlignment strToContentAlignment(const String& str);
        /*
         * 字符串转为鼠标形状
         */
        static FCCursors strToCursor(const String& str);
        /**
         * 字符转换为绑定信息
         * @param str  字符
         * @returns 绑定信息
         */
        static FCDockStyle strToDock(const String& str);
        /**
         * 字符转换为双精度浮点型数值
         * @param str  字符
         * @returns 数值
         */
        static double strToDouble(const String& str);
        /*
         * 字符转换为双精度浮点型数值
         */
        static double strToDouble(const wchar_t *str);
        /**
         * 字符转换为单精度浮点型数值
         * @param str  字符
         * @returns 数值
         */
        static float strToFloat(const String& str);
        /**
         * 字符转换为字体
         * @param str  字符
         * @returns 字体
         */
        static FCFont strToFont(const String& str);
        /**
         * 字符转换为横向排列方式
         * @param str  字符
         * @returns 字符
         */
        static FCHorizontalAlign strToHorizontalAlign(const String& str);
        /**
         * 字符转换为整型数值
         * @param str  字符
         * @returns 数值
         */
        static int strToInt(const String& str);
        /**
         * 字符转换为整型数值
         * @param str  字符
         * @returns 数值
         */
        static int strToInt(const wchar_t *str);
        /**
         * 布局样式转换为字符
         * @param str  字符
         * @returns 布局样式
         */
        static FCLayoutStyle strToLayoutStyle(const String& str);
        /**
         * 字符转换位长整型数值
         * @param str  字符串
         * @returns 长整型
         */
        static Long strToLong(const String& str);
        /**
         * 字符转换位长整型数值
         * @param str  字符串
         * @returns 长整型
         */
        static Long strToLong(const wchar_t *str);
        /**
         * 字符转换为边距
         * @param str  字符
         * @returns 边距
         */
        static FCPadding strToPadding(const String& str);
        /**
         * 字符转换为坐标
         * @param str  字符
         * @returns 坐标
         */
        static FCPoint strToPoint(const String& str);
        /**
         * 字符转换为矩形
         * @param str  字符
         * @returns 矩形
         */
        static FCRect strToRect(const String& str);
        /**
         * 字符转换为大小
         * @param str  字符
         * @returns 大小
         */
        static FCSize strToSize(const String& str);
        /**
         * 字符转换为纵向排列方式
         * @param str  字符
         * @returns 字符
         */
        static FCVerticalAlign strToVerticalAlign(const String& str);
        /**
         * 纵向排列方式转换为字符
         * @param verticalAlign  横向排列方式
         * @returns 字符
         */
        static String verticalAlignToStr(FCVerticalAlign verticalAlign);
        /*
         * 获取程序路径
         */
        static std::string getAppPath();
        /*
         * 获取日期的数值
         */
        static double getDateNum(int tm_year, int tm_mon, int tm_mday, int tm_hour, int tm_min, int tm_sec, int tm_msec);
        /*
         * 根据数值获取日期
         */
        static void getDateByNum(double num, int *tm_year, int *tm_mon, int *tm_mday, int *tm_hour, int *tm_min, int *tm_sec, int *tm_msec);
        /*
         * 获取格式化后的日期
         */
        static String getFormatDate(const String& format, int year, int month, int day, int hour, int minute, int second);
        /**
         * 根据保留小数的位置将double型转化为String型
         * @param value  值
         * @param digit 保留小数点
         */
        static String getValueByDigit(double value, int digit);
        /*
         * 获取格式化后的日期
         */
        static String getFormatDate(double date);
        /*
         * 压缩
         */
        static int gZCompress(Byte *data, uLong ndata, Byte *zdata, uLong *nzdata);
        /*
         * 解压
         */
        static int gZDeCompress(Byte *zdata, uLong nzdata, Byte *data, uLong *ndata);
        /*
         * 十六进制转十进制
         */
        static int hexToDec(const char *str);
        /*
         * 替换字符串
         */
        static std::string replace(const std::string& str, const std::string& src, const std::string& dest);
        /*
         * 替换字符串
         */
        static String replace(const String& str, const String& src, const String& dest);
        /**
         * 安全的Double转Float
         * @param value  值
         * @param digit 保留小数位数
         * @returns  Float
         */
        static float safeDoubleToFloat(double value, int digit);
        /*
         * 分割字符串
         */
        static ArrayList<String> split(const String& str, const String& pattern);
        /*
         * 短字符串转长字符串
         */
        static String stringToString(const std::string& strSrc);
        /*
         * 转为小写
         */
        static String toLower(const String& str);
        /*
         * 转为大写
         */
        static String toUpper(const String& str);
        /*
         * 长字符串转短字符串
         */
        static std::string StringTostring(const String& strSrc);
    };
}
#endif
