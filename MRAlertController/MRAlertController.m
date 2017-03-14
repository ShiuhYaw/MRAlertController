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
#import "MRAlertActionCollectionViewCell.h"
#import "MRAlertCustomCollectionViewCell.h"

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define CUSTOM_COLLECTION_HEIGHT @(40)
#define COLLECTION_HEIGHT @(50)
#define COLLECTION_SPACING @(0.5)

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
    alertAction.handler = self.handler;
    return alertAction;
}

- (NSString *)title {
    
    return self.titleString;
}

- (void)triggerHandler {
    
    self.handler(self);
}

@end

@interface MRAlertItem()

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *valueString;
@property (assign, nonatomic) MRAlertValueStyle valueStyle;

@end

@implementation MRAlertItem

+ (instancetype)actionWithTitle:(NSString *)title value:(NSString *)value style:(MRAlertValueStyle)style {
    
    MRAlertItem *alertItem = [[MRAlertItem alloc] init];
    alertItem.titleString = title;
    alertItem.valueString = value;
    alertItem.valueStyle = style;
    return alertItem;
}

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(MRAlertAction *action))handler {
    
    MRAlertItem *alertAction = [[MRAlertItem alloc] init];
    alertAction.titleString = title;
    return alertAction;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    MRAlertItem *alertAction = [[[self class] allocWithZone:zone] init];
    alertAction.titleString = self.titleString;
    return alertAction;
}

- (NSString *)title {
    
    return self.titleString;
}

- (NSString *)value {
    
    return self.valueString;
}

- (MRAlertValueStyle)style {
    
    return self.valueStyle;
}

@end


typedef void (^ConfigurationHandler)(UITextField *textField);
typedef void (^ImageConfigurationHandler)(UIImageView *imageView);

@interface MRAlertController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) CGFloat constant;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
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

@property (assign, nonatomic) MRAlertControllerStyle style;

#pragma mark -- Alert View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewCenterYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewCenterXContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewTrailingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewWidthConstraint;

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


#pragma mark -- Alert Action Collection View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionCollectionViewHeightConstraint;

#pragma mark -- Alert Custom Collection View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertCustomCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertCustomCollectionViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertCustomCollectionViewBottomConstraint;


@property (strong, nonatomic) NSMutableArray<UITextField *> *mutableTextFields;
@property (strong, nonatomic) NSMutableArray<MRAlertAction *> *mutableActions;
@property (strong, nonatomic) NSMutableArray<MRAlertItem *> *mutableItems;
@property (nonatomic, copy, nullable) ConfigurationHandler configurationHandler;
@property (nonatomic, copy, nullable) ImageConfigurationHandler imageConfigurationHandler;

- (void)configureInterfaceWithStype:(MRAlertControllerStyle)style;

@end

@implementation MRAlertController

@synthesize title;
@synthesize message;
@synthesize textFields;

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(MRAlertControllerStyle)preferredStyle {
    
    MRAlertController *controller = [[MRAlertController alloc]initWithNibName:NSStringFromClass([MRAlertController class]) bundle:[NSBundle mainBundle]];
    controller.title = title;
    controller.message = message;
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
    
    if (!self.mutableItems) {
        self.mutableItems = [NSMutableArray array];
    }
    [self.mutableItems addObject:item];
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

- (void)configureInterfaceWithStype:(MRAlertControllerStyle)style {
    
    self.constant = self.alertViewCenterYConstraint.constant;
    
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
    [self configureInterfaceWithStype:self.preferredStyle];
    [self.actionCollectionView registerNib:[UINib nibWithNibName:@"MRAlertActionCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MRAlertActionCollectionViewCell"];
    [self.customCollectionView registerNib:[UINib nibWithNibName:@"MRAlertCustomCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MRAlertCustomCollectionViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.alertView.layer.cornerRadius = 10.0f;
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;

    if (self.configurationHandler && self.alertTextField) {
        
        [self.mutableTextFields addObject:self.alertTextField];
        self.configurationHandler(self.alertTextField);
    }
    if (self.imageConfigurationHandler && self.imageView) {
        
        self.imageConfigurationHandler(self.imageView);
    }
    if (self.mutableActions && self.mutableActions.count > 0) {
        
        [self.actionCollectionView reloadData];
    }
    if (self.mutableItems && self.mutableItems.count > 0) {
        
        [self.customCollectionView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.mutableTextFields removeAllObjects];
    self.mutableTextFields = nil;
    [self.mutableActions removeAllObjects];
    self.mutableActions = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButtonDidTapped:(UIButton *)sender {
    
    self.alertViewCenterYConstraint.constant = self.constant;
    [self.alertTextField resignFirstResponder];
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.alertViewCenterYConstraint.constant = self.alertViewCenterYConstraint.constant - (self.alertView.frame.size.height / 2);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.alertViewCenterYConstraint.constant = self.constant;
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return true;
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
            self.alertTitleViewImageViewBottomConstraint.constant = 0;
            self.alertCustomCollectionViewHeightConstraint.constant = 0;
            return @(0).integerValue;
        }
        if (self.mutableItems.count == 0) {
            self.alertTitleViewImageViewBottomConstraint.constant = 0;
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
        MRAlertCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MRAlertCustomCollectionViewCell" forIndexPath:indexPath];
        cell.title = self.mutableItems[indexPath.row].title;
        cell.value = self.mutableItems[indexPath.row].value;
        switch (self.mutableItems[indexPath.row].style) {
            case MRAlertValueStyleCoin:
                cell.image = [UIImage imageNamed:@"ic_coinsnum"];
                break;
            case MRAlertValueStyleDiamond:
                cell.image = [UIImage imageNamed:@"ic_diamond"];
                break;
            default:
                break;
        }
        cell.tag = indexPath.row;
        return cell;
    }
    MRAlertActionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MRAlertActionCollectionViewCell" forIndexPath:indexPath];
    cell.selectHandler = ^(UICollectionViewCell * _Nonnull cell) {
        
        MRAlertAction *alertAction = self.mutableActions[cell.tag];
        alertAction.handler(alertAction);
    };
    cell.tag = indexPath.row;
    cell.titleString = self.mutableActions[indexPath.row].title;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([collectionView isEqual:self.customCollectionView]) {
        
        CGRect rect = self.customView.bounds;
        CGFloat width = rect.size.width;
        NSUInteger rows = self.mutableItems.count;
        self.alertCustomCollectionViewHeightConstraint.constant = CUSTOM_COLLECTION_HEIGHT.floatValue * rows;
        return CGSizeMake(width, CUSTOM_COLLECTION_HEIGHT.floatValue);
    }
    CGRect rect = collectionView.bounds;
    CGFloat width = rect.size.width;
    NSUInteger rows = self.mutableActions.count;
    if (rows < 2) {
        
        self.alertActionCollectionViewHeightConstraint.constant = COLLECTION_HEIGHT.floatValue;
        return CGSizeMake(width, COLLECTION_HEIGHT.floatValue);
    }
    if (rows > 2) {
        
        self.alertActionCollectionViewHeightConstraint.constant = COLLECTION_HEIGHT.floatValue * rows;
        return CGSizeMake(width, COLLECTION_HEIGHT.floatValue);
    }
    if (rows < 3) {
        
        self.alertActionCollectionViewHeightConstraint.constant = COLLECTION_HEIGHT.floatValue;
        return CGSizeMake((width/2) - COLLECTION_SPACING.floatValue, COLLECTION_HEIGHT.floatValue);
    }
    return CGSizeMake(width, COLLECTION_HEIGHT.floatValue);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return COLLECTION_SPACING.floatValue;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return COLLECTION_SPACING.floatValue;
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
