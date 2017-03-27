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
@synthesize tableView,btnAdd, btnDlt, btnEdt, TVDS,tabBar , pickerString ;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.TVDS   = [MyUITableViewDataSource  new ];
    self.tableView.dataSource  = self.TVDS;
    
    self.tabBar.delegate  = self.TVDS;
    
    
    //  NSNotificationCenter *NC = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:MyTableViewNeedReloadNotification object:self.TVDS];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPickerStr:) name:MyPickerSelectedStringNotification object:self.TVDS];
    
    
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
        if(self.TVDS.isProductNoCategory == YES)
        {
#pragma mark   Добавление
#pragma mark   ______________
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter new product!"
                                                                           message:@"Name\nPrice\nWeight"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                NSString   *name   = alert.textFields.firstObject.text.copy;
                                                NSString   *category = alert.textFields.lastObject.text.copy;
                                                NSString   *price  = [alert.textFields objectAtIndex:1].text.copy;
                                                NSString   *weight  = [alert.textFields objectAtIndex:2].text.copy;
                                                
                                                NSLog(@"Category = %@", category);
                                                
                                                NSLog(@"self.pickerString = %@", self.pickerString);
                                                
                                                if([self isStringDecimalNumber:weight])
                                                {
                                                    NSLog(@"weight is");
                                                }
                                                
                                                if([self isStringDecimalNumber: price])
                                                {
                                                    NSLog(@"price is");
                                                }
                                                
                                                
                                                if(name.length !=0 && weight.length != 0 && price.length != 0 && [self isStringDecimalNumber: price] && [self isStringDecimalNumber:weight])
                                                {
                                                    NSDictionary    *d  = @{
                                                                            @"name" : name.copy,
                                                                            @"price" : @(price.doubleValue),
                                                                            @"weight" : @(weight.intValue)
                                                                            };
                                                    [self addProductToDB: d];
                                                    NSLog(@"1111111111111111111111111");
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
        else if(self.TVDS.isProductNoCategory == NO)
        {

        
        }

    }
    else if(sender == self.btnEdt)
    {
        
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
        self.pickerString  = [note.userInfo[@"pick"] copy];
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

}



-(void)addProductToDB: (NSDictionary *) d
{
    MyProductMO    *product   =      [NSEntityDescription   insertNewObjectForEntityForName: @"Product"   inManagedObjectContext: [self.TVDS.MDC managedObjectContext]  ];
    // Заполнение полями
    [product setName:   d[@"name"]];
    [product setPrice:   @([d[@"price"] doubleValue])];
    [product setWeight:   @([d[@"weight"] intValue])];
    
    // ----- Сохранение объекта "Продукт" ---------------------
    NSError			*error		= nil;
    if ([[self.TVDS.MDC managedObjectContext] save : &error] == false)   //  save   to DB
    {
        NSLog(@"Error saving context: %@\n%@",  [error localizedDescription], [error userInfo]);
    }
    else
    {
        NSLog(@"Saved OK");
    }
    
}

-(void)updateProductToDB: (NSDictionary *) d id: (int) ID
{
    
    
    
    // Запись по ObjectID !!!
    
    
    NSFetchRequest   *request2   = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    
    NSError   *error2   = nil;
    NSArray  *results2  = [[self.TVDS.MDC managedObjectContext]  executeFetchRequest:request2 error:&error2];
    if(!results2)
    {
        NSLog(@"Error fetching Products objects : %@\n%@", [error2 localizedDescription], [error2 userInfo]);
        exit(0);
    }
    for (NSInteger i = 0; i<results2.count; i++)
    {
        MyProductMO  *product  = (MyProductMO *) [results2 objectAtIndex:i];
        NSString   *strID  = [[[[[product objectID] URIRepresentation]  lastPathComponent] componentsSeparatedByCharactersInSet:[[NSCharacterSet  decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        if(strID.intValue ==  ID)
        {
            NSLog(@"Замена");
            NSLog(@"ID: %@ Name: %@\tPrice : %f\tWeight: %i",strID, product.name, product.price.doubleValue, product.weight.intValue);
            //  NSLog(@"на :");
            
            
            //   NSLog(@"ID: %@ Name: %@\tPrice : %f\tWeight: %i",strID, productEdit.name, productEdit.price.doubleValue, productEdit.weight.intValue);
            // [ [MDC managedObjectContext]  deleteObject: [[MDC managedObjectContext] objectWithID: product.objectID    ]];
            
            [product setName:   d[@"name"]];
            [product setPrice:   @([d[@"price"] doubleValue])];
            [product setWeight:   @([d[@"weight"] intValue])];
            
            
            
            
            // [ [self.MTVC.MDCDS  managedObjectContext] refreshObject:  [[self.MTVC.MDCDS  managedObjectContext] objectWithID: productEdit.objectID    ] mergeChanges: NO];
            
            
            // [ [self.MTVC.MDCDS managedObjectContext]  deleteObject: product];
            NSError  *error3 = nil;
            
            if ([[self.TVDS.MDC managedObjectContext] save : &error3] == false)   //  save   to DB
            {
                NSLog(@"Error saving context: %@\n%@",    [error3 localizedDescription], [error3 userInfo]);
            }
            else
            {
                NSLog(@"Saved OK");
            }
            break;
        }
    }
    
    
    
    
    
    
    
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





@end
