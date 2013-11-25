//
//  F.h
//  Folse Kit
//
//  Created by Folse on 5/11/13.
//  Copyright (c) 2013 Folse. All rights reserved.
//

#define s(content) NSLog(@"%@", content);
#define i(content) NSLog(@"%d", content);
#define f(content) NSLog(@"%f", content);

#define USER [NSUserDefaults standardUserDefaults]
#define USER_ID [USER valueForKey:@"userId"]
#define USER_NAME [USER valueForKey:@"userName"]
#define USER_LOGIN [USER boolForKey:@"userLogined"]
#define F_COLOR [UIColor colorWithRed:253.0/255.0 green:119.0/255.0 blue:142.0/255.0 alpha:1.0] 

#define FIRST_LOAD [USER boolForKey:@"isFirstLoad"]
#define PAGE_ID [USER valueForKey:@"pageId"]

#define e(content) [MobClick event:content];

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define TEST FALSE

#if TEST
#define API_BASE_URL @"http://dev.dribbble.com"
#else
#define API_BASE_URL @"http://api.dribbble.com"
#endif

@interface F : NSObject

-(NSString *)MD5:(NSString *)text;

-(NSString *)getMD5FilePathWithUrl:(NSString *)url;

@end
