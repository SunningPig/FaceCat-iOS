/*
 * FaceCat图形通讯框架(非开源)
 * 著作权编号:2015SR229355+2020SR0266727
 * 上海卷卷猫信息技术有限公司
 */

#ifndef SYDATEPICKER_h
#define SYDATEPICKER_h
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>

@protocol SYDatePickerDelegate <NSObject>

@optional
- (void)picker:(UIDatePicker *)picker ValueChanged:(NSDate *)date;

@end

@interface SYDatePicker : UIView

@property  (weak, nonatomic) id<SYDatePickerDelegate> delegate;

@property  (strong, nonatomic) UIDatePicker *picker;

@property  (strong, nonatomic) NSDate *dates;

- (void)showInView:(UIView *)view withFrame:(CGRect)frame andDatePickerMode:(UIDatePickerMode)mode;

- (void)dismiss;

- (void)valueChanged:(UIDatePicker *)picker;
@end
#endif
