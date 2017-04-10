//
//  MRAlertCurveActionCollectionViewCell.h
//  MRAlertController
//
//  Created by Yaw on 7/4/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectHandler)(UICollectionViewCell *cell);

@interface MRAlertCurveActionCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) id cellImage;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, copy, nullable) SelectHandler selectHandler;
@end
NS_ASSUME_NONNULL_END
