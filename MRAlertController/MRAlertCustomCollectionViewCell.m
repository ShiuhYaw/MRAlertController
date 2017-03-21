//
//  MRAlertCustomCollectionViewCell.m
//  MRAlertController
//
//  Created by Yaw on 14/3/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import "MRAlertCustomCollectionViewCell.h"
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

@interface MRAlertCustomCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewardTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewValueViewTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueTitleWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueTitleLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadingConstraint;

@end

@implementation MRAlertCustomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if IS_IPHONE_5 {
        self.titleViewValueViewTrailing.constant = self.titleViewValueViewTrailing.constant / 4;
        self.titleViewWidthConstraint.constant = self.titleViewWidthConstraint.constant - 10;
        self.rewardViewWidthConstraint.constant = self.rewardViewWidthConstraint.constant - 10;
    }
    self.titleView.layer.cornerRadius = 5;
    self.titleView.layer.borderWidth = 0.5;
    self.titleView.layer.borderColor = [UIColor colorWithRed:(229/255.0f) green:(229/255.0f) blue:(229/255.0f) alpha:1.0f].CGColor;
    self.rewardView.layer.cornerRadius = 5;
    self.rewardView.layer.borderWidth = 0.5;
    self.rewardView.layer.borderColor = [UIColor colorWithRed:(229/255.0f) green:(229/255.0f) blue:(229/255.0f) alpha:1.0f].CGColor;
}

- (void)setTitleString:(NSString *)titleString {
 
    self.titleLabel.text = titleString;
}

- (void)setTitleImage:(UIImage *)titleImage {
    
    self.titleImageView.image = titleImage;
}

- (void)setRewardTitleString:(NSString *)rewardTitleString {
    
    self.rewardTitleLabel.text = rewardTitleString;
}

- (void)setRewardImage:(UIImage *)rewardImage {
    
    self.rewardImageView.image = rewardImage;
}
@end
