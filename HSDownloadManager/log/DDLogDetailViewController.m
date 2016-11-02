//
//  LogDetailViewController.m
//  stockDiary
//
//  Created by changshuai on 11/2/16.
//  Copyright © 2016 changshuai. All rights reserved.
//

#import "DDLogDetailViewController.h"
@interface DDLogDetailViewController()
@property (nonatomic, strong) NSString *logText;
@property (nonatomic, strong) NSString *logDate;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation DDLogDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.editable = NO;
    self.textView.text = self.logText;
    [self.view addSubview:self.textView];
}

- (id)initWithLog:(NSString *)logText forDateString:(NSString *)logDate{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _logText = logText;
        _logDate = logDate;
        self.title = logDate;
    }
    return self;
}

@end
