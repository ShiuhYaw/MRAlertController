//
//  MRAlertSingleItemCollectionViewCell.m
//  MRAlertController
//
//  Created by Yaw on 7/4/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import "MRAlertSingleItemCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImage+MultiFormat.h>

@interface MRAlertSingleItemCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MRAlertSingleItemCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.activityIndicatorView startAnimating];
}

- (void)setTitleString:(NSString *)titleString {
    
    self.itemTitleLabel.text = titleString;
}

- (void)setTitleImage:(id)titleImage {
    
    if ([titleImage isKindOfClass:[UIImage class]]) {
        
        self.itemImageView.image = titleImage;
        [self.activityIndicatorView stopAnimating];
    }
    if ([titleImage isKindOfClass:[NSString class]]) {
        
        __weak typeof(self) weak = self;
        [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:titleImage] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage * image, NSError * error,SDImageCacheType cachedType, NSURL * imageURL){
            if(image){
                [weak.activityIndicatorView stopAnimating];
            }
        }];
    }
    if ([titleImage isKindOfClass:[NSURL class]]) {
        
        __weak typeof(self) weak = self;
        [self.itemImageView sd_setImageWithURL:titleImage placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage * image, NSError * error,SDImageCacheType cachedType, NSURL * imageURL){
            if(image){
                [weak.activityIndicatorView stopAnimating];
            }
        }];
    }
    if ([titleImage isKindOfClass:[NSData class]]) {
        
        self.itemImageView.image = [UIImage imageWithData:titleImage];
        [self.activityIndicatorView stopAnimating];
    }
}

@end
