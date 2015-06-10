//
//  PDTSimpleCalendarViewHeader.m
//  PDTSimpleCalendar
//
//  Created by Jerome Miglino on 10/8/13.
//  Copyright (c) 2013 Producteev. All rights reserved.
//

#import "PDTSimpleCalendarViewHeader.h"

const CGFloat PDTSimpleCalendarHeaderTextSize = 12.0f;

@interface PDTSimpleCalendarViewHeader ()

@property (nonatomic, assign) BOOL dayLabelsAdded;
@property (nonatomic, strong) NSArray *weekdayLabels;

@property (nonatomic, strong) UIView *separatorView;

@end

@implementation PDTSimpleCalendarViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:self.textFont];
        [_titleLabel setTextColor:self.textColor];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];

        [self addSubview:_titleLabel];
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        UIView *separatorView = [[UIView alloc] init];
        [separatorView setBackgroundColor:self.separatorColor];
        [self addSubview:separatorView];
        [separatorView setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.separatorView = separatorView;
        
        CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
        NSDictionary *metricsDictionary = @{@"onePixel" : [NSNumber numberWithFloat:onePixel]};
        NSDictionary *viewsDictionary = @{@"titleLabel" : self.titleLabel, @"separatorView" : separatorView};

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(==10)-[titleLabel]-(==10)-|" options:0 metrics:nil views:viewsDictionary]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:0 metrics:nil views:viewsDictionary]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[separatorView]|" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel][separatorView(==onePixel)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    }

    return self;
}

- (void)addDayLabelsWithCalendar:(NSCalendar*)calendar
{
    if (self.dayLabelsAdded) {
        return;
    }
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.calendar = calendar;
    df.dateFormat = @"EEE";
    
    NSDate *now = [NSDate date];
    NSDate *nextDay;
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:now];
    if (comps.weekday == 1) {
        nextDay = now;
    } else {
        comps.weekday = 1 - comps.weekday;
        nextDay = [calendar dateByAddingComponents:comps toDate:now options:0];
    }

    NSDateComponents *oneDay = [NSDateComponents new];
    [oneDay setDay:1];

    
    self.dayLabelsAdded = YES;
    NSInteger daysPerWeek = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit].length;
    NSMutableDictionary *views = [NSMutableDictionary dictionary];
    NSMutableArray *dayLabels = [NSMutableArray arrayWithCapacity:daysPerWeek];
    NSMutableString *constraintFormat = [NSMutableString stringWithString:@"|[day1]"];
    for (int i=0; i < daysPerWeek; i++) {
        UILabel *dayLabel = [[UILabel alloc] init];
        dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.text = [df stringFromDate:nextDay];
        [dayLabel setFont:self.textFont];
        [dayLabel setTextColor:self.textColor];
        [dayLabel setBackgroundColor:[UIColor clearColor]];

        [dayLabels addObject:dayLabel];
        [self addSubview:dayLabel];
        
        NSString *dayLabelName = [NSString stringWithFormat:@"day%ld", (long)(i+1)];
        views[dayLabelName] = dayLabel;
        if (i > 0) {
            [constraintFormat appendFormat:@"[day%ld(==day1)]", (long)(i+1)];
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sep]-(3)-[lbl]|" options:0 metrics:nil views:@{@"lbl": dayLabel, @"sep": self.separatorView}]];

        nextDay = [calendar dateByAddingComponents:oneDay toDate:nextDay options:0];
    }
    [constraintFormat appendString:@"|"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintFormat options:0 metrics:nil views:views]];
    
    [self setNeedsLayout];
}

#pragma mark - Colors

- (UIColor *)textColor
{
    if(_textColor == nil) {
        _textColor = [[[self class] appearance] textColor];
    }

    if(_textColor != nil) {
        return _textColor;
    }

    return [UIColor grayColor];
}

- (UIFont *)textFont
{
    if(_textFont == nil) {
        _textFont = [[[self class] appearance] textFont];
    }

    if(_textFont != nil) {
        return _textFont;
    }

    return [UIFont systemFontOfSize:PDTSimpleCalendarHeaderTextSize];
}

- (UIColor *)separatorColor
{
    if(_separatorColor == nil) {
        _separatorColor = [[[self class] appearance] separatorColor];
    }

    if(_separatorColor != nil) {
        return _separatorColor;
    }

    return [UIColor lightGrayColor];
}


@end
