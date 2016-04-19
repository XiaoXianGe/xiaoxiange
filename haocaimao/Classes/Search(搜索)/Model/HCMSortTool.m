//
//  HCMSortTool.m
//  haocaimao
//
//  Created by 好采猫 on 16/4/16.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "HCMSortTool.h"

@implementation HCMSortTool

+ ( NSDictionary * )sortWithDictBrand_id:(NSInteger)brand_id keyWords:(NSString *)keyWords category_id:(NSString *)category_id price_min:(NSString *)price_min price_max:(NSString *)price_max page:(NSInteger)page sortWay:(NSString *)sortWay{
    
    NSDictionary *dict = [NSMutableDictionary dictionary];
    if (brand_id) {
        dict=@{@"filter":@{@"sort_by":sortWay,@"brand_id":@(brand_id)},@"pagination":@{@"count":@"20",@"page":@(page)}};
        
    }
    if (keyWords) {
        dict = @{@"filter":@{@"sort_by":sortWay,@"keywords":keyWords},@"pagination":@{@"count":@"20",@"page":@(page)}};
    }
    if (category_id) {
        dict = @{@"filter":@{@"sort_by":sortWay,@"category_id":category_id},@"pagination":@{@"count":@"20",@"page":@(page)}};
    }
    
    if (category_id && brand_id) {
        dict = @{@"filter":@{@"sort_by":sortWay,@"category_id":category_id,@"brand_id":@(brand_id)},@"pagination":@{@"count":@"20",@"page":@(page)}};
        
    }
    
    if (category_id && keyWords) {
        dict = @{@"filter":@{@"sort_by":sortWay,@"category_id":category_id,@"keywords":keyWords},@"pagination":@{@"count":@"20",@"page":@(page)}};
    }
    
    if (brand_id && keyWords) {
        dict = @{@"filter":@{@"sort_by":sortWay,@"brand_id":@(brand_id),@"keywords":keyWords},@"pagination":@{@"count":@"20",@"page":@(page)}};
    }
    
    if(brand_id && keyWords && category_id){
        dict =  @{@"filter":@{@"sort_by":sortWay,@"category_id":category_id,@"keywords":keyWords,@"brand_id":@(brand_id)},@"pagination":@{@"count":@"20",@"page":@(page)}};
        
    }
    if(category_id && brand_id && price_min && price_max){
        dict = @{@"filter":@{@"price_range":@{@"price_max":price_max,@"price_min":price_min},@"brand_id":@(brand_id),@"category_id":category_id,@"sort_by":sortWay},@"pagination":@{@"count":@"20",@"page":@(page)}};
    }
    
    
    return dict;
}
@end
