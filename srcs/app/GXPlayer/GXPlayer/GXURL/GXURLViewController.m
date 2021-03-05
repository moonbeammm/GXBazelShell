//
//  GXURLViewController.m
//  _idx_gxplayer_library_064C0109_ios_min9.0
//
//  Created by sgx on 2021/3/5.
//

#import "GXURLViewController.h"
#import "NSString/NSString+URL.h"

@interface GXURLViewController ()

@end

@implementation GXURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
//    NSString *url = @"/av/ugc/?spmid=ugcdetail&from=relate";
//    [self testUrl:url];
//
//    NSString *url1 = @"/av/ugc/?spmid=&from=relate";
//    [self testUrl:url1];
    
//    NSString *url2 = @"/av/ugc/?from=relate";
//    [self testUrl:url2];
    
    [self testUrl];
}

- (void)testUrl:(NSString *)url {
    NSLog(@"%@",url);
    NSDictionary *params = [NSString queryParamsFrom:url];
    if (!params[@"spmid"]) {
        url = [url bfc_appendParamsWithDictionary:@{@"spmid":@"ogvdetail"}];
    }
    if (!params[@"from"]) {
        url = [url bfc_appendParamsWithDictionary:@{@"from":@"ogvrelate"}];
    }
    NSLog(@"%@-url:%@",params,url);
}

- (void)testUrl {
    
    NSDictionary *params = @{
        @"spmid":@(1),
        @"from":[NSNull null]
    };
    
    id value = params[@"spmid"];
    id value1 = params[@"from"];
    
    NSLog(@"%@--%@\n%@-%@",value,value1,NSStringFromClass([value class]),NSStringFromClass([value1 class]));
    
    {
//        NSString *urll = value;
//        NSString *urll1 = value1;
        
        //    if (urll && urll.length > 0) { // reason: '-[__NSCFNumber length]: unrecognized selector sent to instance 0xbfd03ffeb66033f0'
        //        NSLog(@"");
        //    }
        
//        if (urll1 && urll1.length > 0) { // reason: '-[NSNull length]: unrecognized selector sent to instance 0x10edcaf40'
//            NSLog(@"");
//        }
        
        
//        if (urll1) {
//            NSInteger length = urll1.length; // reason: '-[NSNull length]: unrecognized selector sent to instance 0x1037c8f40'
//            NSLog(@"%@",@(length));
//        }
    }
    
    {
        //    NSString *urlll = [value stringValue];
        //    NSString *urlll1 = [value1 stringValue]; // 这里会崩reason: '-[NSNull stringValue]: unrecognized selector sent to instance 0x110067f40'
        //
        //    if (urlll && urlll.length > 0) {
        //        NSLog(@"");
        //    }
        //
        //    if (urlll1 && urlll1.length > 0) {
        //        NSLog(@"");
        //    }
    }
    {
//    NSString *url = @"";
//    if (!params[@"spmid"] && [params[@"spmid"] stringValue].length <= 0) {
//        url = [url bfc_appendParamsWithDictionary:@{@"spmid":@"ogvdetail"}];
//    }
//    if (!params[@"from"] && [params[@"from"] stringValue].length <= 0) {
//        url = [url bfc_appendParamsWithDictionary:@{@"from":@"ogvrelate"}];
//    }
//    NSLog(@"%@-url:%@",params,url);
    }
    
    {
//        if (!params[@"from"]) { // NSNull是有值的，不是空。
//            NSInteger length = [params[@"from"] stringValue].length;
//            NSLog(@"%@",@(length));
//        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
