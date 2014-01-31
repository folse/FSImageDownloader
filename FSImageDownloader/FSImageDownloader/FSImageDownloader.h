//
//  FSImageDownloader.h
//  Folse
//
//  Created by folse on 11/23/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

@interface FSImageDownloader : NSObject

@property (nonatomic) BOOL needCustomSize;
@property (nonatomic, copy) void (^completionHandler)(UIImage *image);


-(void)downloadImageFrom:(NSString *)url;

@end
