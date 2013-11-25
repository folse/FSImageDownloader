//
//  Shot.h
//  FSImageDownloader
//
//  Created by folse on 11/25/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shot : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *url;

- (id)initWithData:(NSDictionary *)data;

@end
