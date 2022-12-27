/*
 * FaceCat图形通讯框架
 * 上海卷卷猫信息技术有限公司
 */

#import <Foundation/Foundation.h>
#import "SafeCompile.h"

@implementation SafeCompile



+(void)SetLabelTextAlignment:(UILabel*) label withTextAlignment:(UITextAlignment)textAlignment
{
    label.textAlignment = textAlignment;
}

+(void)SetScrollViewDelegate:(UIScrollView*)scrollView withViewController:(UIViewController*)view
{
    scrollView.delegate = view;
}

+(void)SetTextFieldDelegate:(UITextField*)textField withViewController:(UIViewController*)view
{
    textField.delegate = view;
}

+(void)SetTextFieldKeyBorderType:(UITextField*)textField withType:(UIKeyboardType)keyBoardType
{
    textField.keyboardType = keyBoardType;
}

+(void)SetTableViewDelegate:(UITableView*)tableView withViewController:(UIViewController*)view
{
    tableView.delegate = view;
}

+(void)SetUIImagePickerControllerSourceType:(UIImagePickerController*)imagePickerController
                        withSourceType:(NSUInteger)sourceType
{
    imagePickerController.sourceType = sourceType;
}

static NSString* m_qrCode = @"";

+(void)qrCodeCallBack:(NSString*)str{
    m_qrCode = str;
}

+(NSString*)getQrCode{
    NSString *nsStr = m_qrCode;
    m_qrCode = @"";
    return nsStr;
}

+(void)SetUIImagePickerControllerDelegate:(UIImagePickerController*)imagePickerController
                                 withView:(UIView*)view
{
    imagePickerController.delegate = view;
}
@end
