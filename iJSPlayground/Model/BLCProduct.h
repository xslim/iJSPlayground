#import <Mantle.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol BLCProductExports <JSExport>

@property (nonatomic, strong) NSString* categoryId;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, strong) NSDictionary* extraInfo;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* mediaUrl;
@property (nonatomic, strong) NSString* model;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) BOOL onSale;
@property (nonatomic, strong) NSString* shelf;
@property (nonatomic, assign) NSInteger unitQuantity;


// Custom logic goes here.

@property (nonatomic, strong) NSArray *ingredients;
@property (nonatomic, strong) NSArray *nutritions;
@property (nonatomic, strong) NSArray *allergens;

+ (NSDictionary *)JSONKeyPathsByPropertyKey;

+ (instancetype)new;

@end


@interface BLCProduct : MTLModel <BLCProductExports, MTLJSONSerializing>
@end
