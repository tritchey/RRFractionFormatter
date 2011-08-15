//
//  RRFractionNumber.h
//  Lignarius
//
//  Created by Timothy Ritchey on Fri Nov 01 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RRFractionNumber : NSNumber <NSCopying> {
    int integerPart;
    int numerator;
    int denominator;
}
+ (RRFractionNumber*)fractionNumberWithIntegerPart:(int)i numerator:(int)n denominator:(int)d;
+ (RRFractionNumber*)fractionNumberWithFloat:(float)f;
+ (RRFractionNumber*)fractionNumberWithString:(NSString*)s;
- (id)initWithIntegerPart:(int)i numerator:(int)n denominator:(int)d;
- (int)integerPart;
- (int)numerator;
- (int)denominator;
- (float)floatValue;
@end
