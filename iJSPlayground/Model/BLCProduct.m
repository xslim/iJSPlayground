#import "BLCProduct.h"

@interface BLCProduct ()

// Private interface goes here.

@end


@implementation BLCProduct


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"detail": @"description",
             @"unitQuantity": @"unit_quantity",
             };
}

+ (NSValueTransformer *)identifierJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id x) {
        return [x description];
    }];
}


@end
