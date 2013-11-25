//
//  DemoTableViewController.m
//  FSImageDownloader
//
//  Created by folse on 11/25/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import "DemoTableViewController.h"
#import <AFNetworking.h>
#import "Shot.h"
#import "FSImageDownloader.h"
#import "ShotCell.h"

@interface DemoTableViewController ()
{
    NSMutableArray *shotArray;
}

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;


@end

@implementation DemoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    shotArray = [[NSMutableArray alloc] init];
    
    [self getImageInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getImageInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.dribbble.com/players/soelf/shots" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        s(JSON);
        
        NSArray *shops = [JSON valueForKey:@"shots"];

        for (int i = 0; i < shops.count; i++) {
            Shot *shot = [[Shot alloc] initWithData:shops[i]];
            [shotArray addObject:shot];
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            [self startImageDownload:shot.url forIndexPath:index];
        }
        

        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        s(operation.responseString)
        
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return shotArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    Shot *cellShot = shotArray[row];
    
    ShotCell *cell = (ShotCell *)[tableView dequeueReusableCellWithIdentifier:@"ShotCell" forIndexPath:indexPath];
    cell.titleLabel.text = cellShot.title;
    s(cellShot.url)
    NSString *imagePath = [[F alloc] getMD5FilePathWithUrl:cellShot.url];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagePath]){
        
        cell.shotImageView.image = [UIImage imageWithContentsOfFile:imagePath];
        
    }else{
        
        cell.shotImageView.image = [UIImage imageNamed:@"bg_default"];
    }
    
    return cell;
}

-(void)startImageDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath
{
    //FSImageDownloader Usage
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
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
