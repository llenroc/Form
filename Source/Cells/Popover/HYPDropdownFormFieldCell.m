#import "HYPDropdownFormFieldCell.h"

#import "HYPFieldValue.h"
#import "HYPFieldValuesTableViewController.h"

static const CGSize HYPDropdownPopoverSize = { .width = 320.0f, .height = 308.0f };

@interface HYPDropdownFormFieldCell () <HYPTextFormFieldDelegate, HYPFieldValuesTableViewControllerDelegate>

@property (nonatomic, strong) HYPFieldValuesTableViewController *fieldValuesController;

@end

@implementation HYPDropdownFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.fieldValuesController
                 andContentSize:HYPDropdownPopoverSize];
    if (!self) return nil;

    [self.iconButton setImage:[UIImage imageNamed:@"ic_mini_arrow_down"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.iconButton];

    return self;
}

#pragma mark - Getters

- (HYPFieldValuesTableViewController *)fieldValuesController
{
    if (_fieldValuesController) return _fieldValuesController;

    _fieldValuesController = [[HYPFieldValuesTableViewController alloc] init];
    _fieldValuesController.delegate = self;

    return _fieldValuesController;
}

#pragma mark - Private headers

- (void)updateWithField:(HYPFormField *)field
{
    [super updateWithField:field];

    if (field.fieldValue) {
        if ([field.fieldValue isKindOfClass:[HYPFieldValue class]]) {
            HYPFieldValue *fieldValue = (HYPFieldValue *)field.fieldValue;
            self.titleLabel.text = fieldValue.title;
        } else {

            for (HYPFieldValue *fieldValue in field.values) {
                if ([fieldValue identifierIsEqualTo:field.fieldValue]) {
                    field.fieldValue = fieldValue;
                    self.titleLabel.text = fieldValue.title;
                    break;
                }
            }
        }
    } else {
        self.titleLabel.text = nil;
    }
}

- (void)validate
{
    [self.titleLabel setValid:[self.field validate]];
}

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    self.fieldValuesController.field = self.field;
}

#pragma mark - HYPFieldValuesTableViewControllerDelegate

- (void)fieldValuesTableViewController:(HYPFieldValuesTableViewController *)fieldValuesTableViewController
                      didSelectedValue:(HYPFieldValue *)selectedValue
{
    self.field.fieldValue = selectedValue;

    [self updateWithField:self.field];

    [self validate];

    [self.popoverController dismissPopoverAnimated:YES];

    if ([self.delegate respondsToSelector:@selector(fieldCell:updatedWithField:)]) {
        [self.delegate fieldCell:self updatedWithField:self.field];
    }
}

@end
