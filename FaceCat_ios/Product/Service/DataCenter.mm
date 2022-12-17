/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#include "stdafx.h"
#include "DataCenter.h"
#include "UIXmlEx.h"
#include "ContextPaintEx.h"

DataCenter::DataCenter(){
}

DataCenter::~DataCenter(){
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

string DataCenter::getAppPath(){
    return [[[NSBundle mainBundle] resourcePath] UTF8String];
}

string DataCenter::getUserPath(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] UTF8String];
}

string DataCenter::getGuid()
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString*result = (NSString*)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    std::string ret=  [result UTF8String];
    return ret;
}

void DataCenter::startService(){
}
