//
//  NVStudentsTableViewController.m
//  35. TableViewSearch
//
//  Created by Admin on 17.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVStudentsViewController.h"
#import "NVStudent.h"
#import "NVSection.h"
@interface NVStudentsViewController ()

@end

@implementation NVStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue=[[NSOperationQueue alloc]init];
    self.arrayOfSections=[NSMutableArray array];
    NSMutableArray *sourceArray=[NSMutableArray array];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    for (NSInteger i=0; i<30000; i++) {
        NVStudent* student=[[NVStudent alloc]initWithProperties];
        [sourceArray addObject:student];
    }

    self.sourceArray=[self sortArray:sourceArray BySpecifiedType:SegmentedControlSortTypeDateOfBirth];
    [self separateSourceArray:sourceArray withFilter:@""];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - helpMethods
- (NSMutableArray*) sortArray:(NSMutableArray*) array BySpecifiedType:(SegmentedControlSortType) type {
    NSSortDescriptor *monthOfBirthSort=[[NSSortDescriptor alloc]initWithKey:@"monthOfBirth" ascending:YES];
    NSSortDescriptor *dateSort=[[NSSortDescriptor alloc]initWithKey:@"dateOfBirth" ascending:YES];
    NSSortDescriptor *firstnameSort=[[NSSortDescriptor alloc]initWithKey:@"firstname" ascending:YES];
    NSSortDescriptor *lastnameSort=[[NSSortDescriptor alloc]initWithKey:@"lastname" ascending:YES];
    NSArray *arrayOfDescriptors;
    switch (type) {
        case SegmentedControlSortTypeDateOfBirth:
            arrayOfDescriptors=@[monthOfBirthSort,dateSort,firstnameSort,lastnameSort];
            break;
        case SegmentedControlSortTypeFirstname:
            arrayOfDescriptors=@[firstnameSort,lastnameSort,monthOfBirthSort,dateSort];
            break;
        case SegmentedControlSortTypeLastname:
            arrayOfDescriptors=@[lastnameSort,monthOfBirthSort,dateSort,firstnameSort];
            break;
            
        default:arrayOfDescriptors=nil;
            break;
    }
    [array sortUsingDescriptors:arrayOfDescriptors];
    return array;
}
- (void) separateSourceArray:(NSMutableArray*) sourceArray withFilter:(NSString*) filterString {
    //method for sorting by date only
    //NSLog(@"before delete %ld",[self.queue operationCount]);
    [self.queue cancelAllOperations];
    //NSLog(@"after delete %ld",[self.queue operationCount]);
    
    __weak NVStudentsViewController* weakSelf=self;
    
    NSBlockOperation* blockOperation=[[NSBlockOperation alloc]init];
    __weak NSBlockOperation* weakBlockOperation=blockOperation;
    
    [blockOperation addExecutionBlock:^{
        NSMutableArray *arrayOfSections=[NSMutableArray array];
        NSInteger currentMonth=0;
        NVSection *section=nil;
        
        
        for (NSInteger i=0; i<[sourceArray count]; i++) {
            
            if (weakBlockOperation.isCancelled) {
                //NSLog(@"cancelled");
                break;
            }
            
            NVStudent* student= [sourceArray objectAtIndex:i];
            NSRange rangeFirstname=[student.firstname rangeOfString:filterString options:NSCaseInsensitiveSearch];
            ;
            NSRange rangeLastname=[student.lastname rangeOfString:filterString options:NSCaseInsensitiveSearch]
            ;
            if (((rangeFirstname.location==NSNotFound) && (rangeLastname.location==NSNotFound)) && [filterString length]>0) {
                continue;
            }
            student.rangeInFirstname=rangeFirstname;
            student.rangeInLastname=rangeLastname;
            
            NSCalendar* calendar=[NSCalendar currentCalendar];
            NSDateComponents* components=nil;
            components=[calendar components:NSCalendarUnitMonth fromDate:student.dateOfBirth];
            NSInteger monthOfStudent=[components month];
            if (monthOfStudent!=currentMonth) {
                section=[[NVSection alloc]init];
                [arrayOfSections addObject:section];
                section.name=[weakSelf stringFromDate:student.dateOfBirth withOutputFormat:@"MMMM"];
            } else {
                section=[arrayOfSections lastObject];
            }
            [section.students addObject:student];
            currentMonth=monthOfStudent;
            
            
            
        }
        weakSelf.arrayOfSections=arrayOfSections;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
    
    [self.queue addOperation:blockOperation];
    //NSLog(@"after add %ld",[self.queue operationCount]);
}
- (void) separateSourceArray:(NSMutableArray*) sourceArray withFilter:(NSString*) filterString forFirstOrLastnamesByType:(SegmentedControlSortType) type {
    //method for separate first and last names
    [self.queue cancelAllOperations];
    
    __weak NVStudentsViewController* weakSelf=self;
    
    NSBlockOperation* blockOperation=[[NSBlockOperation alloc]init];
    __weak NSBlockOperation* weakBlockOperation=blockOperation;
    
    [blockOperation addExecutionBlock:^{
        NSMutableArray *arrayOfSections=[NSMutableArray array];
        NSString* currentLetter=@"";
        NVSection *section=nil;
        
        for (NSInteger i=0; i<[sourceArray count]; i++) {
            
            if (weakBlockOperation.isCancelled) {
                //NSLog(@"cancelled");
                break;
            }
            
            NVStudent* student= [sourceArray objectAtIndex:i];
            NSRange rangeFirstname=[student.firstname rangeOfString:filterString options:NSCaseInsensitiveSearch];
            ;
            NSRange rangeLastname=[student.lastname rangeOfString:filterString options:NSCaseInsensitiveSearch]
            ;
            if (((rangeFirstname.location==NSNotFound) && (rangeLastname.location==NSNotFound)) && [filterString length]>0) {
                continue;
            }
            student.rangeInFirstname=rangeFirstname;
            student.rangeInLastname=rangeLastname;
            
            
            NSString* firstLetter;
            if (type==SegmentedControlSortTypeFirstname) {
                firstLetter=[student.firstname substringToIndex:1];
            } else {
                firstLetter=[student.lastname substringToIndex:1];
            }
            
            if (![currentLetter isEqualToString:firstLetter]) {
                section=[[NVSection alloc]init];
                [arrayOfSections addObject:section];
                section.name=firstLetter;
            } else {
                section=[arrayOfSections lastObject];
            }
            [section.students addObject:student];
            currentLetter=firstLetter;
            
        }
        weakSelf.arrayOfSections=arrayOfSections;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
    
    [self.queue addOperation:blockOperation];
    //NSLog(@"after add %ld",[self.queue operationCount]);
}
- (void) sortSourceArray:(NSMutableArray*) sourceArray byType:(SegmentedControlSortType)type withFilter:(NSString*) filter{
    //this method is consist of 2 methods. Just a wrap.
    //sort
    [self sortArray:sourceArray BySpecifiedType:type];
    //end of sort
    //separate
    switch (type) {
        case SegmentedControlSortTypeDateOfBirth:
            
            [self separateSourceArray:sourceArray withFilter:filter];
            break;
        case SegmentedControlSortTypeFirstname:
            [self separateSourceArray:sourceArray withFilter:filter forFirstOrLastnamesByType:type];
            break;
        case SegmentedControlSortTypeLastname:
            [self separateSourceArray:sourceArray withFilter:filter forFirstOrLastnamesByType:type];
            break;
            
  
        default:
            break;
    }
}
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
    if (self.segmentedControlValue.selectedSegmentIndex==SegmentedControlSortTypeDateOfBirth) {
        for (NVSection *obj in self.arrayOfSections) {
            NSString* indexOfSection=[obj.name substringToIndex:3];
            [tempArray addObject:indexOfSection];
        }
    } else {
        for (NVSection *obj in self.arrayOfSections) {
            NSString* indexOfSection=[obj.name substringToIndex:1];
            [tempArray addObject:indexOfSection];
        }
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
    if ([self.searchBar.text length]) {
        NSMutableAttributedString *attributedFirstnameString=[[NSMutableAttributedString alloc]initWithString:student.firstname];
        [attributedFirstnameString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:student.rangeInFirstname];
        
        NSAttributedString* spaceString=[[NSAttributedString alloc]initWithString:@" "];
        
        NSMutableAttributedString *attributedLastnameString=[[NSMutableAttributedString alloc]initWithString:student.lastname];
        [attributedLastnameString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:student.rangeInLastname];
        [attributedFirstnameString appendAttributedString:spaceString];
        [attributedFirstnameString appendAttributedString:attributedLastnameString];
        cell.textLabel.text=nil;
        cell.textLabel.attributedText=attributedFirstnameString;
    } else {
        cell.textLabel.attributedText=nil;
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",student.firstname,student.lastname];
    }
    
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
    searchBar.text=@"";
    [self sortSourceArray:self.sourceArray byType:self.segmentedControlValue.selectedSegmentIndex withFilter:searchBar.text];
    //[self separateSourceArray:self.sourceArray withFilter:searchBar.text];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self separateSourceArray:self.sourceArray withFilter:searchText];
}
#pragma mark -Actions
- (IBAction)segmentedControlTypeOfSort:(UISegmentedControl *)sender {
    
    [self sortSourceArray:self.sourceArray byType:sender.selectedSegmentIndex withFilter:self.searchBar.text];
}
@end
