//
//  HCMCommentTableViewController.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/1.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMCommentTableViewController.h"
#import "GoodsCommentModel.h"
#import "HCMCommentCell.h"
#import "GoodsCommentFrame.h"

@interface HCMCommentTableViewController ()

@property(strong ,nonatomic)GoodsCommentModel *test;

@property (strong, nonatomic) UIImageView *noDataView;

@end

@implementation HCMCommentTableViewController

-(NSMutableArray *)receiveCommentArray{
    if (!_receiveCommentArray) {
        _receiveCommentArray = [NSMutableArray new];
    }
    return _receiveCommentArray;
}

- (UIImageView *)noDataView{
    if (!_noDataView) {
        
        UIImageView * noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no-comments"]];
        [self.view addSubview:noDataView];
        //[noDataView autoCenterInSuperview];
        _noDataView = noDataView;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品评论";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CommentCell"];
    
    [self.tableView reloadData];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
}

-(void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.receiveCommentArray.count == 0) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.noDataView.hidden = NO;
        
    }else{
        
        self.noDataView.hidden = YES;
    }
    
    return self.receiveCommentArray.count;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCMCommentCell *cell = [HCMCommentCell cellWithTableView:tableView];
    
    cell.CommentFrame = self.receiveCommentArray[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCommentFrame *frame = self.receiveCommentArray[indexPath.row];
    
    return frame.cellHeight;
}

@end
