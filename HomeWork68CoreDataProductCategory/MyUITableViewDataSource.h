//
//  MyUITableViewDataSource.h
//  HomeWork68CoreDataProductCategory
//
//  Created by Z on 26.03.17.
//  Copyright © 2017 ItStep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyDataController.h"
#import "MyProductMO.h"
#import "MyCategoryMO.h"



@interface MyUITableViewDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>



@property  MyDataController    *MDC;
@property  NSMutableArray<NSDictionary *>  *bufferProduct;
@property  NSMutableArray<NSDictionary *>   *bufferCategory;
@property  BOOL    isProductNoCategory;

-(void)reloadBuffersFromDB;





@end
