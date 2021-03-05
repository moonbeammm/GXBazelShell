//
//  NSString+URL.h
//  _idx_home_library_04B41827_ios_min9.0
//
//  Created by sgx on 2021/3/5.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (BOOL)bfc_isWebUrl;
- (BOOL)bfc_isBiliUrl;
- (BOOL)bfc_isDirectOpenUrl;

/**
 校验string是否为有效URL
 
 @return YES为有效URL；NO为无效URL
 */
- (BOOL)bfc_isValidUrl;

/**
 对String进行单个参数拼接，遵循URL path规范
 eg: path?key=value#fragment
 
 @param key key不允许为空
 @param value value不允许为空
 @return 返回拼接参数后的链接
 */
- (NSString *_Nonnull)bfc_appendParamsWithKey:(NSString *_Nonnull)key value:(NSString *_Nonnull)value;

/**
 对String进行多个参数拼接，遵循URL path规范 (内部不做任何编码转换)
 eg: path?key=value#fragment
 
 @param queryDict 参数字典，key和value不允许为空
 @return 返回拼接参数后的链接
 */
- (NSString *_Nonnull)bfc_appendParamsWithDictionary:(NSDictionary<NSString*, NSString*> *_Nonnull)queryDict;

+ (NSDictionary *)queryParamsFrom:(NSString *)route;

@end
