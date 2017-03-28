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
@synthesize tableView,btnAdd, btnDlt, btnEdt, TVDS,tabBar , pickerDictionary ;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.TVDS   = [MyUITableViewDataSource  new ];
    self.tableView.dataSource  = self.TVDS;
    
    self.tabBar.delegate  = self.TVDS;
    
    
    //  NSNotificationCenter *NC = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:MyTableViewNeedReloadNotification object:self.TVDS];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPickerStr:) name: MyPickerSelectedStringNotification object:self.TVDS];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender
{
    if(sender == self.btnDlt)
    {
        NSLog(@"Добавить данные");
        if(self.TVDS.isProductNoCategory == YES)
        {
#pragma mark   Удаление
#pragma mark   ______________
            
            
            if(self.TVDS.bufferProduct.count == 0)  return;
            NSDictionary *dict  =   [self.TVDS.bufferProduct  objectAtIndex: self.tableView.indexPathForSelectedRow.row];
            NSLog(@"Удаление %@, selecttion = %li", dict, self.tableView.indexPathForSelectedRow.section);
            
            NSManagedObject     *mo   = [ [self.TVDS.MDC managedObjectContext] objectWithID: dict[@"id"]];
            NSLog(@"mo = %@", mo);
             // Удаление записи
            [ [self.TVDS.MDC managedObjectContext]  deleteObject: [[self.TVDS.MDC managedObjectContext] objectWithID: dict[@"id"] ]];
             //   Сохраняем базу
            [self saveDB];
            // Обновляем виды
            [self.TVDS reloadBuffersFromDB];
            [self.tableView reloadData];

        }
        else if(self.TVDS.isProductNoCategory == NO)
        {
            if(self.TVDS.bufferCategory.count == 0)  return;
            NSDictionary *dict  =   [self.TVDS.bufferCategory  objectAtIndex: self.tableView.indexPathForSelectedRow.row];
            NSLog(@"Удаление %@, selecttion = %li", dict, self.tableView.indexPathForSelectedRow.section);
            
            // Удаление записи
            NSManagedObject     *mo   = [ [self.TVDS.MDC managedObjectContext] objectWithID: dict[@"id"]];
            NSLog(@"mo = %@", mo);
            [ [self.TVDS.MDC managedObjectContext]  deleteObject: mo];
            
            
            [self saveDB];
            [self.TVDS reloadBuffersFromDB];
            [self.tableView reloadData];

        }
    }
    else if(sender == self.btnAdd)
    {
        NSLog(@"Добавить данные");
        if(self.TVDS.isProductNoCategory == YES && self.TVDS.bufferCategory.count != 0)
        {
#pragma mark   Добавление
#pragma mark   ______________
            
//            if(self.TVDS.bufferCategory.count == 0)
//            {
//                [self warningAlert:@"Отсутствуют категории"];
//            }
            
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter new product!"
                                                                           message:@"Name\nPrice\nWeight\nCategory"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                NSString   *name   = alert.textFields.firstObject.text.copy;
                                                NSString   *category = alert.textFields.lastObject.text.copy;
                                                NSString   *price  = [alert.textFields objectAtIndex:1].text.copy;
                                                NSString   *weight  = [alert.textFields objectAtIndex:2].text.copy;
                                                
                                                NSLog(@"Category = %@", category);
                                                
                                                NSLog(@"self.pickerString = %@", self.pickerDictionary[@"pick"]);
                                                
                                                category = self.pickerDictionary[@"pick"];
                                                
                                                if([self isStringDecimalNumber:weight])
                                                {
                                                    NSLog(@"weight is");
                                                }
                                                
                                                if([self isStringDecimalNumber: price])
                                                {
                                                    NSLog(@"price is");
                                                }
                                                NSDictionary   *categoryDict   = [self.TVDS.bufferCategory  objectAtIndex: [self.pickerDictionary[@"row"] integerValue] ];
                                                
                                                if(category.length != 0 &&  name.length !=0 && weight.length != 0 && price.length != 0 && [self isStringDecimalNumber: price] && [self isStringDecimalNumber:weight])
                                                {
                                                    NSDictionary    *d  = @{
                                                                            @"name" : name.copy,
                                                                            @"price" : @(price.doubleValue),
                                                                            @"weight" : @(weight.intValue),
                                                                            @"category" : category.copy,
                                                                            @"categoryId"  : categoryDict[@"id"]
                                                                            };
                                                    [self addProductToDB: d];
                                                    NSLog(@"1111111111111   Добавление продукта   111111111111");
                                                    [self.TVDS reloadBuffersFromDB];
                                                    [self.tableView reloadData];
                                                }
                                                else
                                                {
                                                    [self warningAlert:@"Incorrectly entered data!"];
                                                }
                                                
                                                
                                                
                                            }];
            // alert.preferredStyle  = ;
            
            [alert addAction:defaultAction];
            
            //- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
            UITextField    *name    = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            UITextField    *price   = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            UITextField    *weight  = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            UITextField    *category = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = name;
            }];
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = price;
            }];
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = weight;
            }];
            
            UIPickerView   *picker   = [UIPickerView   new ] ;
            
            category.inputView  = picker;
            
            
            
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = category;
            }];
            
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
           // self.ptf   = [[PickerTextField    alloc ]  initWithFrame:CGRectMake(50, 50, 50, 150)] ; //alloc] initWithFrame:CGRectMake(50, 50, 50, 150)  ];
           // [self.ptf setDataSource: self.TVDS.bufferCategory andPlaceHolder:@"Category"];
            picker.dataSource  = self.TVDS;
            picker.delegate  = self.TVDS;
           // picker.frame  =  alert.frame;
            [[alert.textFields objectAtIndex:3] setInputView: picker ];
            
          //  [[alert.textFields objectAtIndex:3]   addSubview: picker];
            
            
        }
        else if(self.TVDS.isProductNoCategory == NO || self.TVDS.bufferCategory.count == 0)
        {
            
#pragma mark   Добавление категории!
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter new Category!"
                                                                           message:@"Name"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                NSString   *name   = alert.textFields.firstObject.text.copy;
                                                
                                                NSLog(@"Category = %@", name);
                                                
                                                
                                                
                                                if( name.length !=0 )
                                                {
                                                    NSDictionary    *d  = @{
                                                                            @"name" : name.copy
                                                                            };
                                                    [self addCategoryToDB: d];
                                                    NSLog(@"1111111111111   Добавление продукта   111111111111");
                                                    [self.TVDS reloadBuffersFromDB];
                                                    [self.tableView reloadData];
                                                }
                                                else
                                                {
                                                    [self warningAlert:@"Incorrectly entered data!"];
                                                }
                                                
                                                
                                                
                                            }];
            // alert.preferredStyle  = ;
            
            [alert addAction:defaultAction];
            
            //- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
            UITextField    *name    = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = name;
            }];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
          
        }

    }
    else if(sender == self.btnEdt)
    {
        NSLog(@"Редактируем данные данные");
        if((self.TVDS.bufferCategory.count == 0 && self.TVDS.isProductNoCategory == NO  ) ||
           (self.TVDS.bufferProduct.count == 0 && self.TVDS.isProductNoCategory == YES) ||
           [self.tableView indexPathForSelectedRow]  == nil
           )
        {
            NSLog(@"[self.tableView indexPathForSelectedRow] = %@", [self.tableView indexPathForSelectedRow]);
            [self warningAlert:@"Отсутствуют данные для редактирования!"];
            return;
        }
        else  if(self.TVDS.isProductNoCategory == YES )
        {
#pragma mark   Редактирование
#pragma mark   ______________
#pragma mark   Редактирование  продукта
            
            
            //            if(self.TVDS.bufferCategory.count == 0)
            //            {
            //                [self warningAlert:@"Отсутствуют категории"];
            //            }
            NSDictionary    *currentProduct   = [self.TVDS.bufferProduct objectAtIndex: [[self.tableView indexPathForSelectedRow] row]];
            MyCategoryMO    *currentCategoryMO =  [[self.TVDS.MDC managedObjectContext] objectWithID: currentProduct[@"categoryId"]];
            
            NSDictionary    *currentCategory  = @{
                                                  @"name"  :  currentCategoryMO.name.copy,
                                                  @"id"    :  currentCategoryMO.objectID
                                                  };
            
            NSLog(@"currentCategory(dict) = %@\n name = %@\n id = %@", currentCategory, currentCategory[@"name"], currentCategory[@"id"]);
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter new product!"
                                                                           message:@"Name\nPrice\nWeight\nCategory"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                NSString   *name   = alert.textFields.firstObject.text.copy;
                                              
                                                NSString   *category = alert.textFields.lastObject.text.copy;
                                                NSString   *price  = [alert.textFields objectAtIndex:1].text.copy;
                                                NSString   *weight  = [alert.textFields objectAtIndex:2].text.copy;
                                                
                                                
                                                
                                                
                                                NSLog(@"Category = %@", category);
                                                
                                                NSLog(@"self.pickerString = %@", self.pickerDictionary[@"pick"]);
                                                
                                                NSDictionary   *categoryDict   =  @{
                                                                                    @"categoryId" : currentCategory[@"id"]
                                                                                    };
                                                
                                                
                                                if(self.pickerDictionary[@"pick"] != nil)
                                                {
                                                
                                                    category = self.pickerDictionary[@"pick"];
                                                    categoryDict   =  @{
                                                                        @"categoryId" : self.pickerDictionary[@"categoryId"]
                                                                        }; ;
                                                }
                                                
                                                NSLog(@"Category (after if)= %@", category);
                                                
                                                if([self isStringDecimalNumber:weight])
                                                {
                                                    NSLog(@"weight is");
                                                }
                                                
                                                if([self isStringDecimalNumber: price])
                                                {
                                                    NSLog(@"price is");
                                                }
                                               
                                                
                                                if(category.length != 0  &&  name.length !=0 && weight.length != 0 && price.length != 0 && [self isStringDecimalNumber: price] && [self isStringDecimalNumber:weight])
                                                {
                                                    NSDictionary    *d  = @{
                                                                            @"name" : name.copy,
                                                                            @"price" : @(price.doubleValue),
                                                                            @"weight" : @(weight.intValue),
                                                                            @"category" : category.copy,
                                                                            @"categoryId"  : categoryDict[@"categoryId"],
                                                                            @"productId"   : currentProduct[@"id"]
                                                                            };
                                                    
                                                    NSLog(@"d= %@", d);
                                                    
                                                    [self updateProductToDB: d];
                                                    NSLog(@"222222222222   Редактирование продукта   222222222222");
                                                    [self.TVDS reloadBuffersFromDB];
                                                    [self.tableView reloadData];
                                                }
                                                else
                                                {
                                                    [self warningAlert:@"Incorrectly entered data!"];
                                                }
                                                
                                                
                                                
                                            }];
            // alert.preferredStyle  = ;
            
            [alert addAction:defaultAction];
            
            //- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
            UITextField    *name    = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            UITextField    *price   = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            UITextField    *weight  = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            UITextField    *category = [[UITextField  alloc]   initWithFrame: CGRectMake(0, 0, 20, 150)];
            
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = name;
            }];
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = price;
            }];
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = weight;
            }];
            
            UIPickerView   *picker   = [UIPickerView   new ] ;
            
            category.inputView  = picker;
            
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = category;
            }];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            // self.ptf   = [[PickerTextField    alloc ]  initWithFrame:CGRectMake(50, 50, 50, 150)] ; //alloc] initWithFrame:CGRectMake(50, 50, 50, 150)  ];
            // [self.ptf setDataSource: self.TVDS.bufferCategory andPlaceHolder:@"Category"];
            picker.dataSource  = self.TVDS;
            picker.delegate  = self.TVDS;
            // picker.frame  =  alert.frame;
            [[alert.textFields objectAtIndex:3] setInputView: picker ];
            
            //  [[alert.textFields objectAtIndex:3]   addSubview: picker];
            [alert.textFields objectAtIndex:0].text  = currentProduct[@"name"];
            [alert.textFields objectAtIndex:1].text  =   currentProduct[@"price"];
            [alert.textFields objectAtIndex: 2].text  = currentProduct[@"weight"];
            
            
            [alert.textFields objectAtIndex:3].text  = currentCategory[@"name"];
            
            [picker selectRow: [self  rowOfBufferCategoryByIdCategory: currentCategory[@"id"]] inComponent: 0 animated:NO];
        }
        else if(self.TVDS.isProductNoCategory == NO )
        {
            
#pragma mark   Редактирование категории!
            
            NSDictionary    *currentCategory  =  [self.TVDS.bufferCategory  objectAtIndex: self.tableView.indexPathForSelectedRow.row];

            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter new Category!"
                                                                           message:@"Name"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                NSString   *name   = alert.textFields.firstObject.text.copy;
                                                
                                                NSLog(@"Category = %@", name);
                                                
                                                
                                                
                                                if( name.length !=0 )
                                                {
                                                    NSDictionary    *d  = @{
                                                                            @"name" : name.copy,
                                                                            @"id"   : currentCategory[@"id"]
                                                                            };
                                                    [self updateCategoryToDB: d];
                                                    NSLog(@"222222222   Редактирование категории   2222222222");
                                                    [self.TVDS reloadBuffersFromDB];
                                                    [self.tableView reloadData];
                                                }
                                                else
                                                {
                                                    [self warningAlert:@"Incorrectly entered data!"];
                                                }
                                                
                                                
                                                
                                            }];
            // alert.preferredStyle  = ;
            
            [alert addAction:defaultAction];
            
            //- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
            UITextField    *name    = [[UITextField  alloc]   initWithFrame: CGRectMake(3, 2, 16, 145)];
            
            [alert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField   = name;
            }];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            [alert.textFields objectAtIndex:0].text  = currentCategory[@"name"];

            
        }

    }
    
}


-(void)viewDidAppear:(BOOL)animated
{
   // NSLog(@"-(void)viewDidAppear:(BOOL)animated");
}


-(void)viewDidLayoutSubviews
{
   // NSLog(@"-(void)viewDidLayoutSubviews");
    [self.tableView reloadData];
}

-(void)reloadTableView: (NSNotification *) note
{
    if ([note.name isEqualToString: MyTableViewNeedReloadNotification ]) {
        [self.tableView reloadData];
    }
}


-(void)setPickerStr: (NSNotification *) note
{
    if ([note.name isEqualToString: MyPickerSelectedStringNotification ]) {
      //  [self.tableView reloadData];
        self.pickerDictionary  = [note.userInfo copy];
        //self.pickerDictionary
    }
}




-(void)saveDB
{
    NSError   *error3;
    if ([[self.TVDS.MDC managedObjectContext] save : &error3] == false)   //  save   to DB
    {
        NSLog(@"Error saving context: %@\n%@",    [error3 localizedDescription], [error3 userInfo]);
    }
    else
    {
        NSLog(@"Saved OK");
    }
    self.pickerDictionary = nil;

}


#pragma mark    Добавить продукт к существющей категории и записать базу

-(void)addProductToDB: (NSDictionary *) d
{
   
    MyCategoryMO    *category  =   [[self.TVDS.MDC managedObjectContext] objectWithID: d[@"categoryId"] ];
    MyProductMO    *product   =      [NSEntityDescription   insertNewObjectForEntityForName: @"Product"   inManagedObjectContext: [self.TVDS.MDC managedObjectContext]  ];
    // Заполнение полями
    [product setName:   d[@"name"]];
    [product setPrice:   @([d[@"price"] doubleValue])];
    [product setWeight:   @([d[@"weight"] intValue])];
    
    [category addCategoryToProductObject: product];
    
    
    // ----- Сохранение объекта "Продукт" ---------------------
    [self saveDB];
}

-(void)addCategoryToDB: (NSDictionary *) d
{
    MyCategoryMO    *category   =      [NSEntityDescription   insertNewObjectForEntityForName: @"Category"   inManagedObjectContext: [self.TVDS.MDC managedObjectContext]  ];
    // Заполнение полями
    [category setName:   d[@"name"]];
    
    // ----- Сохранение объекта "Продукт" ---------------------
    [self saveDB];
}



-(void)updateProductToDB: (NSDictionary *) d
{
    
    MyCategoryMO    *category  =   [[self.TVDS.MDC managedObjectContext] objectWithID: d[@"categoryId"] ];
   
     MyProductMO    *product   =   [[self.TVDS.MDC managedObjectContext] objectWithID: d[@"productId"] ];
    
    //MyProductMO    *product   =      [NSEntityDescription   insertNewObjectForEntityForName: @"Product"   inManagedObjectContext: [self.TVDS.MDC managedObjectContext]  ];
    // Заполнение полями
    [product setName:   d[@"name"]];
    [product setPrice:   @([d[@"price"] doubleValue])];
    [product setWeight:   @([d[@"weight"] intValue])];
    [product setProductToCategory: category];
   // [category addCategoryToProductObject: product];
    // ----- Сохранение объекта "Продукт" ---------------------
    [self saveDB];
}

-(void)updateCategoryToDB: (NSDictionary *) d
{
    
    MyCategoryMO    *category  =   [[self.TVDS.MDC managedObjectContext] objectWithID: d[@"id"] ];
    
    
    //MyProductMO    *product   =      [NSEntityDescription   insertNewObjectForEntityForName: @"Product"   inManagedObjectContext: [self.TVDS.MDC managedObjectContext]  ];
    // Заполнение полями
    [category setName:   d[@"name"]];
   
    // [category addCategoryToProductObject: product];
    // ----- Сохранение объекта "Продукт" ---------------------
    [self saveDB];
}



-(void)warningAlert: (NSString *)  message
{
    if(message == nil) return;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


-(bool) isStringDecimalNumber :(NSString *) stringValue
{
    BOOL result = false;
    
    NSString *decimalRegex = @"^(?:|-)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *regexPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", decimalRegex];
    
    if ([regexPredicate evaluateWithObject: stringValue]){
        //Matches
        result = true;
    }
    
    return result;
}

-(NSInteger)rowOfBufferCategoryByIdCategory: (id) categoryId
{
    NSInteger  returnValue = -1;
    for (NSInteger  i = 0; i < self.TVDS.bufferCategory.count; i++)
    {
            if([[self.TVDS.bufferCategory objectAtIndex: i][@"id"] isEqual:categoryId ])
            {
                returnValue = i;
                break;
            }
    }
    return returnValue;
}




@end
