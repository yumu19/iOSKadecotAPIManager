//
//  YMRiOSKadecotAPIManeger.m
//  iOSKadecotAPIManager
//
//  Created by yumu on 2014/02/15.
//  Copyright (c) 2014年 yumulab. All rights reserved.
//

#import "YMRiOSKadecotAPIManeger.h"
#import "AFHTTPRequestOperationManager.h"

#define KADECOT_SERVER_URL @"http://192.168.1.142:31413/call.json"

@implementation YMRiOSKadecotAPIManeger


+(void)setDevice:(NSString*)nickname EPC:(NSString*)EPC property:(NSString*)property{
    NSString* method = @"set";
    NSString* params = [NSString stringWithFormat:@"[%@,[%@,[%@]]]",nickname,EPC,property];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"method": method,
                             @"params": params,
                             @"jsoncallback":@"cb"};
    [manager GET:KADECOT_SERVER_URL
      parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"response: %@", responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
};

@end
