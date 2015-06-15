//
//  PDTViewControllerPopoverDemo.m
//  PDTSimpleCalendarDemo
//
//  Created by Gennady Evstratov on 15.06.15.
//  Copyright (c) 2015 Producteev. All rights reserved.
//
#import "PDTSimpleCalendarViewController.h"
#import "PDTViewControllerPopoverDemo.h"

@interface PDTViewControllerPopoverDemo () <PDTSimpleCalendarViewDelegate>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableDictionary *dateEventsCache;

@property (nonatomic, strong) PDTSimpleCalendarViewController *calendarController;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

- (IBAction)showButtonPressed:(id)sender;

@end

@implementation PDTViewControllerPopoverDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.dateEventsCache = [NSMutableDictionary dictionary];
    self.calendarController = [[PDTSimpleCalendarViewController alloc] init];
    self.calendarController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showButtonPressed:(id)sender
{
    self.calendarController.selectedDate = self.date ?: [NSDate date];
    [self.calendarController scrollToSelectedDate:NO];

    [self presentViewController:self.calendarController animated:YES completion:nil];
}


#pragma mark - PDTSimpleCalendarViewDelegate

- (NSInteger)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller numberOfEventsForDate:(NSDate *)date
{
    if (!self.dateEventsCache[date]) {
        self.dateEventsCache[date] = @(arc4random() % 5);
    }
    
    return [self.dateEventsCache[date] integerValue];
}

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    NSLog(@"Date Selected : %@",date);
    NSLog(@"Date Selected with Locale %@", [date descriptionWithLocale:[NSLocale systemLocale]]);
    
    self.date = date;
    self.dateLabel.text = [date description];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
