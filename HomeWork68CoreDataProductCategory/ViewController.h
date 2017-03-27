//
//  ViewController.h
//  HomeWork68CoreDataProductCategory
//
//  Created by  Z on 24.03.17.
//  Copyright © 2017 ItStep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUITableViewDataSource.h"
#import "MyDataController.h"
#import "MyProductMO.h"
#import "MyCategoryMO.h"

@interface ViewController : UIViewController


@property  MyUITableViewDataSource   *TVDS;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property (weak, nonatomic) IBOutlet UIButton *btnEdt;

@property (weak, nonatomic) IBOutlet UIButton *btnDlt;

- (IBAction)btnClick:(id)sender;


@end

