@interface SendLog : NSObject
@property (copy, nonatomic) NSString *logObject;
@property (copy, nonatomic) NSString *actionType;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *resourceid;
@property (copy, nonatomic) NSString *appVersion;
@property (copy, nonatomic) NSString *deviceVersion;
@end

@implementation SendLog
// 拼接统计字符串
- (NSString*)packageLog{
    NSMutableString *string = [NSMutableString string];
    if (self.logObject) {
        [string appendString:self.logObject];
        [string appendString:@"_"];
    }
    if (self.actionType) {
        [string appendString:self.actionType];
        [string appendString:@"_"];
    }
    if (self.appVersion) {
        [string appendString:self.appVersion];
        [string appendString:@"_"];
    }
    if (self.time) {
        [string appendString:self.time];
        [string appendString:@"_"];
    }
    if (self.deviceVersion) {
        [string appendString:self.deviceVersion];
        [string appendString:@"_"];
    }
    return string;
}
@end