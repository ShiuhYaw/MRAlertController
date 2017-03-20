//
//  MRAlertCustomCollectionViewCell.h
//  MRAlertController
//
//  Created by Yaw on 14/3/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRAlertCustomCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *titleString;
@property (assign, nonatomic) UIImage *titleImage;

@property (strong, nonatomic) NSString *rewardTitleString;
@property (strong, nonatomic) UIImage *rewardImage;

@end
