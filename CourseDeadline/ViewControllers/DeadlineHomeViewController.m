//
//  DeadlineHomeViewController.m
//  Assignment03
//
//  Created by Sheeyam Shellvacumar on 10/25/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

#import "DeadlineHomeViewController.h"
#import "DeadlineDetailViewController.h"
#import <CoreData/CoreData.h>
#import "Deadline+CoreDataProperties.h"
#include "AppDelegate.h"
#import "DeadlineViewCell.h"

@interface DeadlineHomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *deadlineTableView;
@property(weak,nonatomic)AppDelegate *appDelegate;

@end

@implementation DeadlineHomeViewController

+ (NSManagedObjectContext *) getManagedObjectContext
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.persistentContainer.viewContext;
}

NSMutableArray *deadlines;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self fetchDeadlines];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self fetchDeadlines];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchDeadlines {
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Deadline" inManagedObjectContext:context];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Define how we will sort the records
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"duedate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    // Fetch the records and handle an error
    NSError *error;
    deadlines = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if (!deadlines) {
        NSLog(@"Deadlines Array has No Content");
    } else {
         NSLog(@"Deadlines Array Has Content");
    }
    [_deadlineTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [deadlines count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"My Deadlines";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"deadlinecell";
    DeadlineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[DeadlineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Deadline *deadlineObj = [deadlines objectAtIndex:indexPath.row];
    cell.courseNameLbl.text = deadlineObj.coursename;
    cell.courseNoLbl.text = deadlineObj.courseno;
    cell.semLbl.text = deadlineObj.semester;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy"];
    cell.dueLbl.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:deadlineObj.duedate]];
    cell.testNameLbl.text = deadlineObj.testname;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Deadline *deadlineObj = [deadlines objectAtIndex:indexPath.row];
    NSString* selectedValue = deadlineObj.testname;
    NSLog(@"selectedValue ---- %@", selectedValue);
    _sValue = selectedValue;
    [self performSegueWithIdentifier:@"Home2DetailVC" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue is to dldetailVC
    if ([[segue identifier] isEqualToString:@"Home2DetailVC"])
    {
        UINavigationController *navController = [segue destinationViewController];
        
        // Get reference to dldetailVC
        DeadlineDetailViewController *dldetailVC = (DeadlineDetailViewController *)([navController viewControllers][0]);
        
        // Pass value to dldetailVC
        dldetailVC.value = _sValue;
    }
}

- (IBAction)addDeadline:(id)sender {
    _sValue = @"";
    [self performSegueWithIdentifier:@"Home2DetailVC" sender:self];
}

@end
