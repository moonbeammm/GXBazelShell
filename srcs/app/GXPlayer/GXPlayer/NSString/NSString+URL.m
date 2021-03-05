//
//  NSString+URL.m
//  _idx_home_library_04B41827_ios_min9.0
//
//  Created by sgx on 2021/3/5.
//

#import "NSString+URL.h"

#define BILIDOMAINSUFFIX "com|tv|cn|co"

static NSRegularExpression *httpRegrex;
static NSRegularExpression *biliHttpRegrex;

@implementation NSString (URL)

- (BOOL)bfc_isWebUrl
{
    if (!httpRegrex) {
        
        /**
         完整解析：
         ^
         (?:http|https|ftp|file):// ## 协议头，这里要求必须要有协议头
         (?:
             ([a-z0-9]([a-z0-9\\-]*\\.)+[a-z]+) ## 域名，“-”不能用作打头，不能用于最后一段，数字也不用于最后一段
             |
             ((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[1-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])) ## IP，每段有效值0-255，首段1-255
         ) ## HOST
         (?:\\:\\d+)? ## 端口号
         (?:
             [/\\?#] ## 域名后面可以直接用“/”或者“?”、“#”打头
             (
                 ([a-z0-9;/\\?\\:@&=#~\\-\\.\\+!\\*'\\(\\),_]) ## 合法字符，这里剔除了中文
                 |
                 (%[a-f0-9]{2}) ## 转义字符
             )*
         )? ## PATH & QUERY & FRAGMENT
         $
         **/
        httpRegrex = [NSRegularExpression regularExpressionWithPattern:@"^(?:http|https|ftp|file)://(?:([a-z0-9]([a-z0-9\\-]*\\.)+[a-z]+)|((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[1-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])))(?:\\:\\d+)?(?:[/\\?#](([a-z0-9;/\\?\\:@&=#~\\-\\.\\+!\\*'\\(\\),_])|(%[a-f0-9]{2}))*)?$" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    NSArray *matches = [httpRegrex matchesInString:self
                                           options:0
                                             range:NSMakeRange(0, [self length])];
    if (nil != matches && matches.count > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)bfc_isBiliUrl
{
    if (!biliHttpRegrex) {
        biliHttpRegrex = [NSRegularExpression regularExpressionWithPattern:@"(^|://)(((\\w|-|_)+\\.)*(bilibili\\.("BILIDOMAINSUFFIX")|acgvideo\\.com|acg\\.tv|b23\\.tv|bili2233\\.cn|bili23\\.cn|bili33\\.cn|bili22\\.cn|hdslb\\.com|biligame\\.com|im9\\.com|dreamcast\\.hk){1})($|[/\\?]\\w*)" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    NSArray *matches = [biliHttpRegrex matchesInString:self
                                               options:0
                                                 range:NSMakeRange(0, [self length])];
    if (nil != matches && matches.count > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)bfc_isDirectOpenUrl
{
    NSString *lowercaseStr = [self lowercaseString];
    if ([lowercaseStr hasPrefix:@"https://appsto.re"] ||
        [lowercaseStr hasPrefix:@"https://itunes.apple.com"] ||
        [lowercaseStr hasPrefix:@"itms-apps://itunes.apple.com"] ||
        [lowercaseStr hasPrefix:@"https://apps.apple.com"] ||
        [lowercaseStr hasPrefix:@"itms-appss://apps.apple.com"]) {
        return YES;
    }
    return NO;
}

- (BOOL)bfc_isValidUrl
{
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (NSString *_Nonnull)bfc_appendParamsWithKey:(NSString *_Nonnull)key value:(NSString *_Nonnull)value
{
    if (!key || !value) {
        return self;
    }
    
    return [self bfc_appendParamsWithDictionary:@{key: value}];
}

- (NSString *_Nonnull)bfc_appendParamsWithDictionary:(NSDictionary<NSString*, NSString*> *_Nonnull)queryDict
{
    if (!queryDict || ![queryDict isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    NSURL *url = [NSURL URLWithString:self];
    if (!url) return self;
    
    NSString *queryStr = url.query;
    for (NSString *itemKey in [queryDict allKeys]) {
        NSString *itemValue = [queryDict valueForKey:itemKey];
        if (!itemKey || ![itemKey isKindOfClass:[NSString class]] || !itemValue) {
            continue;
        }
        
        NSString *queryItem = [NSString stringWithFormat:@"%@=%@", itemKey, itemValue];
        if (queryStr && queryStr.length > 0) {
            queryStr = [queryStr stringByAppendingFormat:@"&%@", queryItem];
        } else {
            queryStr = queryItem;
        }
    }
    
    NSRange range;
    if (url.query && url.query.length > 0) {
        range = [self rangeOfString:[@"?" stringByAppendingString:url.query]];
        range.location++;
        range.length--;
    } else {
        if (url.fragment && url.fragment.length > 0) {
            range = [self rangeOfString:[@"#" stringByAppendingString:url.fragment]];
            range.length = 0;
        } else {
            range = NSMakeRange(self.length, 0);
        }
        queryStr = [@"?" stringByAppendingString:queryStr];
    }
    
    return [self stringByReplacingCharactersInRange:range withString:queryStr];
}

+ (NSDictionary *)queryParamsFrom:(NSString *)route {
    NSRange endRange = [route rangeOfString:@"#"];
    if (endRange.location != NSNotFound) {
        route = [route substringToIndex:endRange.location];
    }
    NSRange firstRange = [route rangeOfString:@"?"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (firstRange.location != NSNotFound && route.length > firstRange.location + firstRange.length) {
        NSString *paramsString = [route substringFromIndex:firstRange.location + firstRange.length];
        NSArray *paramStringArr = [paramsString componentsSeparatedByString:@"&"];
        for (NSString *paramString in paramStringArr) {
            NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString *key = [paramArr objectAtIndex:0];
                NSString *value = [paramArr objectAtIndex:1];
                params[key] = value;
            }
        }
    }
    return [params copy];
}

@end
