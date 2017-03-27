//
//  MyCategoryMO+CoreDataProperties.h
//  HomeWork68CoreDataProductCategory
//
//  Created by  Z on 27.03.17.
//  Copyright © 2017 ItStep. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyCategoryMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCategoryMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<MyProductMO *> *categoryToProduct;

@end

@interface MyCategoryMO (CoreDataGeneratedAccessors)

- (void)addCategoryToProductObject:(MyProductMO *)value;
- (void)removeCategoryToProductObject:(MyProductMO *)value;
- (void)addCategoryToProduct:(NSSet<MyProductMO *> *)values;
- (void)removeCategoryToProduct:(NSSet<MyProductMO *> *)values;

@end

NS_ASSUME_NONNULL_END
