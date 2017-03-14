//
//  MRAlertActionCollectionViewCell.h
//  MRAlertController
//
//  Created by Yaw on 14/3/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectHandler)(UICollectionViewCell *cell);

@interface MRAlertActionCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *titleString;
@property (nonatomic, copy, nullable) SelectHandler selectHandler;

@end
NS_ASSUME_NONNULL_END
