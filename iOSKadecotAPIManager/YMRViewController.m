//
//  YMRViewController.m
//  iOSKadecotAPIManager
//
//  Created by yumu on 2014/02/15.
//  Copyright (c) 2014年 yumulab. All rights reserved.
//

#import "YMRViewController.h"

@interface YMRViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cookRiceButton;
@property (weak, nonatomic) IBOutlet UIButton *washButton;

@end

@implementation YMRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)didTapCookRiceButton:(id)sender {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"" message:@"Cook Rice"
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)didTapWashButton:(id)sender {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"" message:@"Wash"
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
