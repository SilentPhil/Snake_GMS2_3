// Block definition

@interface iOSSafeArea : NSObject {
    CGFloat topPadding;
    CGFloat bottomPadding;
    CGFloat leftPadding;
    CGFloat rightPadding;
}

@property (nonatomic) CGFloat topPadding;
@property (nonatomic) CGFloat bottomPadding;
@property (nonatomic) CGFloat leftPadding;
@property (nonatomic) CGFloat rightPadding;

- (NSString *) get_safe_area;
@end
