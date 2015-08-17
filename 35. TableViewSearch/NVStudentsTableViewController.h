//
//  NVStudentsTableViewController.h
//  35. TableViewSearch
//
//  Created by Admin on 17.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NVStudentsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong,nonatomic) NSMutableArray* arrayOfSections;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
