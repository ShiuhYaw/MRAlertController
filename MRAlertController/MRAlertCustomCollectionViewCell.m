//
//  MRAlertCustomCollectionViewCell.m
//  MRAlertController
//
//  Created by Yaw on 14/3/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import "MRAlertCustomCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImage+MultiFormat.h>

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

@interface MRAlertCustomCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewardTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *rewardActivityIndicatorView;

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
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.activityIndicatorView startAnimating];
    self.rewardActivityIndicatorView.hidesWhenStopped = YES;
    [self.rewardActivityIndicatorView startAnimating];

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

- (void)setTitleImage:(id)titleImage {
    
    if ([titleImage isKindOfClass:[UIImage class]]) {
        self.titleImageView.image = titleImage;
        [self.activityIndicatorView stopAnimating];
    }
    if ([titleImage isKindOfClass:[NSString class]]) {
        UIImageView * thumbnail = [[UIImageView alloc] init];
        [thumbnail sd_setImageWithURL:[NSURL URLWithString:titleImage] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage * image, NSError * error,SDImageCacheType cachedType, NSURL * imageURL){
            if(image){
                self.titleImageView.image = image;
                [self.titleImageView reloadInputViews];
                [self.activityIndicatorView stopAnimating];
            }
        }];
    }
    if ([titleImage isKindOfClass:[NSURL class]]) {
        UIImageView * thumbnail = [[UIImageView alloc] init];
        [thumbnail sd_setImageWithURL:titleImage placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage * image, NSError * error,SDImageCacheType cachedType, NSURL * imageURL){
            if(image){
                [thumbnail setImage:image];
                self.titleImageView.image = image;
                [self.titleImageView reloadInputViews];
                [self.activityIndicatorView stopAnimating];
            }
        }];
    }
    if ([titleImage isKindOfClass:[NSData class]]) {
        self.titleImageView.image = [UIImage imageWithData:titleImage];
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)setRewardTitleString:(NSString *)rewardTitleString {
    
    self.rewardTitleLabel.text = rewardTitleString;
}

- (void)setRewardImage:(id)rewardImage {
    
    if ([rewardImage isKindOfClass:[UIImage class]]) {
        self.rewardImageView.image = rewardImage;
        [self.rewardActivityIndicatorView stopAnimating];
    }
    if ([rewardImage isKindOfClass:[NSString class]]) {
        UIImageView * thumbnail = [[UIImageView alloc] init];
        [thumbnail sd_setImageWithURL:[NSURL URLWithString:rewardImage] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage * image, NSError * error,SDImageCacheType cachedType, NSURL * imageURL){
            if(image){
                self.rewardImageView.image = image;
                [self.rewardImageView reloadInputViews];
                [self.rewardActivityIndicatorView stopAnimating];
            }
        }];
    }
    if ([rewardImage isKindOfClass:[NSURL class]]) {
        UIImageView * thumbnail = [[UIImageView alloc] init];
        [thumbnail sd_setImageWithURL:rewardImage placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage * image, NSError * error,SDImageCacheType cachedType, NSURL * imageURL){
            if(image){
                [thumbnail setImage:image];
                self.rewardImageView.image = image;
                [self.rewardImageView reloadInputViews];
                [self.rewardActivityIndicatorView stopAnimating];
            }
        }];
    }
    if ([rewardImage isKindOfClass:[NSData class]]) {
        self.rewardImageView.image = [UIImage imageWithData:rewardImage];
        [self.rewardActivityIndicatorView stopAnimating];
    }
}

- (void)dealloc {
    
    if (self.titleImage) {
        self.titleImage = nil;
    }
    if (self.rewardImage) {
        self.rewardImage = nil;
    }
}
@end
