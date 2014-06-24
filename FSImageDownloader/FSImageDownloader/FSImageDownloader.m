//
//  FSImageDownloader.m
//  Folse
//
//  Created by folse on 11/23/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import "FSImageDownloader.h"
#import <AFNetworking.h>
#import "CommonCrypto/CommonDigest.h"

#define kAppIconWidth 89
#define kAppIconHeight 65

@implementation FSImageDownloader

-(void)downloadImageFrom:(NSString *)url
{
    NSString *cachePath = [self getMD5FilePathWithUrl:url];
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

-(UIImage *)getImage:(NSString *)imageUrl
{
    NSString *imagePath = [self getMD5FilePathWithUrl:imageUrl];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagePath]){
        
        return [UIImage imageWithContentsOfFile:imagePath];
        
    }else{
        
        return [UIImage imageNamed:@"bg_default"];
    }
}

-(NSString *)MD5:(NSString *)text
{
    if (text) {
        const char *cStr = [text UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (int)strlen(cStr), result);
        
        return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15]
                 ] lowercaseString];
    }else{
        return @"";
    }
}

-(NSString *)getMD5FilePathWithUrl:(NSString *)url
{
    NSString *urlMD5 = [self MD5:url];
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [documents[0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",urlMD5]];
}

@end
