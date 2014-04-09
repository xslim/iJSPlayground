#import <Mantle.h>


@protocol BLCListView <NSObject>
@optional

@property (nonatomic, readonly) NSString *v;
@property (nonatomic, readonly) NSString *sel;

@property (nonatomic, readonly) NSString *ico;
@property (nonatomic, readonly) NSString *img;

@property (nonatomic, readonly) NSString *t1;
@property (nonatomic, readonly) NSString *t2;
@property (nonatomic, readonly) NSString *t3;
@property (nonatomic, readonly) NSString *t4;
@property (nonatomic, readonly) NSString *t5;

@end

@interface BLCObject : MTLModel <MTLJSONSerializing, BLCListView>

@end
