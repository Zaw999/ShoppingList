//
//  SLSettingTableViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/09/10.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLSettingTableViewController.h"
#import "SLTabSettingTableViewController.h"
#import "SLTabMManager.h"
#import "SLShoppingListData.h"

@interface SLSettingTableViewController ()
{
    NSMutableArray *settingDataArray;
    
    NSString *selectedFont;
    UIColor  *selectedColor;
}
@end

@implementation SLSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *tabConfiguration = NSLocalizedString(@"Tab Configuration", "");
    NSString *color = NSLocalizedString(@"Color", "");
    NSString *font = NSLocalizedString(@"Font", "");
    NSString *reminder = NSLocalizedString(@"Reminder", "");
    self.title = NSLocalizedString(@"Setting", "");
    settingDataArray = [NSMutableArray arrayWithObjects: tabConfiguration, color, font, reminder, nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
    NSLog(@"viewDidLoad SLSettingTableViewController");
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer: swipeLeft];
    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    NSLog(@"viewWillAppear");
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    
    selectedFont = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedFont"];
    selectedColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    [[SLShoppingListData sharedInstance] updateColor];
    
    [self.tableView reloadData];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    
    NSLog(@"Count : %ld", [settingDataArray count]);

}

#pragma mark - Swipe Gesture.

-(void) swipe:(UISwipeGestureRecognizer *) recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"swipe right");
        [SLShoppingListData sharedInstance].tabBarController.selectedIndex -= 1;
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe left");
        [SLShoppingListData sharedInstance].tabBarController.selectedIndex += 1;
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [settingDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"SettingCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    if (selectedFont > 0) {
        cell.textLabel.font = [UIFont fontWithName: selectedFont size: 15];
    }
    
    cell.textLabel.text = [settingDataArray objectAtIndex: indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath : %d", indexPath.row);
    
    self.indexpath = indexPath;
    
    if (indexPath.row == 0) {
        
        [self performSegueWithIdentifier: @"tabSetting" sender:self];
        
    } else if(indexPath.row == 1) {
        
        [self performSegueWithIdentifier: @"colorSetting" sender:self];
        
    } else if(indexPath.row == 2) {
        
        [self performSegueWithIdentifier: @"fontSetting" sender:self];
        
    } else {
        
        [self performSegueWithIdentifier: @"LocalNofiticationSegue" sender:self];
        
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    
    NSLog(@"prepareForSegue: %ld", self.indexpath.row);
}

@end
