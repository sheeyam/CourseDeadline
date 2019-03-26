//
//  DeadlineViewCell.h
//  Assignment03
//
//  Created by Sheeyam Shellvacumar on 10/27/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeadlineViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *testNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *semLbl;
@property (weak, nonatomic) IBOutlet UILabel *dueLbl;

@end
