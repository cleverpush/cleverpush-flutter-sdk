#import "UIColor+HexString.h"

@implementation UIColor(HexString)

#pragma mark - Initialised UIColor by hex string
+ (UIColor *) colorWithHexString: (NSString *) hexString {
    if (![hexString isKindOfClass:[NSString class]]) {
        return [UIColor blackColor];
    }

    NSString *colorString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                              stringByReplacingOccurrencesOfString:@"#" withString:@""];
    colorString = [[colorString stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];

    if (colorString.length == 0) {
        return [UIColor blackColor];
    }

    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return [UIColor blackColor];
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

#pragma mark - Initialised UIColor at specific range of the string
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
