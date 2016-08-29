//
//  LiveNetworkManager+UploadImg.m
//  GuoGuoLiveDev
//
//  Created by 韩乾坤 on 16/5/16.
//  Copyright © 2016年 统领得一网络科技（上海）有限公司. All rights reserved.
//

#import "UploadImageNetwork.h"

//图片上传预设信息
#define     BOUNDARY        @"f0fcb9e1-cfb9-4df6-8618-5b05f0126e62"             //边界标识   随机生成
#define     PREFIX          @"--"
#define     LINE_END        @"\r\n"
#define     CONTENT_TYPE    @"multipart/form-data"                              //内容类型
#define     CHARSET         @"utf-8"                                            //设置编码

typedef void (^ResponseSuccess)(NSString *reponseObject);
typedef void (^ResponseFailure)(NSError *error);

@interface UploadImageNetwork()

@property (strong, nonatomic)NSMutableData *responseData;
@property (assign, nonatomic)NSInteger responseCode;
@property (strong, nonatomic)ResponseFailure failureBlock;
@property (strong, nonatomic)ResponseSuccess successBlock;

@end

@implementation UploadImageNetwork

+(instancetype)shareInstance{
    return [[UploadImageNetwork alloc] init];
}

- (void)uploadImg:(NSData *)imgData
         fileName:(NSString *)fileName
          success:(void (^)(NSString *reponseObject))success
          failure:(void (^)(NSError *error))failure{
    
    fileName = fileName ? fileName : @"header.png";
    
    _failureBlock = [failure copy];
    _successBlock = [success copy];
    
    NSURL *url = [NSURL URLWithString:[UpLoadImgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    /*
        创建请求
            设置HTTPHeader头部信息
     */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [request setValue:CHARSET forHTTPHeaderField:@"Charset"];
    [request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    [request setValue:[NSString stringWithFormat:@"%@;boundary=%@",CONTENT_TYPE,BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    /*
        设置数据包头部信息
     */
    NSMutableString *headerParamString = @"".mutableCopy;
    [headerParamString appendString:PREFIX];
    [headerParamString appendString:BOUNDARY];
    [headerParamString appendString:LINE_END];
    [headerParamString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"img\"; filename=%@%@",fileName,LINE_END]];
    [headerParamString appendString:[NSString stringWithFormat:@"Content-Type: application/octet-stream; charset=%@%@",CHARSET,LINE_END]];
    [headerParamString appendString:LINE_END];
    NSData *headerdata = [headerParamString dataUsingEncoding:NSUTF8StringEncoding];
    
    /*
        设置数据包结尾信息
     */
    NSMutableString *footerParamString = @"".mutableCopy;
    [footerParamString appendString:LINE_END];
    [footerParamString appendString:[NSString stringWithFormat:@"%@%@%@%@",PREFIX,BOUNDARY,PREFIX,LINE_END]];
    NSData *footerdata = [footerParamString dataUsingEncoding:NSUTF8StringEncoding];
    
    /*
        数据拼包(图片数据包必须放到数据包的中间，否则无法解析)
     */
    NSMutableData *paramData = [[NSMutableData alloc] init];
    [paramData appendData:headerdata];
    [paramData appendData:imgData];
    [paramData appendData:footerdata];
    
    [request setHTTPBody:paramData];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// 服务器接收到请求时
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
    _responseCode = httpRes.statusCode;
}

// 服务器返回的数据时触发, 可能是资源片段多次调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _responseData = _responseData ? _responseData : [[NSMutableData alloc] init];
    [_responseData appendData:data];
}

// 数据返回完毕触发
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (_responseCode == 200 && _successBlock) {
        _successBlock([[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]);
    }
    else{
        if (_failureBlock) {
            _failureBlock([NSError errorWithDomain:connection.currentRequest.URL.absoluteString code:_responseCode userInfo:@{}]);
        }
    }
}

// 请求数据失败时触发
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (_failureBlock) {
        _failureBlock(error);
    }
}

@end
