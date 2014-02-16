//
//  YMRiBeaconManager.m
//  iOSKadecotAPIManager
//
//  Created by yumu on 2014/02/15.
//  Copyright (c) 2014年 yumulab. All rights reserved.
//

#import "YMRiBeaconManager.h"
#import <CoreLocation/CoreLocation.h>


@interface YMRiBeaconManager () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) NSUUID *proximityUUID;
@property (nonatomic) CLBeaconRegion *beaconRegion;

@end

@implementation YMRiBeaconManager



-(id)init {
    self = [super init];
    if (self) {

    }
    return self;
}




@end
