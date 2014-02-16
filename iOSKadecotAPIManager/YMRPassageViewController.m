//
//  YMRPassageViewController.m
//  iOSKadecotAPIManager
//
//  Created by yumu on 2014/02/16.
//  Copyright (c) 2014年 yumulab. All rights reserved.
//

#import "YMRPassageViewController.h"
#import "YMRiOSKadecotAPIManeger.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"

@interface YMRPassageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *light1OnButton;
@property (weak, nonatomic) IBOutlet UIButton *light2Offbutton;
@property (weak, nonatomic) IBOutlet UIButton *light2OnButton;
@property (weak, nonatomic) IBOutlet UIButton *light2OffButton;
@property (weak, nonatomic) IBOutlet UIButton *light3OnButton;
@property (weak, nonatomic) IBOutlet UIButton *light3OffButton;
@property (weak, nonatomic) IBOutlet UIButton *light4OnButton;
@property (weak, nonatomic) IBOutlet UIButton *light4OffButton;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) NSUUID *proximityUUID;
@property (nonatomic) CLBeaconRegion *beaconRegion;

@end

@implementation YMRPassageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
            self.locationManager = [CLLocationManager new];
            self.locationManager.delegate = self;
            
            self.proximityUUID = [[NSUUID alloc] initWithUUIDString:UUID];
            
            self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                                   identifier:@"org.yumulab.riceCooker"];
            [self.locationManager startMonitoringForRegion:self.beaconRegion];
            [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
        }
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    // ローカル通知
    //[self sendLocalNotificationForMessage:@"Enter Region"];
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"" message:@"Enter Region"
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    
    // Beaconの距離測定を開始する
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    // ローカル通知
    //[self sendLocalNotificationForMessage:@"Exit Region"];
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"" message:@"Exit Region"
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    // Beaconの距離測定を終了する
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        // 最も距離の近いBeaconについて処理する
        CLBeacon *nearestBeacon = beacons.firstObject;
        
        NSString *rangeMessage;
        
        NSString *message = [NSString stringWithFormat:@"major:%@, minor:%@, accuracy:%f, rssi:%ld",
                             nearestBeacon.major, nearestBeacon.minor, nearestBeacon.accuracy, nearestBeacon.rssi];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"" message:message
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"kitchenView"];
        
        // Beacon の距離でメッセージを変える
        switch (nearestBeacon.proximity) {
            case CLProximityImmediate:
                rangeMessage = @"Range Immediate: ";
                [self presentViewController:nc animated:YES completion:nil];
                break;
            case CLProximityNear:
                rangeMessage = @"Range Near: ";
                break;
            case CLProximityFar:
                rangeMessage = @"Range Far: ";
                break;
            default:
                rangeMessage = @"Range Unknown: ";
                break;
        }
        
        // ローカル通知
        
        //        [self sendLocalNotificationForMessage:[rangeMessage stringByAppendingString:message]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.locationManager requestStateForRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside: // リージョン内にいる
            if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
                [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
            }
            break;
        case CLRegionStateOutside:
        case CLRegionStateUnknown:
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapLight1OnButton:(id)sender {
     [YMRiOSKadecotAPIManeger setDevice:@"GeneralLighting" EPC:@"0x80" property:@"0x30"];
}
- (IBAction)didTapLight1OffButton:(id)sender {
        [YMRiOSKadecotAPIManeger setDevice:@"GeneralLighting" EPC:@"0x80" property:@"0x31"];
}
- (IBAction)didTapLight2OnButton:(id)sender {
     [YMRiOSKadecotAPIManeger setDevice:@"GeneralLighting2" EPC:@"0x80" property:@"0x30"];
}

- (IBAction)didTapLight2OffButton:(id)sender {
     [YMRiOSKadecotAPIManeger setDevice:@"GeneralLighting2" EPC:@"0x80" property:@"0x31"];
}

- (IBAction)didTapLight3OnButton:(id)sender {
     [YMRiOSKadecotAPIManeger setDevice:@"GeneralLighting3" EPC:@"0x80" property:@"0x30"];
}

- (IBAction)didTapLight3OffButton:(id)sender {
     [YMRiOSKadecotAPIManeger setDevice:@"GeneralLighting3" EPC:@"0x80" property:@"0x31"];
}

- (IBAction)didTapLight4OnButton:(id)sender {
     [YMRiOSKadecotAPIManeger setDevice:@"GeneralLighting4" EPC:@"0x80" property:@"0x30"];
}

- (IBAction)didTapLight4OffButton:(id)sender {
     [YMRiOSKadecotAPIManeger setDevice:@"GeneralLighting4" EPC:@"0x80" property:@"0x31"];
}
- (IBAction)didTapChangeButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"kitchenView"];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
