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

static  NSString   *MyTableViewNeedReloadNotification = @"MyTableViewNeedReloadNotification";
static  NSString   *MyPickerSelectedStringNotification = @"MyPickerSelectedStringNotification";


@interface MyUITableViewDataSource : NSObject<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource>



@property  MyDataController    *MDC;
@property  NSMutableArray<NSDictionary *>  *bufferProduct;
@property  NSMutableArray<NSDictionary *>   *bufferCategory;
@property  BOOL    isProductNoCategory;

-(void)makeDB;
-(void)reloadBuffersFromDB;





@end
