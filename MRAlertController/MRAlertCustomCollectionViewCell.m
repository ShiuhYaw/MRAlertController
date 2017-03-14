//
//  MRAlertCustomCollectionViewCell.m
//  MRAlertController
//
//  Created by Yaw on 14/3/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import "MRAlertCustomCollectionViewCell.h"

@interface MRAlertCustomCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *styleImageView;

@end

@implementation MRAlertCustomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

- (void)setValue:(NSString *)value {
    
    self.valueLabel.text = value;
}

- (void)setImage:(UIImage *)image {
    
    self.styleImageView.image = image;
}

@end
