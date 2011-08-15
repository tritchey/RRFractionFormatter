//
//  RRFraction.m
//  Lignarius
//
//  Created by Timothy Ritchey on Fri Nov 01 2002.
//  Copyright (c) 2002 Red Rome Logic. All rights reserved.
//

#import <math.h>
#import "RRFractionNumber.h"


// c functions for converting to fraction from float
int ggt(int a, int b)
{
    if (b==0) { return(a); }
    return(ggt(b, a % b));
}

double ggtd(double a, double b)
{
    if ((a<32768) && (b<32768)) {
        return((double)ggt((int)lround(a),(int)lround(b)));
    } else {
        if ((int)b<0.5) {
            return(a);
        } else {
            return(ggtd(b,a-b*floor(a/b)));
        }
    }
}

void kr(double *a, double *b)
{
    double t;

    t=ggtd(*a,*b);
    *a=*a/t;
    *b=*b/t;
}

int emb(double q, double *a, double *b, double eps)
{
    double q0,qabs,qvor,qnk,am,amm,bmm,bm;
    int i;

    qabs=fabs(q);
    q0=qabs;
    *a=1.0;
    *b=0.0;
    am=0.0;
    bm=1.0;

    i=0;

    do {
        i++;
        if (i>30) break;
        qvor=floor(q0+eps);
        qnk=q0-qvor;

        amm=am;
        bmm=bm;
        am=*a;
        bm=*b;

        *a=qvor*am+amm;
        *b=qvor*bm+bmm;
        kr(a,b);

        if (qnk<eps) break;

        q0=1/qnk;
    } while (fabs(qabs-(*a)/(*b))>=eps);

    if (fabs(qabs-(*a)/(*b))>eps) return(0);
    if (q<0) *a=-*a;

    return 0;
}

@implementation RRFractionNumber

- (const char *)objCType
{
    return "f";
}

- (void)getValue:(void *)buffer
{
    *((float*)(buffer)) = (float)(integerPart + numerator/denominator);
}

+ (RRFractionNumber*)fractionNumberWithIntegerPart:(int)i numerator:(int)n denominator:(int)d
{
    return [[[[RRFractionNumber alloc] initWithIntegerPart:i numerator:n denominator:d] retain] autorelease];
}

+ (RRFractionNumber*)fractionNumberWithFloat:(float)f
{
    double a, d;
    int n;

    emb(f, &a, &d, 1e-6);

    n=(int)a-(int)f*d;

    return [self fractionNumberWithIntegerPart:(int)f
                       numerator:n
                     denominator:d];
    
}

+ (RRFractionNumber*)fractionNumberWithString:(NSString*)s
{
    //hmmm, this should be good...
    NSScanner *scan = [NSScanner scannerWithString:s];
    float f;
    int i = 0, n = 0, d = 0;
    NSString *tmpString;
        
    if([scan scanInt:&i]) {
        // we have an integer

        if([scan scanInt:&n]) {
            if([scan scanString:@"/" intoString:&tmpString]) {
                if([scan scanInt:&d]) {
                    return [self fractionNumberWithIntegerPart:i
                                                     numerator:n
                                                   denominator:d];
                }
            }
        } else if([scan scanString:@"/" intoString:&tmpString]) {
            n = i; i = 0;
            if([scan scanInt:&d]) {
                return [self fractionNumberWithIntegerPart:i
                                                 numerator:n
                                               denominator:d];
            }
        } else if([scan scanString:@"." intoString:&tmpString]) {
        // do nothing drop out and scan fraction
        } else {
            return [self fractionNumberWithIntegerPart:i
                                             numerator:0
                                           denominator:0];
        }
    }

    // okay, finally, try to see if a float will do it
    [scan setScanLocation:0];
    if([scan scanFloat:&f])
        return [self fractionNumberWithFloat:f];

    return [self fractionNumberWithFloat:0.0];
    
}

- (id)initWithIntegerPart:(int)i numerator:(int)n denominator:(int)d
{
    if (self = [super init])
    {
        integerPart = i;
        numerator = n;
        denominator = d;
    }
    return self;
}

- (int)integerPart
{
    return integerPart;
}

- (int)numerator
{
    return numerator;
}

- (int)denominator
{
    return denominator;
}

- (float)floatValue
{
    return (float)(integerPart + numerator/denominator);
}

- (NSString *)descriptionWithLocale:(NSDictionary *)locale
{
    return [[[NSString alloc] initWithFormat:@"%d %d/%d"
                                     locale:locale, integerPart, numerator, denominator] autorelease]; 
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

@end
