//
//  FSImageDownloader.m
//  MiaoMiaoGuangJie
//
//  Created by folse on 11/23/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import "FSImageDownloader.h"
#import <AFNetworking.h>

#define kAppIconWidth 89
#define kAppIconHeight 65

@implementation FSImageDownloader

-(void)downloadImageFrom:(NSString *)url
{
    NSString *cachePath = [[F alloc] getMD5FilePathWithUrl:url];
    NSURLRequest *photoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:photoRequest];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:cachePath append:NO]];
    
    [operation setCompletionBlock:^{
        
        if (_needCustomSize) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *cachedImage =[UIImage imageWithContentsOfFile:cachePath];
                if (cachedImage.size.width != kAppIconWidth || cachedImage.size.height != kAppIconHeight)
                {
                    float scale = kAppIconWidth/cachedImage.size.width;
                    float newHeight = cachedImage.size.height * scale;
                    
                    CGSize subImageSize = CGSizeMake(kAppIconWidth, newHeight);
                    CGRect subImageRect = CGRectMake(0, 38, cachedImage.size.width,65/scale+38);
                    CGImageRef imageRef = cachedImage.CGImage;
                    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
                    UIGraphicsBeginImageContext(subImageSize);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGContextDrawImage(context, subImageRect, subImageRef);
                    cachedImage = [UIImage imageWithCGImage:subImageRef];
                    UIGraphicsEndImageContext();
                    
                    NSData *imageData = UIImageJPEGRepresentation(cachedImage, 1);
                    [imageData writeToFile:cachePath atomically:YES];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.completionHandler)
                        self.completionHandler([UIImage imageWithContentsOfFile:cachePath]);
                });
            });
            
        }else{
            if (self.completionHandler)
                self.completionHandler([UIImage imageWithContentsOfFile:cachePath]);
        }
    }];
    
    [operation start];
    
}

@end
