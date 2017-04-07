//
//  MRAlertController.h
//  Loops
//
//  Created by Yaw on 8/3/17.
//  Copyright © 2017 Mozat. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * _Nullable const MRDismissAlertController = @"dismissAlertController";

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MRAlertControllerStyle) {
    
    MRAlertControllerStyleAlert = 0,
    MRAlertControllerStyleAlertImage,
    MRAlertControllerStyleAlertTextField,
    MRAlertControllerStyleAlertImageTextField,
    MRAlertControllerStyleAlertCustom,
    MRAlertControllerStyleAlertCustomTitleImage

} NS_ENUM_AVAILABLE_IOS(8_0);

typedef NS_ENUM(NSInteger, MRAlertItemStyle) {
    
    MRAlertItemStyleNone = 0,
    MRAlertItemStyleSingle,
    MRAlertItemStyleDouble
} NS_ENUM_AVAILABLE_IOS(8_0);


NS_CLASS_AVAILABLE_IOS(8_0) @interface MRAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(MRAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


NS_CLASS_AVAILABLE_IOS(8_0) @interface MRAlertItem : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title titleImage:(id)titleImg value:(NSString *)value valueImage:(id)valueImg;
+ (instancetype)actionWithTitle:(NSString *)title titleImage:(id)titleImg style:(MRAlertItemStyle)style;

@property (nullable, nonatomic, readonly) id titleImage;
@property (nullable, nonatomic, readonly) NSString *title;
@property (nullable, nonatomic, readonly) id valueImage;
@property (nullable, nonatomic, readonly) NSString *value;
@property (nonatomic, readonly) MRAlertItemStyle style;
@end


NS_CLASS_AVAILABLE_IOS(8_0) @interface MRAlertController : UIViewController

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(MRAlertControllerStyle)preferredStyle dismissHandler:(void (^ __nullable)(BOOL isDismissedWithAction))dimissHandler;

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(MRAlertControllerStyle)preferredStyle;

- (void)addAction:(MRAlertAction *)action;
@property (nonatomic, readonly) NSArray<MRAlertAction *> *actions;

- (void)addItem:(MRAlertItem *)item;
@property (nonatomic, readonly) NSArray<MRAlertItem *> *items;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
- (void)addImageViewWithConfigurationHandler:(void (^ __nullable)(UIImageView *imageVie))configurationHandler;
- (void)addTitleImageViewWithConfigurationHandler:(void (^ __nullable)(UIImageView *imageVie))configurationHandler;

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) MRAlertControllerStyle preferredStyle;
@property (nonatomic, readonly) BOOL isDismissedWithAction;

@end

NS_ASSUME_NONNULL_END
