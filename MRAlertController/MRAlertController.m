//
//  MRAlertController.m
//  Loops
//
//  Created by Yaw on 8/3/17.
//  Copyright © 2017 Mozat. All rights reserved.
//

#import "MRAlertController.h"
#import "UIButton+Style.h"
#import "MRAlertActionCollectionViewCell.h"
#import "MRAlertCustomCollectionViewCell.h"
#import "MRAlertSingleItemCollectionViewCell.h"
#import "MRAlertCurveActionCollectionViewCell.h"
#import "UIColor+Hex.h"

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define DOUBLE_COLLECTION_HEIGHT @(49)
#define SINGLE_COLLECTION_HEIGHT @(59)
#define COLLECTION_HEIGHT @(49)
#define ACTION_CURVE_COLLECTION_HEIGHT @(63)
#define DOUBLE_COLLECTION_SPACING @(14)
#define COLLECTION_SPACING @(0.5)
#define TEXTFIELD_LIMIT @(51)

typedef void (^Handler)(MRAlertAction *action);

@interface MRAlertAction()

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) id titleImg;
@property (assign, nonatomic) MRAlertActionStyle actionStyle;
@property (nonatomic, copy, nullable) Handler handler;

@end

@implementation MRAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(MRAlertAction *action))handler {
    
    MRAlertAction *alertAction = [[MRAlertAction alloc] init];
    alertAction.titleString = title;
    alertAction.titleImg = nil;
    alertAction.actionStyle = MRAlertActionStyleNone;
    alertAction.handler = handler;
    return alertAction;
}

+ (instancetype)actionWithTitle:(nullable NSString *)title titleImage:(nullable id)titleImg style:(MRAlertActionStyle)style handler:(void (^ __nullable)(MRAlertAction *action))handler {
    
    MRAlertAction *alertAction = [[MRAlertAction alloc] init];
    alertAction.titleString = title;
    alertAction.titleImg = titleImg;
    alertAction.actionStyle = style;
    alertAction.handler = handler;
    return alertAction;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    MRAlertAction *alertAction = [[[self class] allocWithZone:zone] init];
    alertAction.titleString = self.titleString;
    alertAction.handler = self.handler;
    return alertAction;
}

- (NSString *)title {
    ;
    return self.titleString;
}

- (id)titleImage {
    
    return self.titleImg;
}

- (MRAlertActionStyle)style {
    
    return self.actionStyle;
}

- (void)triggerHandler {
    
    self.handler(self);
}

@end

@interface MRAlertItem()

@property (strong, nonatomic) id titleImg;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) id valueImg;
@property (strong, nonatomic) NSString *valueString;
@property (assign, nonatomic) MRAlertItemStyle itemStyle;

@end

@implementation MRAlertItem

+ (instancetype)actionWithTitle:(NSString *)title titleImage:(id)titleImg value:(NSString *)value valueImage:(id)valueImg {

    MRAlertItem *alertItem = [[MRAlertItem alloc] init];
    alertItem.titleImg = titleImg;
    alertItem.titleString = title;
    alertItem.valueString = value;
    alertItem.valueImg = valueImg;
    alertItem.itemStyle = MRAlertItemStyleDouble;
    return alertItem;
}

+ (instancetype)actionWithTitle:(NSString *)title titleImage:(id)titleImg style:(MRAlertItemStyle)style  {

    MRAlertItem*alertItem = [[MRAlertItem alloc] init];
    alertItem.titleImg = titleImg;
    alertItem.titleString = title;
    alertItem.itemStyle = style;
    return alertItem;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    MRAlertItem *alertItem = [[[self class] allocWithZone:zone] init];
    alertItem.titleString = self.titleString;
    alertItem.titleImg = self.titleImg;
    alertItem.valueString = self.valueString;
    alertItem.valueImg = self.valueImg;
    return alertItem;
}

- (id)titleImage {
    
    return self.titleImg;
}

- (NSString *)title {
    
    return self.titleString;
}

- (NSString *)value {
    
    return self.valueString;
}

- (id)valueImage {
    
    return self.valueImg;
}

- (MRAlertItemStyle)style {
    
    return self.itemStyle;
}

- (void)dealloc {
    
    self.titleImg = nil;
    self.titleString = nil;
    self.valueImg = nil;
    self.valueString = nil;
}

@end

typedef void (^ConfigurationHandler)(UITextField *textField);
typedef void (^AlertCustomConfigurationHandler)(UIView *view);
typedef void (^ActionTitleConfigurationHandler)(UITextField *textField);
typedef void (^ImageConfigurationHandler)(UIImageView *imageView);
typedef void (^TitleImageConfigurationHandler)(UIImageView *imageView);
typedef void (^Dismissed)(BOOL isDismissedWithAction);

@interface MRAlertController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) CGFloat constant;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *alertTextView;
@property (weak, nonatomic) IBOutlet UITextField *alertTextField;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UICollectionView *actionCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *customCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *actionTitleLabel;

@property (assign, nonatomic) MRAlertControllerStyle style;
@property (assign, nonatomic) BOOL isDismissedAction;

@property (assign, nonatomic) BOOL isKeyboardShown;
#pragma mark -- Alert View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewCenterYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewCenterXContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewTrailingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewWidthConstraint;

#pragma mark -- Alert Title Image View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleImageViewBottomConstraint;

#pragma mark -- Alert Title View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleViewImageViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleViewMessageViewBottomConstraint;

#pragma mark -- Alert Title Label Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleLableTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleLableButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleLableLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTitleLableTrailingConstraint;

#pragma mark -- Alert Image View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageViewMessageViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageViewTextFieldViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageViewCustomeViewBottomConstraint;

#pragma mark -- Alert Image Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageBottomConstraint;

#pragma mark -- Alert Message View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertMessageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertMessageViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertMessageViewTextFieldViewBottomConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertMessageViewActionViewBottomConstraint;

#pragma mark -- Alert Text Field View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTextFieldViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTextFieldViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTextFieldViewBottomConstraint;

#pragma mark -- Alert Action View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionViewHeightConstraint;

#pragma mark -- Alert Action Title View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionTitleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionTitleBottomConstraint;

#pragma mark -- Alert Action Collection View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionCollectionViewHeightConstraint;

#pragma mark -- Alert Custom Collection View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertCustomCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertCustomCollectionViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertCustomCollectionViewBottomConstraint;


@property (strong, nonatomic) NSMutableArray<UITextField *> *mutableTextFields;
@property (strong, nonatomic) NSMutableArray<MRAlertAction *> *mutableActions;
@property (strong, nonatomic) NSMutableArray<MRAlertItem *> *mutableItems;

@property (nonatomic, copy, nullable) AlertCustomConfigurationHandler alertCustomConfigurationHandler;
@property (nonatomic, copy, nullable) ActionTitleConfigurationHandler actionTitleConfigurationHandler;
@property (nonatomic, copy, nullable) ConfigurationHandler configurationHandler;
@property (nonatomic, copy, nullable) ImageConfigurationHandler imageConfigurationHandler;
@property (nonatomic, copy, nullable) TitleImageConfigurationHandler titleImageConfigurationHandler;
@property (nonatomic, copy, nullable) Dismissed dismissHandler;

- (void)configureInterfaceWithStype:(MRAlertControllerStyle)style;

@end

@implementation MRAlertController

@synthesize title;
@synthesize message;
@synthesize textFields;
@synthesize actionTitle;

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message actionTitle:(nullable NSString *)actionTitle preferredStyle:(MRAlertControllerStyle)preferredStyle dismissHandler:(void (^ __nullable)(BOOL isDismissedWithAction))dimissHandler {
    
    MRAlertController *controller = [[MRAlertController alloc]initWithNibName:NSStringFromClass([MRAlertController class]) bundle:[NSBundle mainBundle]];
    controller.title = title;
    controller.message = message;
    controller.actionTitle = actionTitle;
    controller.style = preferredStyle;
    controller.dismissHandler = dimissHandler;
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.view.backgroundColor = [UIColor clearColor];
    return controller;
}

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(MRAlertControllerStyle)preferredStyle dismissHandler:(void (^ __nullable)(BOOL isDismissedWithAction))dimissHandler {
    
    MRAlertController *controller = [[MRAlertController alloc]initWithNibName:NSStringFromClass([MRAlertController class]) bundle:[NSBundle mainBundle]];
    controller.title = title;
    controller.message = message;
    controller.actionTitle = @"";
    controller.style = preferredStyle;
    controller.dismissHandler = dimissHandler;
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.view.backgroundColor = [UIColor clearColor];
    return controller;
}

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(MRAlertControllerStyle)preferredStyle {
    
    MRAlertController *controller = [[MRAlertController alloc]initWithNibName:NSStringFromClass([MRAlertController class]) bundle:[NSBundle mainBundle]];
    controller.title = title;
    controller.message = message;
    controller.actionTitle = @"";
    controller.style = preferredStyle;
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.view.backgroundColor = [UIColor clearColor];
    return controller;
}

- (void)addAction:(MRAlertAction *)action {
    
    if (!self.mutableActions) {
        self.mutableActions = [NSMutableArray array];
    }
    [self.mutableActions addObject:action];
}

- (void)addItem:(MRAlertItem *)item {
    
    if (self.style == MRAlertControllerStyleAlertCustom || self.style == MRAlertControllerStyleAlertCustomTitleImage) {
        
        if (!self.mutableItems) {
            self.mutableItems = [NSMutableArray array];
        }
        [self.mutableItems addObject:item];
    }
}

- (void)addCustomAlertWithConfigurationHandler:(void (^ __nullable)(UIView *view))configurationHandler {

    self.alertCustomConfigurationHandler = configurationHandler;
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler {
    
    if (self.style == MRAlertControllerStyleAlert || self.style == MRAlertControllerStyleAlertImage) {
        
        configurationHandler(nil);
        return;
    }
    if (!self.mutableTextFields) {
        
        self.mutableTextFields = [NSMutableArray array];
    }
    self.alertTextView.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
    self.alertTextView.layer.borderWidth = 0.5f;
    self.configurationHandler = configurationHandler;
}

- (void)addImageViewWithConfigurationHandler:(void (^ __nullable)(UIImageView *imageVie))configurationHandler {
    
    if (self.style == MRAlertControllerStyleAlert || self.style == MRAlertControllerStyleAlertTextField) {
        
        configurationHandler(nil);
        return;
    }
    if (!self.mutableTextFields) {
        
        self.mutableTextFields = [NSMutableArray array];
    }
    self.imageConfigurationHandler = configurationHandler;
}

- (void)addTitleImageViewWithConfigurationHandler:(void (^ __nullable)(UIImageView *imageVie))configurationHandler {
    
    if (self.style != MRAlertControllerStyleAlertCustomTitleImage) {
        
        configurationHandler(nil);
        return;
    }
    self.titleImageConfigurationHandler = configurationHandler;
}

- (void)configureInterfaceWithStype:(MRAlertControllerStyle)style {
    
    self.constant = self.alertViewCenterYConstraint.constant;
    if (self.actionTitle.length <=0) {
        
        self.alertActionTitleTopConstraint.constant = 0;
        self.alertActionViewBottomConstraint.constant = 0;
    }

    switch (self.preferredStyle) {
        case MRAlertControllerStyleAlert:
            self.customCollectionView.hidden = true;
            self.alertTextView.hidden = true;
            self.customView.hidden = true;
            self.alertTitleViewMessageViewBottomConstraint.priority = 999;
            self.alertTitleViewImageViewBottomConstraint.priority = 250;
            self.alertImageViewMessageViewBottomConstraint.priority = 250;
            self.alertMessageViewActionViewBottomConstraint.priority = 999;
            self.alertMessageViewTextFieldViewBottomConstaint.priority = 250;
            self.alertCustomCollectionViewTopConstraint.priority = 250;
            if (self.title == nil) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.title.length < 1) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.message == nil) {
                self.alertTitleViewMessageViewBottomConstraint.constant = 0;
            }
            if (self.message.length < 1) {
                self.alertTitleViewMessageViewBottomConstraint.constant = 0;
            }
            break;
        case MRAlertControllerStyleAlertImage:
            self.customCollectionView.hidden = true;
            self.alertTextView.hidden = true;
            self.alertTitleViewImageViewBottomConstraint.priority = 999;
            self.alertTitleViewMessageViewBottomConstraint.priority = 250;
            self.alertImageViewMessageViewBottomConstraint.priority = 999;
            self.alertMessageViewActionViewBottomConstraint.priority = 999;
            self.alertMessageViewTextFieldViewBottomConstaint.priority = 250;
            self.alertTextFieldViewBottomConstraint.priority = 250;
            self.alertCustomCollectionViewTopConstraint.priority = 250;

            if (self.title == nil) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.title.length < 1) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.message == nil) {
                self.alertImageViewMessageViewBottomConstraint.constant = 0;
            }
            if (self.message.length < 1) {
                self.alertImageViewMessageViewBottomConstraint.constant = 0;
            }
            break;
        case MRAlertControllerStyleAlertImageTextField:
            self.customCollectionView.hidden = true;
            self.alertTitleViewImageViewBottomConstraint.priority = 999;
            self.alertTitleViewMessageViewBottomConstraint.priority = 250;
            self.alertImageViewMessageViewBottomConstraint.priority = 999;
            self.alertMessageViewActionViewBottomConstraint.priority = 250;
            self.alertMessageViewTextFieldViewBottomConstaint.priority = 999;
            self.alertCustomCollectionViewTopConstraint.priority = 250;
            if (self.title == nil) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.title.length < 1) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.message == nil) {
                self.alertImageViewTextFieldViewBottomConstraint.priority = 999;
                self.alertImageViewMessageViewBottomConstraint.priority = 250;
                self.alertMessageViewTextFieldViewBottomConstaint.priority = 250;
            }
            if (self.message.length < 1) {
                self.alertImageViewTextFieldViewBottomConstraint.priority = 999;
                self.alertImageViewMessageViewBottomConstraint.priority = 250;
                self.alertMessageViewTextFieldViewBottomConstaint.priority = 250;
            }
            break;
        case MRAlertControllerStyleAlertTextField:
            self.customCollectionView.hidden = true;
            self.customView.hidden = true;
            self.alertTitleViewMessageViewBottomConstraint.priority = 999;
            self.alertTitleViewImageViewBottomConstraint.priority = 250;
            self.alertCustomCollectionViewTopConstraint.priority = 250;

            if (self.title == nil) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.title.length < 1) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.message == nil) {
                self.alertTitleViewMessageViewBottomConstraint.constant = 0;
            }
            if (self.message.length < 1) {
                self.alertTitleViewMessageViewBottomConstraint.constant = 0;
            }
            break;
        case MRAlertControllerStyleAlertCustom:
            self.customCollectionView.hidden = false;
            self.imageView.hidden = true;
            self.alertTextView.hidden = true;
            self.alertTitleViewImageViewBottomConstraint.priority = 999;
            self.alertTitleViewMessageViewBottomConstraint.priority = 250;
            self.alertImageViewMessageViewBottomConstraint.priority = 999;
            self.alertImageViewMessageViewBottomConstraint.constant = 15;
            self.alertMessageViewActionViewBottomConstraint.priority = 999;
            self.alertMessageViewTextFieldViewBottomConstaint.priority = 250;
            self.alertTextFieldViewBottomConstraint.priority = 250;
            self.alertImageTopConstraint.priority = 250;
            self.alertImageBottomConstraint.priority = 250;
            self.alertImageViewCustomeViewBottomConstraint.priority = 250;
            self.alertCustomCollectionViewTopConstraint.priority = 999;
            self.alertCustomCollectionViewBottomConstraint.priority = 999;
            self.alertCustomCollectionViewHeightConstraint.priority = 999;
            
            if (self.title == nil) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.title.length < 1) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.message == nil) {
                self.alertImageViewMessageViewBottomConstraint.constant = 0;
            }
            if (self.message.length < 1) {
                self.alertImageViewMessageViewBottomConstraint.constant = 0;
            }
            break;
        case MRAlertControllerStyleAlertCustomTitleImage:
            self.customCollectionView.hidden = false;
            self.imageView.hidden = true;
            self.alertTextView.hidden = true;
            self.alertTitleViewImageViewBottomConstraint.priority = 999;
            self.alertTitleViewMessageViewBottomConstraint.priority = 250;
            self.alertImageViewMessageViewBottomConstraint.priority = 999;
            self.alertImageViewMessageViewBottomConstraint.constant = 15;
            self.alertMessageViewActionViewBottomConstraint.priority = 999;
            self.alertMessageViewTextFieldViewBottomConstaint.priority = 250;
            self.alertTextFieldViewBottomConstraint.priority = 250;
            self.alertImageTopConstraint.priority = 250;
            self.alertImageBottomConstraint.priority = 250;
            self.alertImageViewCustomeViewBottomConstraint.priority = 250;
            self.alertCustomCollectionViewTopConstraint.priority = 999;
            self.alertCustomCollectionViewBottomConstraint.priority = 999;
            self.alertCustomCollectionViewHeightConstraint.priority = 999;

            if (self.title == nil) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.title.length < 1) {
                self.alertTitleLableTopConstraint.constant = 0;
            }
            if (self.message == nil) {
                self.alertImageViewMessageViewBottomConstraint.constant = 0;
            }
            if (self.message.length < 1) {
                self.alertImageViewMessageViewBottomConstraint.constant = 0;
            }
            break;
        default:
            break;
    }
    if IS_IPHONE_5 {
        self.alertViewLeadingConstraint.priority = 999;
        self.alertViewTrailingContraint.priority = 999;
        self.alertViewWidthConstraint.priority = 750;
    }
    else {
        self.alertViewLeadingConstraint.priority = 750;
        self.alertViewTrailingContraint.priority = 750;
        self.alertViewWidthConstraint.priority = 999;
    }
}

- (MRAlertControllerStyle)preferredStyle {
    
    return self.style;
}

- (BOOL)isDismissedWithAction {
    
    return self.isDismissedAction;
}

- (NSArray<UITextField *> *)textFields {
    
    return [self.mutableTextFields copy];
}

- (NSArray<UIAlertAction *> *)actions {
    
    return [self.mutableActions copy];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isDismissedAction = NO;
    [self configureInterfaceWithStype:self.preferredStyle];
    
    [self.actionCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MRAlertActionCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([MRAlertActionCollectionViewCell class])];
    [self.actionCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MRAlertCurveActionCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([MRAlertCurveActionCollectionViewCell class])];
    [self.customCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MRAlertCustomCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([MRAlertCustomCollectionViewCell class])];
    [self.customCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MRAlertSingleItemCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([MRAlertSingleItemCollectionViewCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.alertView.layer.cornerRadius = 10.0f;
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;
    self.actionTitleLabel.text = self.actionTitle;
    
    if (self.style == MRAlertControllerStyleAlertTextField || self.style == MRAlertControllerStyleAlertImageTextField) {
        
        if (self.configurationHandler && self.alertTextField) {
            
            [self.mutableTextFields addObject:self.alertTextField];
            self.configurationHandler(self.alertTextField);
            self.alertView.hidden = YES;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
    }
    if (self.style == MRAlertControllerStyleAlertImage || self.style == MRAlertControllerStyleAlertImageTextField ) {
        
        if (self.imageConfigurationHandler && self.imageView) {
            
            self.imageConfigurationHandler(self.imageView);
        }
    }
    if (self.style == MRAlertControllerStyleAlertCustom ) {
        
        if (self.mutableItems && self.mutableItems.count > 0) {
            
            [self.customCollectionView reloadData];
        }
    }
    if (self.style == MRAlertControllerStyleAlertCustomTitleImage) {
        
        if (self.titleImageConfigurationHandler && self.titleImageView) {
            
            self.titleImageConfigurationHandler(self.titleImageView);
        }
    }
    if (!self.mutableActions || self.mutableActions.count < 1) {
        self.mutableActions = @[
                                [MRAlertAction actionWithTitle:@"OK" handler:^(MRAlertAction * _Nonnull action) { }]
                                ].mutableCopy;
    }
    
    if (self.alertCustomConfigurationHandler && self.alertView) {
        
        self.alertCustomConfigurationHandler(self.alertView);
    }
    
    if (message.length <= 0) {
        
        if (!self.mutableItems) {
            self.alertMessageViewActionViewBottomConstraint.constant = 15;
        }
        if (self.mutableItems.count <= 0) {
            self.alertMessageViewActionViewBottomConstraint.constant = 15;
        }
    }
    [self.actionCollectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.actionCollectionView reloadData];
    [self.customCollectionView reloadData];
    if (self.style == MRAlertControllerStyleAlertTextField || self.style == MRAlertControllerStyleAlertImageTextField) {
        
        if (self.configurationHandler && self.alertTextField) {
            
            self.alertView.hidden = NO;
            [self.alertTextField becomeFirstResponder];
        }
    }
    
    if (self.style == MRAlertControllerStyleAlertCustomTitleImage) {
        
        self.alertTitleImageViewBottomConstraint.constant = self.titleImageView.frame.size.height / 2;
        self.alertTitleLableTopConstraint.constant = (self.titleImageView.frame.size.height / 2) + 14.5;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAlertController:) name:MRDismissAlertController object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    if (self.mutableTextFields && self.mutableTextFields.count > 0) {
        [self.mutableTextFields removeAllObjects];
        self.mutableTextFields = nil;
    }
    if (self.mutableActions && self.mutableActions.count > 0) {
        [self.mutableActions removeAllObjects];
        self.mutableActions = nil;
    }
    if (self.mutableItems && self.mutableItems.count > 0) {
        [self.mutableItems removeAllObjects];
        self.mutableItems = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MRDismissAlertController object:nil];
}

- (void)dismissAlertController:(NSNotification *)notification {
    
    [self dismissButtonDidTapped:nil];
}

- (void)keyboardShow:(NSNotification *)notification {
    
    self.isKeyboardShown = true;
    [self moveAlertView:notification];
}

- (void)keyboardHide:(NSNotification *)notification {
    
    self.isKeyboardShown = false;
    [self moveAlertView:notification];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    self.isKeyboardShown = true;
    [self moveAlertView:notification];
}

- (void)moveAlertView:(NSNotification *)notification {
    
    if (self.isKeyboardShown) {
        NSDictionary *userInfo = notification.userInfo;
        CGSize size = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        CGRect frame = self.view.bounds;
        CGSize frameSize = frame.size;
        CGFloat newFrameHeight = ((frameSize.height/ 2) - (frameSize.height - size.height) / 2);
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0
                            options:[[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue] << 16
                         animations:^{
                         } completion: ^(BOOL finished) {
                             self.alertViewCenterYConstraint.constant = self.constant - newFrameHeight;
                             [self.alertView layoutIfNeeded];
                         }];
    }
    else {
        NSDictionary *userInfo = notification.userInfo;
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0
                            options:[[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue] << 16
                         animations:^{
                         } completion:^(BOOL finished) {
                             self.alertViewCenterYConstraint.constant = self.constant;
                             [self.alertView layoutIfNeeded];
                         }];
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {

    self.alertViewCenterYConstraint.constant = self.constant;
    [self moveAlertView:notification];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationUnknown:
            
            break;
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            
            break;
        case UIDeviceOrientationFaceUp:
            
            break;
        case UIDeviceOrientationFaceDown:
            
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButtonDidTapped:(UIButton *)sender {
    
    self.isDismissedAction = NO;
    self.alertViewCenterYConstraint.constant = self.constant;
    [self.alertTextField resignFirstResponder];
    
    [self dismissViewControllerAnimated:false completion:^{
        if (self.dismissHandler) {
            self.dismissHandler(self.isDismissedWithAction);
        }
    }];
}

- (void)dealloc {
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return true;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    self.alertViewCenterYConstraint.constant = self.alertViewCenterYConstraint.constant - (self.alertView.frame.size.height / 4);
//    if (IS_IPHONE_5) {
//        self.alertViewCenterYConstraint.constant = self.alertViewCenterYConstraint.constant - (self.alertView.frame.size.height / 4) + 30;
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.alertViewCenterYConstraint.constant = self.constant;
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger textFieldCount = textField.text.length;
    NSUInteger currentString = string.length;
    if (textFieldCount + currentString < TEXTFIELD_LIMIT.integerValue) {
        return true;
    }
    return false;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return @(1).integerValue;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    if ([collectionView isEqual:self.customCollectionView]) {
        if (!self.mutableItems) {
            self.alertCustomCollectionViewHeightConstraint.constant = 0;
            return @(0).integerValue;
        }
        if (self.mutableItems.count == 0) {
            self.alertCustomCollectionViewHeightConstraint.constant = 0;
        }
        NSUInteger rows = self.mutableItems.count;
        return rows;
    }
    if (!self.mutableActions) {
        
        return @(0).integerValue;
    }
    NSUInteger rows = self.mutableActions.count;
    return rows;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:self.customCollectionView]) {
        
        MRAlertItem *item = self.mutableItems[indexPath.row];
        switch (item.style) {
            case MRAlertItemStyleDouble: {
                MRAlertCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MRAlertCustomCollectionViewCell class]) forIndexPath:indexPath];
                cell.titleString = self.mutableItems[indexPath.row].title;
                cell.rewardTitleString = self.mutableItems[indexPath.row].value;
                cell.titleImage = self.mutableItems[indexPath.row].titleImage;
                cell.rewardImage = self.mutableItems[indexPath.row].valueImage;
                return cell;
            }
                break;
            case MRAlertItemStyleSingle: {
                MRAlertSingleItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MRAlertSingleItemCollectionViewCell class]) forIndexPath:indexPath];
                cell.titleString = self.mutableItems[indexPath.row].title;
                cell.titleImage = self.mutableItems[indexPath.row].titleImage;
                return cell;
            }
                break;
            default:
                break;
        }
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MRAlertActionCollectionViewCell class]) forIndexPath:indexPath];
    cell.tag = indexPath.row;
    MRAlertAction *action = self.mutableActions[indexPath.row];
    switch (action.style) {
        case MRAlertActionStyleNone: {
            MRAlertActionCollectionViewCell *cell = (MRAlertActionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MRAlertActionCollectionViewCell class]) forIndexPath:indexPath];
            __weak __typeof(self)weakSelf = self;
            cell.selectHandler = ^(UICollectionViewCell * _Nonnull cell) {
                
                weakSelf.isDismissedAction = YES;
                MRAlertAction *alertAction = weakSelf.mutableActions[cell.tag];
                alertAction.handler(alertAction);
                [weakSelf dismissViewControllerAnimated:false completion:^{
                    if (weakSelf.dismissHandler) {
                        weakSelf.dismissHandler(weakSelf.isDismissedWithAction);
                    }
                }];
            };
            cell.titleString = self.mutableActions[indexPath.row].title;
            return cell;
        }
            break;
        case MRAlertActionStyleHighlightCurve: {
            
            MRAlertCurveActionCollectionViewCell *cell = (MRAlertCurveActionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MRAlertCurveActionCollectionViewCell class]) forIndexPath:indexPath];
            __weak __typeof(self)weakSelf = self;
            cell.selectHandler = ^(UICollectionViewCell * _Nonnull cell) {
                
                MRAlertCurveActionCollectionViewCell *selfCell = (MRAlertCurveActionCollectionViewCell *)cell;
                weakSelf.isDismissedAction = YES;
                MRAlertAction *alertAction = weakSelf.mutableActions[cell.tag];
                alertAction.handler(alertAction);
            };
            cell.titleString = self.mutableActions[indexPath.row].title;
            cell.cellImage = self.mutableActions[indexPath.row].titleImage;
            return cell;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([collectionView isEqual:self.customCollectionView]) {
        
        MRAlertItem *item = self.mutableItems[indexPath.row];
        switch (item.style) {
            case MRAlertItemStyleDouble: {
                
                CGRect rect = self.customView.bounds;
                CGFloat width = rect.size.width;
                NSUInteger rows = self.mutableItems.count;
                self.alertCustomCollectionViewHeightConstraint.constant = (DOUBLE_COLLECTION_HEIGHT.floatValue * (rows)) + (DOUBLE_COLLECTION_HEIGHT.floatValue * (rows - 1));
                return CGSizeMake(width, DOUBLE_COLLECTION_HEIGHT.floatValue);
            }
                break;
            case MRAlertItemStyleSingle: {
                
                CGRect rect = self.customView.bounds;
                CGFloat width = rect.size.width;
                NSUInteger rows = self.mutableItems.count;
                self.alertCustomCollectionViewHeightConstraint.constant = (SINGLE_COLLECTION_HEIGHT.floatValue * (rows));
                return CGSizeMake(width, SINGLE_COLLECTION_HEIGHT.floatValue);
            }
                break;
            default:
                break;
        }
    }
    CGRect rect = collectionView.bounds;
    CGFloat width = rect.size.width;
    NSUInteger rows = self.mutableActions.count;
    MRAlertAction *action = self.mutableActions[indexPath.row];
    switch (action.style) {
        case MRAlertActionStyleNone: {
            if (rows < 2) {
                
                self.alertActionCollectionViewHeightConstraint.constant = COLLECTION_HEIGHT.floatValue;
                return CGSizeMake(width, COLLECTION_HEIGHT.floatValue);
            }
            if (rows > 2) {
                
                self.alertActionCollectionViewHeightConstraint.constant = (COLLECTION_HEIGHT.floatValue * rows) + COLLECTION_HEIGHT.floatValue ;
                return CGSizeMake(width, COLLECTION_HEIGHT.floatValue);
            }
            if (rows < 3) {
                
                self.alertActionCollectionViewHeightConstraint.constant = COLLECTION_HEIGHT.floatValue;
                return CGSizeMake((width/2) - COLLECTION_SPACING.floatValue, COLLECTION_HEIGHT.floatValue);
            }
            return CGSizeMake(width, COLLECTION_HEIGHT.floatValue);
        }
            break;
        case MRAlertActionStyleHighlightCurve: {
            
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.contentInset = UIEdgeInsetsMake(7.5, 0, 7.5, 0);
            self.alertActionCollectionViewHeightConstraint.constant = ACTION_CURVE_COLLECTION_HEIGHT.floatValue * rows + (7.5 * rows + 1);
            return CGSizeMake(width, ACTION_CURVE_COLLECTION_HEIGHT.floatValue);
        }
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if ([collectionView isEqual:self.customCollectionView]) {
        MRAlertItem *item = self.mutableItems[section];
        switch (item.style) {
            case MRAlertItemStyleDouble: {
                if IS_IPHONE_5 {
                    return DOUBLE_COLLECTION_SPACING.floatValue / 4;
                }
                return DOUBLE_COLLECTION_SPACING.floatValue;
            }
                break;
            case MRAlertItemStyleSingle: {
                return COLLECTION_SPACING.floatValue;
            }
                break;
            default:
                break;
        }

        if IS_IPHONE_5 {
            return DOUBLE_COLLECTION_SPACING.floatValue / 4;
        }
        return DOUBLE_COLLECTION_SPACING.floatValue;
    }
    return COLLECTION_SPACING.floatValue;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    if ([collectionView isEqual:self.customCollectionView]) {
        MRAlertItem *item = self.mutableItems[section];
        switch (item.style) {
            case MRAlertItemStyleDouble: {
                return DOUBLE_COLLECTION_SPACING.floatValue * 2;
            }
                break;
            case MRAlertItemStyleSingle: {
                return COLLECTION_SPACING.floatValue;
            }
                break;
            default:
                break;
        }
        return DOUBLE_COLLECTION_SPACING.floatValue * 2;
    }
    return COLLECTION_SPACING.floatValue ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
