//
//  MyUITableViewDataSource.m
//  HomeWork68CoreDataProductCategory
//
//  Created by Z on 26.03.17.
//  Copyright © 2017 ItStep. All rights reserved.
//

#import "MyUITableViewDataSource.h"

@implementation MyUITableViewDataSource
@synthesize MDC, bufferProduct, bufferCategory, isProductNoCategory;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->MDC  = [MyDataController new];
        self->isProductNoCategory  = NO;
        [self makeDB];
        [self reloadBuffersFromDB];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isProductNoCategory)
    {
        return   self.bufferProduct.count;
    }
    else
    {
        return  self.bufferCategory.count;
    }
    
    
  //  return 10000;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  UITableViewCell   *tvc  =   [[UITableViewCell   alloc]  initWithStyle: UITableViewCellStyleDefault  reuseIdentifier: @"id"];
   
    
  //  UITableViewCell   *tvc
    
#pragma mark   Выдача значений в ячейки 
    
    if(isProductNoCategory)
    {
        
        UITableViewCell   *tvc =  [[UITableViewCell   alloc]  initWithStyle: UITableViewCellStyleSubtitle  reuseIdentifier: @"id"];
        /*
         
         UITableViewCell   *tvc  =  [tableView dequeueReusableCellWithIdentifier:@"id"];
         
         
         if(tvc == nil)
         {
         tvc =  [[UITableViewCell   alloc]  initWithStyle: UITableViewCellStyleSubtitle  reuseIdentifier: @"id"];
         }
         
         */
       
        tvc.textLabel.text  = [NSString  stringWithFormat: @"%@", [self->bufferProduct objectAtIndex: indexPath.row][@"name"]];
        tvc.detailTextLabel.text  = [NSString  stringWithFormat: @"Price %@    Weight %@",
                                     [self->bufferProduct objectAtIndex: indexPath.row][@"price"],
                                     [self->bufferProduct objectAtIndex: indexPath.row][@"weight"]
                                     ];
       
        
        
        CGRect   frTV  = tableView.frame;
        CGRect   fr  = tvc.contentView.frame;
        fr.size.width   = frTV.size.width - 2.0;
        tvc.frame  = fr;
        UIImageView   *imv  = [[UIImageView alloc] initWithFrame:CGRectMake(fr.size.width - 30, 2, 25, 25)];
        
        
        NSInteger  rn = [[self->bufferProduct objectAtIndex: indexPath.row][@"imageId"] intValue];
        NSArray<NSString *>      *arr   =  @[@"All",@"Books",@"Choco",@"Drinks",@"iPhone"];
        imv.image  = [UIImage imageNamed:  [arr objectAtIndex:rn]];
        [tvc.contentView  addSubview: imv];
        return tvc;


    }
    else
    {
        UITableViewCell   *tvc =  [[UITableViewCell   alloc]  initWithStyle: UITableViewCellStyleDefault  reuseIdentifier: @"id"];
        
        tvc.textLabel.text  = [NSString  stringWithFormat: @"%@",[bufferCategory objectAtIndex: indexPath.row][@"name"]];
      //  tvc.detailTextLabel.text  = @"";
        
        CGRect   frTV  = tableView.frame;
        CGRect   fr  = tvc.contentView.frame;
        fr.size.width   = frTV.size.width - 2.0;
        tvc.frame  = fr;
        UIImageView   *imv  = [[UIImageView alloc] initWithFrame:CGRectMake(fr.size.width - 30, 2, 25, 25)];
        
        NSInteger  rn = [[self->bufferCategory objectAtIndex: indexPath.row][@"imageId"] intValue];
        NSArray<NSString *>      *arr   =  @[@"All",@"Books",@"Choco",@"Drinks",@"iPhone"];
        imv.image  = [UIImage imageNamed:  [arr objectAtIndex:rn]];
        [tvc.contentView  addSubview: imv];
        
        return tvc;
    }
    UITableViewCell   *tvc =  [[UITableViewCell   alloc]  initWithStyle: UITableViewCellStyleSubtitle  reuseIdentifier: @"id"];
    
    tvc.textLabel.text  = [NSString  stringWithFormat: @"N/A"];
    tvc.detailTextLabel.text  = @"N/A";
    
    return tvc;
}

//@optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}



#pragma mark  Создание и наполнение базы данных
-(void)makeDB
{
   
    //   Напитки
    //   Создание категории
    
    MyCategoryMO   *categoryDrinks   = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:[MDC managedObjectContext]];
    
    [categoryDrinks  setName:@"Напитки"];
    // Pepsi-Cola
    // ------------  Создание объекта Product  ------
    MyProductMO   *productPepsi   = [NSEntityDescription  insertNewObjectForEntityForName: @"Product" inManagedObjectContext: [MDC managedObjectContext]];
    
    [productPepsi  setName:@"Pepsi-Cola"];
    [productPepsi  setPrice:@19.3];
    [productPepsi  setWeight: @1000];
    
    //  -------- Добавление продукта в категорию  ---------
    
    [categoryDrinks  addCategoryToProductObject   : productPepsi];
    
    //   Coca cola
    // ------------  Создание объекта Product  ------
    MyProductMO   *productCoca   = [NSEntityDescription  insertNewObjectForEntityForName: @"Product" inManagedObjectContext: [MDC managedObjectContext]];
    
    [productCoca  setName:@"Coca-Cola"];
    [productCoca  setPrice:@18.7];
    [productCoca  setWeight: @1000];
    
    //  -------- Добавление продукта в категорию  ---------
    [categoryDrinks  addCategoryToProductObject   : productCoca];
    
    ///       Батончики
    //  Создание категории
    
    MyCategoryMO   *categoryChocolads   = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:[MDC managedObjectContext]];
    
    [categoryChocolads  setName:@"Батончики"];
    
    //    Mars
    // ------------  Создание объекта Product  ------
    MyProductMO   *productMars   = [NSEntityDescription  insertNewObjectForEntityForName: @"Product" inManagedObjectContext: [MDC managedObjectContext]];
    
    [productMars  setName:@"Mars"];
    [productMars  setPrice:@10.5];
    [productMars  setWeight: @35];
    
    //  -------- Добавление продукта в категорию  ---------
    
    [categoryChocolads  addCategoryToProductObject   : productMars];
    
    //   Twix
    // ------------  Создание объекта Product  ------
    MyProductMO   *productTwix   = [NSEntityDescription  insertNewObjectForEntityForName: @"Product" inManagedObjectContext: [MDC managedObjectContext]];
    [productTwix  setName:@"Twix"];
    [productTwix  setPrice:@8.5];
    [productTwix  setWeight: @20];
    //  -------- Добавление продукта в категорию  ---------
    
    [categoryChocolads  addCategoryToProductObject   : productTwix];
    
    
    
    ///       Книги
    //  Создание категории
    
    MyCategoryMO   *categoryBooks   = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:[MDC managedObjectContext]];
    
    [categoryBooks  setName:@"Книги"];
    
    //    Mars
    // ------------  Создание объекта Product  ------
    MyProductMO   *productMaxFreiSkazki   = [NSEntityDescription  insertNewObjectForEntityForName: @"Product" inManagedObjectContext: [MDC managedObjectContext]];
    
    [productMaxFreiSkazki  setName:@"Макс Фрай, Сказки Старого Вильнюса"];
    [productMaxFreiSkazki  setPrice:@350];
    [productMaxFreiSkazki  setWeight: @350];
    
    //  -------- Добавление продукта в категорию  ---------
    
    [categoryBooks  addCategoryToProductObject   : productMaxFreiSkazki];
    
    //   Twix
    // ------------  Создание объекта Product  ------
    MyProductMO   *productAzimovIRobot   = [NSEntityDescription  insertNewObjectForEntityForName: @"Product" inManagedObjectContext: [MDC managedObjectContext]];
    [productAzimovIRobot  setName:@"Айзек Азимов. Я робот."];
    [productAzimovIRobot  setPrice:@180.0];
    [productAzimovIRobot  setWeight: @300];
    //  -------- Добавление продукта в категорию  ---------
    
    [categoryBooks  addCategoryToProductObject   : productAzimovIRobot];
    
    
    ///       iPhones
    //  Создание категории
    
    MyCategoryMO   *categoryIPhones   = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:[MDC managedObjectContext]];
    
    [categoryIPhones  setName:@"iPhones"];
    
    //    Mars
    // ------------  Создание объекта Product  ------
    MyProductMO   *productIPhone7Plus   = [NSEntityDescription  insertNewObjectForEntityForName: @"Product" inManagedObjectContext: [MDC managedObjectContext]];
    
    [productIPhone7Plus  setName:@"iPhone7Plus"];
    [productIPhone7Plus  setPrice:@34999.00];
    [productIPhone7Plus  setWeight: @188];
    
    //  -------- Добавление продукта в категорию  ---------
    
    [categoryIPhones  addCategoryToProductObject   : productIPhone7Plus];
    
    //   Twix
    // ------------  Создание объекта Product  ------
    MyProductMO   *productIPhone7   = [NSEntityDescription  insertNewObjectForEntityForName: @"Product" inManagedObjectContext: [MDC managedObjectContext]];
    [productIPhone7  setName:@"iPhone7"];
    [productIPhone7  setPrice:@22999.00];
    [productIPhone7  setWeight: @138];
    //  -------- Добавление продукта в категорию  ---------
    
    [categoryIPhones  addCategoryToProductObject   : productIPhone7];
    
    
    
    
    // ------------  Сохранение базы -------
    
    NSError   *error = nil;
    if([[MDC managedObjectContext]  save: &error] == false)
    {
        NSLog(@"Error saving context :%@\n%@", [error localizedDescription  ], [error userInfo]);
    }
    else
    {
        NSLog(@"Save OK");
    }

}

#pragma mark  Загрузка буферов из БД
-(void)reloadBuffersFromDB
{
    //   -----------   Show   -----
    
    // ----- Извлечение списка продуктов ---------------------
    NSFetchRequest	*request	= [NSFetchRequest
                                   fetchRequestWithEntityName : @"Product"];
    
    NSError		*error1		= nil;
    NSArray		*results	= [[MDC managedObjectContext]
                               executeFetchRequest:request error:&error1];
    
    if (!results)
    {
        NSLog(@"Error fetching Employee objects: %@\n%@",
              [error1 localizedDescription], [error1 userInfo]);
        exit(0);
    }
    
    NSLog(@"Count : %li", results.count);
    
    for (int i = 0; i < results.count; i++)
    {
        MyProductMO	*product = (MyProductMO *) [results objectAtIndex : i];
        NSLog(@"Name : \t  %@  \t  Price : %f\tWeight : %i",
              product.name,
              product.price.doubleValue,
              product.weight.intValue);
    }
    
    
    
    // ----- Извлечение списка категорий ---------------------
    NSFetchRequest	*requestC	= [NSFetchRequest
                                   fetchRequestWithEntityName : @"Category"];
    
    NSError		*error1C		= nil;
    NSArray		*resultsC	= [[MDC managedObjectContext]
                               executeFetchRequest:requestC error:&error1C];
    
    if (!resultsC)
    {
        NSLog(@"Error fetching Employee objects: %@\n%@",
              [error1 localizedDescription], [error1 userInfo]);
        exit(0);
    }
    
    NSLog(@"Count : %li", resultsC.count);
    
    
    self.bufferCategory  = [NSMutableArray<NSDictionary  *>  array];
    self.bufferProduct   = [NSMutableArray<NSDictionary  *>  array];
    
    
    for (int i = 0; i < resultsC.count; i++)
    {
        int imageIdInt = 0;
        
        MyCategoryMO  *category  = (MyCategoryMO *) [resultsC  objectAtIndex:i];
        NSLog(@"Category name: %@ \n\n", category.name);
        
        
        if([category.name isEqualToString: @"Книги"])
        {
            imageIdInt  = 1;
        }
        else if([category.name isEqualToString: @"Батончики"])
        {
            imageIdInt  = 2;
        }
        else if([category.name isEqualToString: @"Напитки"])
        {
            imageIdInt  = 3;
        }
        else if([category.name isEqualToString: @"iPhones"])
        {
            imageIdInt  = 4;
        }
        
        NSDictionary  *dictCategory  = @{
                                 @"id"  : category.objectID,
                                 @"name" : category.name.copy,
                                 @"imageId":  @(imageIdInt)
                                 };
        
        
        
        [self.bufferCategory  addObject: dictCategory];
        
        
        NSArray<MyProductMO *>   *prods  = [category.categoryToProduct allObjects];
        for (int j  =0; j < prods.count;j++ )
        {
            MyProductMO    *p  = [prods objectAtIndex: j];
            NSLog(@"Name : \t  %@  \t  Price : %f\tWeight : %i",
                  p.name,
                  p.price.doubleValue,
                  p.weight.intValue);
            
            
            NSDictionary  *dictProduct  = @{
                                             @"id"  : p.objectID,
                                             @"name" : p.name.copy,
                                             @"price" : [NSString stringWithFormat:@"%5.2f", p.price.doubleValue],
                                             @"weight" : [NSString stringWithFormat:@"%i", p.weight.intValue],
                                             @"categoryName"  : category.name.copy,
                                             @"categoryId"  : category.objectID,
                                             @"imageId":  @(imageIdInt)
                                             };
            
            [self.bufferProduct  addObject: dictProduct];
            
        }
        
    }


}


@end
