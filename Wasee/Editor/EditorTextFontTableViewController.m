//
//  EditorTextFontTableViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/7/11.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "EditorTextFontTableViewController.h"
#import "EditorTextFontCell.h"

@interface EditorTextFontTableViewController ()

@end

@implementation EditorTextFontTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[EditorTextFontCell class] forCellReuseIdentifier:@"EditorTextFontCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellName = @"EditorTextFontCell";
    EditorTextFontCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[EditorTextFontCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)show:(BOOL)bShow
{
    self.tableView.hidden = !bShow;
}

@end
