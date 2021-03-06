//
//  HomePageViewModel.m
//  HCFunwear
//
//  Created by 刘海川 on 16/6/29.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import "HomePageViewModel.h"
#import "HCGridMenuView.h"
#import "HomePageHeadTitleView.h"
#import "HomeLayoutApi.h"
#import "HCModule.h"
#import "NSObject+YYModel.h"
#import "GetRecommedProductListApi.h"
#import "HCProduct.h"
#import "RACEXTScope.h"
@interface HomePageViewModel ()

@property (strong, nonatomic, readonly) id <HCHomeViewModelServices> services;

@property (nonatomic, strong, readwrite) RACCommand *layoutRequestCommand;
@property (nonatomic, strong, readwrite) RACCommand *productsRequestCommand;
@property (nonatomic, strong, readwrite) RACCommand *pushCommand;
@property (nonatomic, strong, readwrite) RACCommand *tapCommand;
@property (nonatomic, strong, readwrite) RACCommand *toLeftSideCommand;

@property (nonatomic, strong, readwrite) NSArray *topStyleTitleArray;

@property (nonatomic, strong, readwrite) NSArray *layoutDataArray;
@property (nonatomic, strong, readwrite) NSArray *productsDataArray;

@end

@implementation HomePageViewModel

@dynamic services;

- (void)initialize {
    _topStyleTitleArray = @[@"男生",@"女生",@"生活"];
    _layoutDataArray = [NSArray array];
    _productsDataArray = [NSArray array];
    _productsPage = 0;
    
    _refreshFlag = YES;
    
    self.layoutRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self executeLayoutSignal];
    }];
    
    self.productsRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self executeProductsSignal];
    }];
    
    self.pushCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self executePushSignal:input];
    }];
    
    self.tapCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [self executeTapSignal:input];
    }];
    
    self.toLeftSideCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [self executeToLeftSideSignal:input];
    }];
}

- (RACSignal *)executeProductsSignal {
    return [[[self.services getHomeLayoutService]
             getProductsWithIndexPage:_productsPage] map:^id(NSDictionary *value) {
        NSArray *productList = value[@"data"][@"productList"];
        NSArray *productModelList = [NSArray modelArrayWithClass:HCProduct.class json:productList];
        
        NSMutableArray *mutableArray = [self.productsDataArray mutableCopy];
        [mutableArray addObjectsFromArray:productModelList];
        self.productsDataArray = [mutableArray copy];
        
        return self.productsDataArray;
    }];
}

- (RACSignal *)executeLayoutSignal {
    return [[[self.services getHomeLayoutService] getLayoutModule] map:^id(NSDictionary *value) {
        NSMutableArray *modules = value[@"data"][@"module"];
        self.layoutDataArray = [NSArray modelArrayWithClass:HCModule.class json:modules];
        return self.layoutDataArray;
    }];
}

- (RACSignal *)executePushSignal:(id)viewModel {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.services pushViewModel:viewModel animated:YES];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)executeToLeftSideSignal:(id)viewModel {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.services presentViewModel:viewModel animated:YES completion:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)executeTapSignal:(NSNumber *)tag {
    return [self.services selectedStyle:[tag integerValue]];
}

@end
