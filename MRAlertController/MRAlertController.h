//
//  MRAlertController.h
//  Loops
//
//  Created by Yaw on 8/3/17.
//  Copyright © 2017 Mozat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MRAlertControllerStyle) {
    
    MRAlertControllerStyleAlert = 0,
    MRAlertControllerStyleAlertImage,
    MRAlertControllerStyleAlertTextField,
    MRAlertControllerStyleAlertImageTextField,
    
} NS_ENUM_AVAILABLE_IOS(8_0);


NS_CLASS_AVAILABLE_IOS(8_0) @interface MRAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(MRAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface MRAlertController : UIViewController

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(MRAlertControllerStyle)preferredStyle;

- (void)addAction:(MRAlertAction *)action;
@property (nonatomic, readonly) NSArray<MRAlertAction *> *actions;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
- (void)addImageViewWithConfigurationHandler:(void (^ __nullable)(UIImageView *imageVie))configurationHandler;

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) MRAlertControllerStyle preferredStyle;

@end

NS_ASSUME_NONNULL_END
