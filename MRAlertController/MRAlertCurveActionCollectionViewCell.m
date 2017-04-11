//
//  MRAlertCurveActionCollectionViewCell.m
//  MRAlertController
//
//  Created by Yaw on 7/4/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import "MRAlertCurveActionCollectionViewCell.h"
#import <pop/POP.h>
#import <BEMCheckBox/BEMCheckBox.h>

@interface MRAlertCurveActionCollectionViewCell() <BEMCheckBoxDelegate>

@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet BEMCheckBox *cellAccessoryView;
@property (nonatomic, assign) BOOL isCellSelected;
@property (nonatomic, assign) BOOL isInitialize;

@end

@implementation MRAlertCurveActionCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.isInitialize = YES;
    self.isCellSelected = NO;
    [self toggleSelection: self.isCellSelected];
    self.cellBackgroundView.layer.cornerRadius = self.cellBackgroundView.frame.size.height / 2;
    self.cellAccessoryView.boxType = BEMBoxTypeSquare;
    self.cellAccessoryView.onAnimationType = BEMAnimationTypeStroke;
    self.cellAccessoryView.onCheckColor = [UIColor whiteColor];
}

- (IBAction)selectButtonDidTapped:(UIButton *)sender {
    
    self.isCellSelected = !self.isCellSelected;
    [self toggleSelection:self.isCellSelected];
}

- (void)setCellImage:(id)cellImage {
    
    self.cellImageView.image = cellImage;
}

- (void)setTitleString:(NSString *)titleString {
    
    self.cellTitleLabel.text = titleString;
}

- (void)toggleSelection:(BOOL)status {
    
    [self.cellAccessoryView setOn:status animated:YES];
    
    if (status) {

        self.cellBackgroundView.backgroundColor = [UIColor colorWithRed:(236/255.0f)
                                                                  green:(44/255.0f)
                                                                   blue:(122/255.0f)
                                                                  alpha:1.0f];
        self.cellBackgroundView.layer.borderColor = [UIColor colorWithRed:(236/255.0f)
                                                                    green:(44/255.0f)
                                                                     blue:(122/255.0f)
                                                                    alpha:1.0f].CGColor;
        self.cellBackgroundView.layer.borderWidth = 0.0;
        self.cellTitleLabel.textColor = [UIColor whiteColor];
        self.cellImageView.tintColor = [UIColor whiteColor];
    }
    else {
        
        double delayInSeconds = 0.5;
        if (self.isInitialize) {
            self.isInitialize = NO;
            delayInSeconds = 0.0;
        }
        [UIView animateWithDuration:delayInSeconds animations:^{
            self.cellBackgroundView.backgroundColor = [UIColor whiteColor];
            self.cellBackgroundView.layer.borderColor = [UIColor colorWithRed:(229/255.0f)
                                                                        green:(229/255.0f)
                                                                         blue:(229/255.0f)
                                                                        alpha:1.0f].CGColor;
            self.cellBackgroundView.layer.borderWidth = 0.5;
            self.cellTitleLabel.textColor = [UIColor colorWithRed:(113/255.0f)
                                                            green:(113/255.0f)
                                                             blue:(113/255.0f)
                                                            alpha:1.0f];
            self.cellImageView.tintColor = [UIColor colorWithRed:(236/255.0f)
                                                           green:(44/255.0f)
                                                            blue:(122/255.0f)
                                                           alpha:1.0f];
        }];
    }
}

#pragma mark - BEMCheckBoxDelegate

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    
}

@end
