FSImageDownloader
=================

Download and cache image with multithreading, use AFNetworking for core downloading.

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
    
    
For more detail, check the examples.

Enjoy : )