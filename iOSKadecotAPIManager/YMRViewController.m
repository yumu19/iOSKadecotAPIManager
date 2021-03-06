//
//  YMRViewController.m
//  iOSKadecotAPIManager
//
//  Created by yumu on 2014/02/15.
//  Copyright (c) 2014年 yumulab. All rights reserved.
//

#import "YMRViewController.h"
#import "YMRiOSKadecotAPIManeger.h"
#import "YMRiBeaconManager.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"

@interface YMRViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cookRiceButton;
@property (weak, nonatomic) IBOutlet UIButton *washButton;
@property (weak, nonatomic) IBOutlet UIButton *localPushButton;
@property (weak, nonatomic) IBOutlet UIButton *lightOnButton;
@property (weak, nonatomic) IBOutlet UIButton *lightOffButton;
@property (weak, nonatomic) IBOutlet UIButton *microwaveStartButton;

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) NSUUID *proximityUUID;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@end

@implementation YMRViewController {
    YMRiBeaconManager* _iBeaconManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //_iBeaconManager = [[YMRiBeaconManager alloc] init];
    
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

- (IBAction)didTapCookRiceButton:(id)sender {
    [YMRiOSKadecotAPIManeger setDevice:@"RiceCooker" EPC:@"0xB2" property:@"0x41"];
}

- (IBAction)didTapMicrowaveStartButton:(id)sender {
    [YMRiOSKadecotAPIManeger setDevice:@"CombinationMicrowaveOven" EPC:@"0xB2" property:@"0x41"];    
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
- (IBAction)didTapLocalPushButton:(id)sender {
    [self sendLocalNotificationForMessage:@"test"];
}

- (void)sendLocalNotificationForMessage:(NSString *)message
{
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.alertBody = message;
    localNotification.fireDate = [NSDate date];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
        UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"passageView"];
        
        // Beacon の距離でメッセージを変える
        switch (nearestBeacon.proximity) {
            case CLProximityImmediate:
                rangeMessage = @"Range Immediate: ";
                break;
            case CLProximityNear:
                rangeMessage = @"Range Near: ";
                [self presentViewController:nc animated:YES completion:nil];
                break;
            case CLProximityFar:
                rangeMessage = @"Range Far: ";
                [self presentViewController:nc animated:YES completion:nil];
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
- (IBAction)didTapChangeButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"passageView"];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
