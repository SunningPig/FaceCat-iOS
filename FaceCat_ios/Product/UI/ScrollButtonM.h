/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#ifndef SCROLLBUTTONM_h
#define SCROLLBUTTONM_h

/*
 * 滚动按钮
 */
class ScrollButtonM : public FCButton{
public:
    /*
     * 构造函数
     */
    ScrollButtonM();
    /*
     * 析构函数
     */
    virtual ~ScrollButtonM();
public:
    /*
     * 重绘背景
     */
    virtual void onPaintBackground(FCPaint *paint, const FCRect& clipRect);
};

#endif
