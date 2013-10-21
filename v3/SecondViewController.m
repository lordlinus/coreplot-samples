//
//  SecondViewController.m
//  v3
//
//  Created by d246967 on 21/10/13.
//  Copyright (c) 2013 d246967. All rights reserved.
//

#import "SecondViewController.h"
#define kTopBottomMargins 20

@interface SecondViewController ()

@end

@implementation SecondViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 105.0 + kTopBottomMargins;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
	
    NSString *titleStr;
    NSString *detailStr;
    UIImage *image;
    switch (indexPath.row)
    {
        case 0:
        {
            titleStr = @"Icon.png";
            detailStr = @"Homescreen icon on iPhone/iPod touch";
            cell.detailTextLabel.numberOfLines = 2;
            image = [UIImage imageNamed:@"Icon"];
            break;
        }
        case 1:
        {
            titleStr = @"Icon-72.png";
            detailStr = @"Homescreen icon on iPad";
            image = [UIImage imageNamed:@"Icon-72"];
            break;
        }
        case 2:
        {
            titleStr = @"Icon@2x.png";
            detailStr = @"Homescreen icon on iPhone Retina";
            cell.detailTextLabel.numberOfLines = 2;
            image = [UIImage imageNamed:@"Icon@2x"];
            break;
        }
        case 3:
        {
            titleStr = @"Icon-Small.png";
            detailStr = @"Icon in Spotlight and Settings app on iPhone/iPod touch and icon in Settings app on iPad";
            cell.detailTextLabel.numberOfLines = 3;
            image = [UIImage imageNamed:@"Icon-Small"];
            break;
        }
        case 4:
        {
            titleStr = @"Icon-Small-50.png";
            detailStr = @"Icon in Spotlight on iPad";
            image = [UIImage imageNamed:@"Icon-Small-50"];
            break;
        }
        case 5:
        {
            titleStr = @"Icon-Small@2x.png";
            detailStr = @"Icon in Spotlight and Settings app on iPhone Retina";
            cell.detailTextLabel.numberOfLines = 2;
            image = [UIImage imageNamed:@"Icon-Small@2x"];
            break;
        }
        case 6:
        {
            titleStr = @"iTunesArtwork";
            detailStr = @"Icon in iTunes for Ad Hoc distribution builds";
            cell.detailTextLabel.numberOfLines = 3;
            image = [UIImage imageNamed:@"iTunesArtwork"];
            break;
        }
    }
    
    cell.imageView.image = image;
    cell.textLabel.text = titleStr;
	cell.detailTextLabel.text = detailStr;
    
	return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
