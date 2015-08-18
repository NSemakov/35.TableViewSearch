//
//  NVStudentsTableViewController.h
//  35. TableViewSearch
//
//  Created by Admin on 17.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SegmentedControlSortType){
    SegmentedControlSortTypeDateOfBirth,
    SegmentedControlSortTypeFirstname,
    SegmentedControlSortTypeLastname
};
@interface NVStudentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlValue;
@property (strong,nonatomic) NSMutableArray* arrayOfSections;
- (IBAction)segmentedControlTypeOfSort:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSOperationQueue *queue;
@property (strong,nonatomic) NSMutableArray* sourceArray;
@end
