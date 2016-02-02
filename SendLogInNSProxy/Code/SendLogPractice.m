@protocol LogTypeA &#60NSObject&#62
@property (copy, nonatomic) NSString *logObject;
@property (copy, nonatomic) NSString *actionType;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *resourceid;
@property (copy, nonatomic) NSString *appVersion;
@property (copy, nonatomic) NSString *deviceVersion;
@end

@protocol LogTypeB &#60NSObject&#62
// ...
@end

// 应用：在视图出现时发送埋点
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SendLog&#60LogTypeA&#62 *logInstance = [[SendLog alloc]init];
    // 这个顺序的定义一般不会放到这里的，实际用时需要封装到类里。
    logInstance.logSequence = @[@"logObject",@"actionType",@"time",@"resourceid",@"appVersion",@"deviceVersion"];
    logInstance.logObject = @"objectName";
    //...
}