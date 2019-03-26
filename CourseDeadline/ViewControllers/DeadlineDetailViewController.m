//
//  DeadlineDetailViewController.m
//  Assignment03
//
//  Created by Sheeyam Shellvacumar on 10/25/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

#import "DeadlineDetailViewController.h"
#import <CoreData/CoreData.h>
#import "Deadline+CoreDataProperties.h"
#include "AppDelegate.h"
#import "DeadlineDML.h"

@interface DeadlineDetailViewController ()

@property(weak,nonatomic)AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *courseNoTF;
@property (weak, nonatomic) IBOutlet UITextField *CourseNameTF;
@property (weak, nonatomic) IBOutlet UITextField *SemesterTF;
@property (weak, nonatomic) IBOutlet UITextField *TestNameTF;
@property (weak, nonatomic) IBOutlet UITextField *DueDateTF;

@property (weak, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *deletebtn;

@end

@implementation DeadlineDetailViewController

NSString *mode;
NSMutableArray *mutableFetchResults;

+ (NSManagedObjectContext *) getManagedObjectContext
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.persistentContainer.viewContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                    action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    _DueDateTF.delegate = self;
    
    NSLog(@"value ----- %@", _value);
    _deadlineDatePicker.hidden = true;
    if([_value length] >0) {
        mode = @"edit";
        _deletebtn.hidden = false;
        _TestNameTF.enabled = false;
    } else {
        mode = @"add";
        _deletebtn.hidden = true;
        _deadlineDatePicker.hidden = false;
        _CourseNameTF.text = @"";
        _courseNoTF.text = @"";
        _TestNameTF.text = @"";
        _SemesterTF.text = @"";
        _DueDateTF.text = @"";
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"value --ii--- %@", _value);
    _deadlineDatePicker.hidden = true;
    if([_value length] >0) {
        mode = @"edit";
        [self fetchUpdateDeadline:_value];
        _deletebtn.hidden = false;
    } else {
        mode = @"add";
        _deletebtn.hidden = true;
        _CourseNameTF.text = @"";
        _courseNoTF.text = @"";
        _TestNameTF.text = @"";
        _SemesterTF.text = @"";
        _DueDateTF.text = @"";
    }
}

-(void)dismissKeyboard {
    [_CourseNameTF resignFirstResponder];
    [_courseNoTF resignFirstResponder];
    [_SemesterTF resignFirstResponder];
    [_DueDateTF resignFirstResponder];
    [_TestNameTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    _value = @"";
}

- (IBAction)deleteDeadline:(id)sender {
    if([DeadlineDML deleteDeadlineOperation:_TestNameTF.text]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        _value = @"";
    } else {
        //Error
    }
}

- (IBAction)deadlineChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy"];
    _DueDateTF.text= [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_deadlineDatePicker.date]];
}

- (void) fetchUpdateDeadline: (NSString*)coursename {
    
    NSMutableArray *mutableFetchResults = [DeadlineDML fetchUpdateDeadline:coursename];
    
    if (!mutableFetchResults) {
        // Nil
    } else {
        if([mutableFetchResults count] > 0) {
            Deadline *deadlineObj = [mutableFetchResults objectAtIndex:0];
            _CourseNameTF.text = deadlineObj.coursename;
            _courseNoTF.text = deadlineObj.courseno;
            _TestNameTF.text = deadlineObj.testname;
            _SemesterTF.text = deadlineObj.semester;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd-yy"];
            _DueDateTF.text= [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:deadlineObj.duedate]];
        }
    }
}

- (IBAction)addUpdateData:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy"];
    NSDate *date = [dateFormatter dateFromString:_DueDateTF.text];
    if([DeadlineDML addUpdateDataOperation:mode: _CourseNameTF.text : _courseNoTF.text: _TestNameTF.text: _SemesterTF.text: date]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        _value = @"";
    } else {
        //False
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_DueDateTF resignFirstResponder];
    _deadlineDatePicker.hidden = false;
    return NO;
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    _deadlineDatePicker.hidden = true;
}

@end
