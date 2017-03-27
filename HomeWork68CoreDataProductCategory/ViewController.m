//
//  ViewController.m
//  HomeWork68CoreDataProductCategory
//
//  Created by  Z on 24.03.17.
//  Copyright © 2017 ItStep. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tableView,btnAdd, btnDlt, btnEdt, TVDS;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.TVDS   = [MyUITableViewDataSource  new ];
    self.tableView.dataSource  = self.TVDS;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"-(void)viewDidAppear:(BOOL)animated");
}


-(void)viewDidLayoutSubviews
{
    NSLog(@"-(void)viewDidLayoutSubviews");
    [self.tableView reloadData];
}
@end
