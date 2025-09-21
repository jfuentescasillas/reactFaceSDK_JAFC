//
//  RFSBackendError.h
//  FaceSDK
//
//  Created by Pavel Kondrashkov on 11/18/21.
//  Copyright © 2021 Regula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FaceSDK/RFSMacros.h>

NS_ASSUME_NONNULL_BEGIN

/// Key in userInfo for `RFSBackendErrorDomain`. Original message value of `RFSBackendErrorUndefined`. The value of this is a string.
FOUNDATION_EXPORT NSErrorUserInfoKey const RFSBackendErrorOriginalMessageKey NS_SWIFT_NAME(BackendError.OriginalMessageKey);

/// Key in userInfo for backend errors.
FOUNDATION_EXPORT NSErrorUserInfoKey const RFSBackendErrorOriginalCodeKey NS_SWIFT_NAME(BackendError.OriginalCodeKey);

NS_SWIFT_NAME(BackendError)
@interface RFSBackendError : NSError

+ (nullable instancetype)decodeFromJSON:(nonnull NSDictionary<NSString *, id> *)json;

+ (BOOL)hasErrorCode:(NSInteger)code;

+ (NSString *)domain;

RFS_EMPTY_INIT_UNAVAILABLE

@end

NS_ASSUME_NONNULL_END
