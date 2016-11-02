//
//  LogTableViewController.m
//  stockDiary
//
//  Created by changshuai on 11/2/16.
//  Copyright © 2016 changshuai. All rights reserved.
//

#import "DDLogTableViewController.h"
#import "DDLogDefine.h"
#import "DDLogDetailViewController.h"
#import "DDLogHelper.h"

@interface DDLogTableViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *logTableView;
//@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray *logFiles;

@end

@implementation DDLogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    _fileLogger = delegate.logger.fileLogger;
    [self loadLogFiles];
    if (!_logTableView) {
        _logTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStyleGrouped];
        _logTableView.showsVerticalScrollIndicator = NO;
        _logTableView.showsHorizontalScrollIndicator=NO;
        _logTableView.dataSource = self;
        _logTableView.delegate = self;
        //[_logTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"logTableCell"];
        [self.view addSubview:_logTableView];
    }
}

- (void)loadLogFiles {
    self.logFiles = [[DDLogHelper sharedManager] getFileLogger].logFileManager.sortedLogFileInfos; //self.fileLogger.logFileManager.sortedLogFileInfos;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter) {
        return _dateFormatter;
    }
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return _dateFormatter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.logFiles.count;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    if (section==0) {
        UILabel *myLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width, 30)];
        myLabel.text=@"日记列表";
        [headView addSubview:myLabel];
    }
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"logTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        DDLogFileInfo *logFileInfo = (DDLogFileInfo *)self.logFiles[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = indexPath.row == 0 ? NSLocalizedString(@"当前", @"") : [self.dateFormatter stringFromDate:logFileInfo.creationDate];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = NSLocalizedString(@"清理旧的记录", @"");
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        DDLogFileInfo *logFileInfo = (DDLogFileInfo *)self.logFiles[indexPath.row];
        NSData *logData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
        NSString *logText = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        DDLogDetailViewController *detailViewController = [[DDLogDetailViewController alloc] initWithLog:logText
                                                                                             forDateString:[self.dateFormatter stringFromDate:logFileInfo.creationDate]];
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        for (DDLogFileInfo *logFileInfo in self.logFiles) {
            //除了当前 其它进行清除
            if (logFileInfo.isArchived) {
                [[NSFileManager defaultManager] removeItemAtPath:logFileInfo.filePath error:nil];
            }
        }
        [self loadLogFiles];
        [self.logTableView reloadData];
    }
}

@end
