#import "HYPBaseFormFieldCell.h"

static const CGFloat HYPTextFormFieldCellLabelMarginTop = 10.0f;
static const CGFloat HYPTextFormFieldCellLabelHeight = 20.0f;
static const CGFloat HYPTextFormFieldCellLabelMarginX = 5.0f;

@implementation HYPBaseFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self.contentView addSubview:self.headingLabel];

    if ([self respondsToSelector:@selector(resignFirstResponder)]) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(resignFirstResponder) name:HYPFormDismissPopoverNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:HYPFormDismissPopoverNotification object:nil];
}

#pragma mark - Getters

- (HYPFormFieldHeadingLabel *)headingLabel
{
    if (_headingLabel) return _headingLabel;

    _headingLabel = [[HYPFormFieldHeadingLabel alloc] initWithFrame:[self frameForHeadingLabel]];

    return _headingLabel;
}

#pragma mark - Setters

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;

    [self updateFieldWithDisabled:disabled];
}

- (void)setField:(HYPFormField *)field
{
    _field = field;

    self.headingLabel.hidden = (field.sectionSeparator);
    self.headingLabel.text = field.title;

    [self updateWithField:field];
}

#pragma mark - Overwritables

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    abort();
}

- (void)updateWithField:(HYPFormField *)field
{
    abort();
}

- (void)validate
{
    NSLog(@"validation in progress");
}

#pragma mark - Private Methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.headingLabel.frame = [self frameForHeadingLabel];
}

- (CGRect)frameForHeadingLabel
{
    CGFloat marginX = HYPTextFormFieldCellMarginX + HYPTextFormFieldCellLabelMarginX;
    CGFloat marginTop = HYPTextFormFieldCellLabelMarginTop;

    CGFloat width = CGRectGetWidth(self.frame) - (marginX * 2);
    CGFloat height = HYPTextFormFieldCellLabelHeight;
    CGRect frame = CGRectMake(marginX, marginTop, width, height);

    return frame;
}

@end
