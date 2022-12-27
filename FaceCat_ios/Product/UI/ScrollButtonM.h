/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#ifndef SCROLLBUTTONM_h
#define SCROLLBUTTONM_h
class ScrollButtonM : public FCButton{
public:
    ScrollButtonM();
    virtual ~ScrollButtonM();
public:
    virtual void onPaintBackground(FCPaint *paint, const FCRect& clipRect);
};

#endif
