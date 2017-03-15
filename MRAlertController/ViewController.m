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
    MRAlertController *alertController = [MRAlertController alertWithTitle:@"Write something to invite your fans \n to watch this live"
                                                                   message:@""
                                                            preferredStyle:MRAlertControllerStyleAlertImageTextField];
    
    MRAlertAction *cancelAction = [MRAlertAction actionWithTitle:@"Claim" handler:^(MRAlertAction * _Nonnull action) {
        if (action) {
            NSLog(@"Cancel Actiion");
        }
    }];
    [alertController addAction:cancelAction];

    MRAlertAction *sendAction = [MRAlertAction actionWithTitle:@"My Level" handler:^(MRAlertAction * _Nonnull action) {
        if (action) {
            UITextField *customizedMsgLabel = alertController.textFields.firstObject;
            NSLog(@"customizedMsgLabel: %@", customizedMsgLabel.text);
        }
    }];
    [alertController addAction:sendAction];
    
    MRAlertItem *diamondTitle = [MRAlertItem actionWithTitle:@"DJ" value:@"10" style:MRAlertValueStyleDiamond];
    [alertController addItem:diamondTitle];
    
    MRAlertItem *coinTitle = [MRAlertItem actionWithTitle:@"Looper" value:@"100" style:MRAlertValueStyleCoin];
    [alertController addItem:coinTitle];
    
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
    
    [self presentViewController:alertController animated:false completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
