//
//  MRAlertCustomCollectionViewCell.m
//  MRAlertController
//
//  Created by Yaw on 14/3/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import "MRAlertCustomCollectionViewCell.h"

@interface MRAlertCustomCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewardTitleLabel;

@end

@implementation MRAlertCustomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
