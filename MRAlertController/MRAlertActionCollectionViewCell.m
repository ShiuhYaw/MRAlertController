//
//  MRAlertActionCollectionViewCell.m
//  MRAlertController
//
//  Created by Yaw on 14/3/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import "MRAlertActionCollectionViewCell.h"
#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#import "UIButton+Style.h"

@interface MRAlertActionCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end


@implementation MRAlertActionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleButton setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"] forState:UIControlStateHighlighted];
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setTitleString:(NSString *)titleString {

    [self.titleButton setTitle:titleString forState:UIControlStateNormal];
}

- (IBAction)cellButtonDidTapped:(UIButton *)sender {
    
    if (self.selectHandler) {
        self.selectHandler(self);
    }
}

@end
