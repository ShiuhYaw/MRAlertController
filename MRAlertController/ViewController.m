//
//  ViewController.m
//  MRAlertController
//
//  Created by Yaw on 9/3/17.
//  Copyright © 2017 Yaw. All rights reserved.
//

#import "ViewController.h"
#import "MRAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}
- (IBAction)alertDidTapped:(UIButton *)sender {
    
    [self alert];
}

- (void)alert {
    
    MRAlertController *alertController = [MRAlertController alertWithTitle:@"Please allow below permissions to use Loops"
                                                                   message:@""
                                                               actionTitle:@"We need few things to start your Live broadcast"
                                                            preferredStyle:MRAlertControllerStyleAlertCustom
                                                            dismissHandler:^(BOOL isDismissedWithAction) {
                                                                NSLog(@"isDismissedWithAction %@", @(isDismissedWithAction));
                                                            }];
    /*
    MRAlertAction *cancelAction = [MRAlertAction actionWithTitle:@"OK" handler:^(MRAlertAction * _Nonnull action) {
        if (action) {
            NSLog(@"%@ Action", action.title);
        }
    }];
    [alertController addAction:cancelAction];
    */
    
    MRAlertAction *cameraAction = [MRAlertAction actionWithTitle:@"Enable Camera" titleImage:[UIImage imageNamed:@"icEIcEnableCameraBlack"] style:MRAlertActionStyleHighlightCurve handler:^(MRAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cameraAction];
    
    MRAlertAction *microphoneAction = [MRAlertAction actionWithTitle:@"Enable Microphone" titleImage:[UIImage imageNamed:@"icEnableMicrophoneBlack"] style:MRAlertActionStyleHighlightCurve handler:^(MRAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:microphoneAction];
    
    MRAlertItem *notificationItem = [MRAlertItem actionWithTitle:@"Enable Notification to receive hosts updates" titleImage:[UIImage imageNamed:@"icEnableNotification"] style:MRAlertItemStyleSingle];
    [alertController addItem:notificationItem];

    MRAlertItem *locationItem = [MRAlertItem actionWithTitle:@"Enable Location to locate Live Stream" titleImage:[UIImage imageNamed:@"icEnableLocation"] style:MRAlertItemStyleSingle];
    [alertController addItem:locationItem];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (textField) {
            textField.placeholder = @"Something cool!";
        }
    }];
    
    [alertController addImageViewWithConfigurationHandler:^(UIImageView * _Nonnull imageView) {
        if (imageView) {
            imageView.image = [UIImage imageNamed:@"icPrivilege"];
        }
    }];
    
    [alertController addTitleImageViewWithConfigurationHandler:^(UIImageView * _Nonnull imageView) {
        
        if (imageView) {
            imageView.image = [UIImage imageNamed:@"icStartlive"];
        }
    }];
    [self presentViewController:alertController animated:false completion:^{
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
