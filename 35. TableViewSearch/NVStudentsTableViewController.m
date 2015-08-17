//
//  NVStudentsTableViewController.m
//  35. TableViewSearch
//
//  Created by Admin on 17.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVStudentsTableViewController.h"
#import "NVStudent.h"
#import "NVSection.h"
@interface NVStudentsTableViewController ()

@end

@implementation NVStudentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfSections=[NSMutableArray array];
    NSMutableArray *sourceArray=[NSMutableArray array];
    
    for (NSInteger i=0; i<30; i++) {
        NVStudent* student=[[NVStudent alloc]initWithProperties];
        [sourceArray addObject:student];
    }
    NSSortDescriptor *monthOfBirthSort=[[NSSortDescriptor alloc]initWithKey:@"monthOfBirth" ascending:YES];
    NSSortDescriptor *dateSort=[[NSSortDescriptor alloc]initWithKey:@"dateOfBirth" ascending:YES];
    NSSortDescriptor *firstnameSort=[[NSSortDescriptor alloc]initWithKey:@"firstnameSort" ascending:YES];
    NSSortDescriptor *lastnameSort=[[NSSortDescriptor alloc]initWithKey:@"lastnameSort" ascending:YES];
    [sourceArray sortUsingDescriptors:@[monthOfBirthSort,dateSort,firstnameSort,lastnameSort]];
    
    NSInteger currentMonth=1;
    NVSection *section=nil;
    for (NSInteger i=0; i<[sourceArray count]; i++) {
        
        NVStudent* student= [sourceArray objectAtIndex:i];
        NSCalendar* calendar=[NSCalendar currentCalendar];
        NSDateComponents* components=nil;
        components=[calendar components:NSCalendarUnitMonth fromDate:student.dateOfBirth];
        NSInteger monthOfStudent=[components month];
        if (monthOfStudent!=currentMonth) {
            section=[[NVSection alloc]init];
            [self.arrayOfSections addObject:section];
            section.name=[self stringFromDate:student.dateOfBirth withOutputFormat:@"MMMM"];
        } else {
            section=[self.arrayOfSections lastObject];
        }
        [section.students addObject:student];
        currentMonth=monthOfStudent;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - helpMethods

- (NSString*) stringFromDate:(NSDate*) date withOutputFormat:(NSString*) format {
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.arrayOfSections count];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for (NVSection *obj in self.arrayOfSections) {
        NSString* indexOfSection=[obj.name substringToIndex:3];
        [tempArray addObject:indexOfSection];
    }
    return [tempArray copy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[self.arrayOfSections objectAtIndex:section] students] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NVSection *currentSection=[self.arrayOfSections objectAtIndex:section];
    
    return currentSection.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* studentIdentifier=@"studentCell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:studentIdentifier];
    NVStudent* student=[[[self.arrayOfSections objectAtIndex:indexPath.section] students] objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",student.firstname,student.lastname];
    
    cell.detailTextLabel.text=[self stringFromDate:student.dateOfBirth withOutputFormat:@"dd.MM.yyyy"];
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text=@"";
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
@end
