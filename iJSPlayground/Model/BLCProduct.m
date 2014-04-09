#import "BLCProduct.h"

@interface BLCProduct ()

// Private interface goes here.

@end


@implementation BLCProduct

@synthesize name,extraInfo,allergens,categoryId,detail,dictionaryValue,identifier,ingredients,mediaUrl,model,nutritions,onSale,shelf,unitQuantity;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.detail = @"no details";
    }
    return self;
}

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
