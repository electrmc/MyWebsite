// some special view moudle
- (instancetype)init{
    self = [super init];
    if (self) {
        [[ViewPropertiesProxy shareViewPropertiesProxy]registerSelector:@selector(viewStockCode) handler:self];
    }
    return self;
}
// this view implementation protocol selector
- (NSString*)stockTickChartPrice{
    return @"codeName";
}

// In view controller
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *codeName = [[ViewPropertiesProxy shareViewPropertiesProxy] stockTickChartPrice];
}