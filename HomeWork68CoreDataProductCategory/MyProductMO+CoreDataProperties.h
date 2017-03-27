//
//  MyProductMO+CoreDataProperties.h
//  HomeWork68CoreDataProductCategory
//
//  Created by  Z on 27.03.17.
//  Copyright © 2017 ItStep. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyProductMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyProductMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) MyCategoryMO *productToCategory;

@end

NS_ASSUME_NONNULL_END
