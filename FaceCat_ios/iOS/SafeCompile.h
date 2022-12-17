/*FaceCat Framework v11.0
 
 */

#ifndef SafeCompile_h
#define SafeCompile_h
#import <UIKit/UIKit.h>

@interface SafeCompile : NSObject

+(void)SetLabelTextAlignment:(UILabel*) label withTextAlignment:(UITextAlignment)textAlignment;

+(void)SetScrollViewDelegate:(UIView*)scrollView withViewController:(UIViewController*)view;

+(void)SetTextFieldDelegate:(UITextField*)textField withViewController:(UIViewController*)view;

+(void)SetTextFieldKeyBorderType:(UITextField*)textField withType:(UIKeyboardType)keyBoardType;

+(void)SetTableViewDelegate:(UITableView*)tableView withViewController:(UIViewController*)view;

+(void)SetUIImagePickerControllerSourceType:(UIImagePickerController*)imagePickerController
                        withSourceType:(NSUInteger)sourceType;

+(void)SetUIImagePickerControllerDelegate:(UIImagePickerController*)imagePickerController
                       withView:(UIView*)view;

+(void)qrCodeCallBack:(NSString*)str;
+(NSString*)getQrCode;
@end

#endif
