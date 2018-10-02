//
//  ViewController.m
//  sdodyworkshop
//
//  Created by Nada Mohamed on 9/12/18.
//  Copyright © 2018 Sarmady. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray * arrayForBool;
    NSMutableArray * categories;
}
@end

@implementation ViewController
@synthesize tbl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    arrayForBool=[[NSMutableArray alloc]init];
    categories =[[NSMutableArray alloc]init];
    
    [self fillthearray];
    tbl.estimatedRowHeight = 44;
    tbl.rowHeight = UITableViewAutomaticDimension;
    tbl.dataSource=self;
    tbl.delegate=self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)populateTheArrayForBool
{
    for (int i=0; i<[categories count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
}
#pragma mark - TableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [categories count];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDictionary * obj = [categories objectAtIndex:indexPath.section];
    NSArray * cellArray = [obj objectForKey:@"items"];
    NSDictionary * cellObj = [cellArray objectAtIndex:indexPath.row];
    
    static NSString *cellid=@"PrototypeCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    BOOL isexpanded  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    /********** If the section supposed to be closed *******************/
    if(!isexpanded)
    {
        cell.backgroundColor=[UIColor clearColor];
        
        cell.textLabel.text=@"";
    }
    /********** If the section supposed to be Opened *******************/
    else
    {
        //fill the custom cell
        //name and descrption
        UILabel * NameLbl = [cell viewWithTag:10];
        UILabel * descLbl = [cell viewWithTag:20];
        
        NameLbl.text = [cellObj objectForKey:@"name"] ;
        descLbl.text = [cellObj objectForKey:@"description"];
    }
     return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        
        NSDictionary * obj = [categories objectAtIndex:section];
        NSArray * cellArray = [obj objectForKey:@"items"];
        return [cellArray count];
    }
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return UITableViewAutomaticDimension;
    }
    return 0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    /*************** Close the section, once the data is selected ***********************************/
//    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
//
//    [tbl reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tbl.frame.size.width,50)];
    sectionView.tag=section;
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, tbl.frame.size.width-10, 40)];
    sectionView.backgroundColor=[UIColor yellowColor];
    viewLabel.textColor=[UIColor blackColor];
    viewLabel.font=[UIFont systemFontOfSize:15];
    //get the object
    NSDictionary * obj = [categories objectAtIndex:section];
    viewLabel.text=[NSString stringWithFormat:@"%@",[obj objectForKey:@"name"]];
    [sectionView addSubview:viewLabel];
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    return  sectionView;
}
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[categories count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [tbl reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}
- (void)fillthearray
{
    NSDictionary *dict = [self JSONFromFile];
    if([dict count]>0)
    {
        categories = [dict objectForKey:@"categories"];
        [self populateTheArrayForBool];
        
    }else
    {
        
        //handle the empty dictionary or show message
        NSLog(@"dictionary is empty " );
    }

    

}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"menuitems" ofType:@"json"];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        //return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                              options:0
                                                                error:&error];
       
        if (error) {
            NSLog(@"Something went wrong! %@", error.localizedDescription);
            return [NSMutableDictionary dictionary];
        }
        else {
            NSLog(@"data info: %@", data);
             return dic;
        }
        
    }
    else {
        NSLog(@"Couldn't find file!");
        return [NSMutableDictionary dictionary]; //is the same as [[[NSMutableDictionary alloc] init]
    }
   
}
//for (NSDictionary *category in categories) {
    //        NSString *name = [colour objectForKey:@"name"];
    //        NSLog(@"Colour name: %@", name);
    //
    //        if ([name isEqualToString:@"green"]) {
    //            NSArray *pictures = [colour objectForKey:@"pictures"];
    //            for (NSDictionary *picture in pictures) {
    //                NSString *pictureName = [picture objectForKey:@"name"];
    //                NSLog(@"Picture name: %@", pictureName);
    //            }
    //        }
//}

@end
