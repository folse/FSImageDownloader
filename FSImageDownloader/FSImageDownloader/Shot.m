//
//  Shot.m
//  FSImageDownloader
//
//  Created by folse on 11/25/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import "Shot.h"

@implementation Shot

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        
        self.title = [data valueForKey:@"title"];
        self.url = [data valueForKey:@"image_url"];
    }
    return self;
}


@end
