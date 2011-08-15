//
//  RRFractionFormatter.m
//  Lignarius
//
//  Created by Timothy Ritchey on Fri Nov 01 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import "RRFractionFormatter.h"
#import "RRFractionNumber.h"


@implementation RRFractionFormatter
- (NSString *)stringForObjectValue:(id)anObject
{
    if(![anObject isKindOfClass:[RRFractionNumber class]]) {
        return nil;
    }
    return [anObject stringValue];
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error
{
    BOOL retval = NO;
    *anObject = [RRFractionNumber fractionNumberWithString:string];
    if(*anObject) {
        retval = YES;
    } else {
        *error = NSLocalizedString(@"Couldn't convert to fraction", @"Error converting");
    }
    return retval;
    
}


- (NSAttributedString *)attributedStringForObjectValue:(id)anObject
                                 withDefaultAttributes:(NSDictionary *)attributes
{

    RRFractionNumber *fn;
    if(![anObject isKindOfClass:[RRFractionNumber class]]) {
        fn = [RRFractionNumber fractionNumberWithFloat:[anObject floatValue]];
        if(!fn)
            fn = [RRFractionNumber fractionNumberWithFloat:0.0];
    } else {
        fn = (RRFractionNumber*)anObject;
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableDictionary *md = [attributes mutableCopy];
    NSAttributedString *append;

    NSFont *font = [md objectForKey:NSFontAttributeName];
    float size = [font pointSize];

    NSMutableParagraphStyle *mps = [[NSMutableParagraphStyle alloc] init];
    [mps setParagraphStyle:[md objectForKey:NSParagraphStyleAttributeName]];

    if([fn denominator] && [fn numerator]) {
        [mps setMaximumLineHeight:size*1.25];
        [mps setMinimumLineHeight:size*1.25];
        [md setObject:mps forKey:NSParagraphStyleAttributeName];
    }
    

    if([fn integerPart] || !([fn denominator] && [fn numerator])) {
        append = [[NSAttributedString alloc] initWithString:
            [NSString stringWithFormat:@"%d", [fn integerPart]]
                                                 attributes:md];
        [string appendAttributedString:append];
        [append release];
    }
    if([fn numerator] && [fn denominator]) {
        // need to compute the right size for the fractional 
        // part based on the current font size
        [md setObject:[[NSFontManager sharedFontManager] convertFont:font toSize:size*0.60]
               forKey:NSFontAttributeName];
        
        // put in numerator
        [md setObject:[NSNumber numberWithInt:(size*.40)] forKey:NSBaselineOffsetAttributeName];
        append = [[NSAttributedString alloc] initWithString:
            [NSString stringWithFormat:@"%d", [fn numerator]]
                                                 attributes:md];
        [string appendAttributedString:append];
        [append release];

        // put in slash
        [md setObject:[NSNumber numberWithFloat:(size*.20)] forKey:NSBaselineOffsetAttributeName];
        append = [[NSAttributedString alloc] initWithString:
            [NSString stringWithString:@"/"] attributes:md];
        [string appendAttributedString:append];
        [append release];

        // put in denominator
        [md setObject:[NSNumber numberWithFloat:0.0] forKey:NSBaselineOffsetAttributeName];
        append = [[NSAttributedString alloc] initWithString:
            [NSString stringWithFormat:@"%d", [fn denominator]]
                                                 attributes:md];
        [string appendAttributedString:append];
        [append release];

    }

    [mps release];
    [md release];
    return [string autorelease];
}
@end
