FSImageDownloader
=================

Download and cache image with multithreading, use AFNetworking for core downloading.

Images can be displayed line by line while it is loading.

This downloader is get inspired by the Apple Developer Sample Code: Lazy_Images

Dependent on CocoaPods, to install the AFNetworking. Or you can just delete the CocoaPods Shells.

If u have any problem, let me know.

---

## Usage

    FSImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[FSImageDownloader alloc] init];
        [imageDownloader setCompletionHandler:^(UIImage *image) {
            
            ShotCell *cell = (ShotCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.shotImageView.image = image;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        [self.imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader downloadImageFrom:url];
    }
    
    
For more detail, check the example code.

Enjoy : )