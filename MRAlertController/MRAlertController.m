//
//  MRAlertController.m
//  Loops
//
//  Created by Yaw on 8/3/17.
//  Copyright © 2017 Mozat. All rights reserved.
//

#import "MRAlertController.h"
#import "UIColor+Hex.h"
#import "UIButton+Style.h"


#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

typedef void (^Handler)(MRAlertAction *action);

@interface MRAlertAction()

@property (strong, nonatomic) NSString *titleString;
@property (nonatomic, copy, nullable) Handler handler;

@end

@implementation MRAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(MRAlertAction *action))handler {
    
    MRAlertAction *alertAction = [[MRAlertAction alloc] init];
    alertAction.titleString = title;
    alertAction.handler = handler;
    return alertAction;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    MRAlertAction *alertAction = [[[self class] allocWithZone:zone] init];
    alertAction.titleString = self.titleString;
    return alertAction;
}

- (NSString *)title {
    
    return self.titleString;
}

- (void)triggerHandler {
    
    self.handler(self);
}

@end

typedef void (^ConfigurationHandler)(UITextField *textField);
typedef void (^ImageConfigurationHandler)(UIImageView *imageView);

@interface MRAlertController () <UITextFieldDelegate>

@property (assign, nonatomic) CGFloat constant;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *imageSuperview;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *alertTextView;
@property (weak, nonatomic) IBOutlet UITextField *alertTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *buttonSeparatorView;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UIView *cancelView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelBottonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSuperViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *singleButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multipleButtonLeadingConstraint;

@property (assign, nonatomic) MRAlertControllerStyle style;
@property (strong, nonatomic) NSMutableArray<UITextField *> *mutableTextFields;
@property (strong, nonatomic) NSMutableArray<UIAlertAction *> *mutableActions;
@property (nonatomic, copy, nullable) ConfigurationHandler configurationHandler;
@property (nonatomic, copy, nullable) ImageConfigurationHandler imageConfigurationHandler;


- (void)configureInterfaceWithStype:(MRAlertControllerStyle)style;
@end

@implementation MRAlertController

@synthesize title;
@synthesize message;
@synthesize textFields;

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(MRAlertControllerStyle)preferredStyle {
    
    MRAlertController *controller = [[MRAlertController alloc]initWithNibName:@"MRAlertController" bundle:[NSBundle mainBundle]];
    controller.title = title;
    controller.message = message;
    controller.style = preferredStyle;
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.view.backgroundColor = [UIColor clearColor];
    return controller;
}

- (void)addAction:(UIAlertAction *)action {
    
    if (!self.mutableActions) {
        self.mutableActions = [NSMutableArray array];
    }
    [self.mutableActions addObject:action];
}


- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler {
    
    if (self.style == MRAlertControllerStyleAlert || self.style == MRAlertControllerStyleAlertImage) {
        
        configurationHandler(nil);
        return;
    }
    if (!self.mutableTextFields) {
        
        self.mutableTextFields = [NSMutableArray array];
    }
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

- (void)configureInterfaceWithStype:(MRAlertControllerStyle)style {
    
    
    self.constant = self.centerYConstraint.constant;
    self.alertView.layer.cornerRadius = 10.0f;
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;

    switch (self.preferredStyle) {
        case MRAlertControllerStyleAlert:
            self.alertTextView.hidden = true;
            [self.alertTextView removeConstraints:self.alertTextView.constraints];
            self.imageSuperview.hidden = true;
            [self.imageSuperview removeConstraints:self.imageSuperview.constraints];
            self.imageView.hidden = true;
            [self.imageView removeConstraints:self.imageView.constraints];
            self.textFieldViewBottomConstraint.constant = 0;
            self.titleViewBottomConstraint.active = true;
            self.messageLabelBottonConstraint.active = true;
            break;
        case MRAlertControllerStyleAlertImage:
            self.alertTextView.hidden = true;
            [self.alertTextView removeConstraints:self.alertTextView.constraints];
            self.imageSuperview.hidden = false;
            self.textFieldViewBottomConstraint.constant = 0;
            self.textFieldHeightConstraint.priority = 250;
            self.titleViewBottomConstraint.active = false;
            self.messageLabelBottonConstraint.active = false;
            if (title.length < 1) {
                self.imageSuperViewTopConstraint.constant = 0.0f;
            }
            if (self.message.length < 1) {
                self.textFieldViewTopConstraint.constant = 0.0f;
                self.messageLabelTopConstraint.constant = 24.0f;
            }
            break;
        case MRAlertControllerStyleAlertImageTextField:
            self.alertTextView.hidden = false;
            self.imageSuperview.hidden = false;
            self.textFieldViewBottomConstraint.constant = 24.5;
            self.textFieldHeightConstraint.constant = 40.0;
            self.titleViewBottomConstraint.active = false;
            self.alertTextView.layer.borderWidth = 0.5f;
            self.alertTextView.layer.borderColor = [UIColor colorWithRed:(226/255.0f) green:(226/255.0f) blue:(226/255.0f) alpha:1.0f].CGColor;
            self.alertTextField.textColor = [UIColor colorWithHexString:@"#2c2c30"];
            self.messageLabelBottonConstraint.active = false;
            if (self.message.length < 1) {
                self.textFieldViewTopConstraint.constant = 0.0f;
                self.messageLabelTopConstraint.constant = 24.0f;
            }
            if (title.length < 1) {
                self.imageSuperViewTopConstraint.constant = 0.0f;
            }
            break;
        case MRAlertControllerStyleAlertTextField:
            self.alertTextView.hidden = false;
            self.imageSuperview.hidden = true;
            [self.imageSuperview removeConstraints:self.imageSuperview.constraints];
            
            self.textFieldViewBottomConstraint.constant = 24.5;
            self.textFieldHeightConstraint.constant = 40.0;
            self.titleViewBottomConstraint.active = true;
            self.alertTextView.layer.borderWidth = 0.5f;
            self.alertTextView.layer.borderColor = [UIColor colorWithRed:(226/255.0f) green:(226/255.0f) blue:(226/255.0f) alpha:1.0f].CGColor;
            self.alertTextField.textColor = [UIColor colorWithHexString:@"#2c2c30"];
            self.messageLabelBottonConstraint.active = false;
            if (self.message.length < 1) {
                self.textFieldViewTopConstraint.constant = 0.0f;
                self.messageLabelTopConstraint.constant = 24.0f;
            }
            break;
        default:
            break;
    }
    if (self.mutableActions && self.mutableActions.count > 0) {
        if (self.mutableActions.count > 1) {
            [self.cancelButton setTitle:((MRAlertAction *)self.mutableActions[1]).title forState:UIControlStateNormal];
            [self.cancelButton setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"] forState:UIControlStateHighlighted];
        }
        [self.sendButton setTitle:((MRAlertAction *)self.mutableActions[0]).title forState:UIControlStateNormal];
        [self.sendButton setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"] forState:UIControlStateHighlighted];
        if (self.mutableActions.count < 2) {
            
            self.singleButtonLeadingConstraint.priority = 999;
        }
    }
    if IS_IPHONE_5 {
        self.alertViewLeadingConstraint.priority = 999;
        self.alertViewTrailingConstraint.priority = 999;
        self.alertViewWidthConstraint.priority = 750;
    }
    else {
        self.alertViewLeadingConstraint.priority = 750;
        self.alertViewTrailingConstraint.priority = 750;
        self.alertViewWidthConstraint.priority = 999;
    }
}

- (MRAlertControllerStyle)preferredStyle {
    
    return self.style;
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
    [self configureInterfaceWithStype:self.style];
    if (self.configurationHandler) {
        
        if (self.alertTextField) {
            
            [self.mutableTextFields addObject:self.alertTextField];
        }
        self.configurationHandler(self.alertTextField);
    }
    if (self.imageConfigurationHandler) {
        
        self.imageConfigurationHandler(self.imageView);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonDidTapped:(UIButton *)sender {
    
    if (self.mutableActions && self.mutableActions.count > 1) {
        MRAlertAction *action = (MRAlertAction *)self.mutableActions[1];
        [action triggerHandler];
        [self dismissViewControllerAnimated:false completion:^{
            
        }];
    }
}

- (IBAction)sendButtonDidTapped:(UIButton *)sender {
    
    if (self.mutableActions && self.mutableActions.count > 0) {
        MRAlertAction *action = (MRAlertAction *)self.mutableActions[0];
        [action triggerHandler];
        [self dismissViewControllerAnimated:false completion:^{
            
        }];
    }
}

- (IBAction)dismissButtonDidTapped:(UIButton *)sender {
    
    self.centerYConstraint.constant = self.constant;
    [self.alertTextField resignFirstResponder];
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.centerYConstraint.constant = self.centerYConstraint.constant - (self.alertView.frame.size.height / 2);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.centerYConstraint.constant = self.constant;
    [textField resignFirstResponder];
    if (self.mutableActions && self.mutableActions.count > 0) {
        MRAlertAction *action = (MRAlertAction *)self.mutableActions[0];
        [action triggerHandler];
    }
    return false;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return true;
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
