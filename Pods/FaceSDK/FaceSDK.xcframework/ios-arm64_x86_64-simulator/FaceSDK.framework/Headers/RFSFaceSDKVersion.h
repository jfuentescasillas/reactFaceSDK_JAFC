//
//  RFSFaceSDKVersion.h
//  FaceSDK
//
//  Created by Dmitry Evglevsky on 18.05.24.
//  Copyright © 2024 Regula. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RFSFaceSDKVersion : NSObject

/// Version of the API module.
@property(nonatomic, readonly, strong, nullable) NSString *api;
/// Version of the CORE module.
@property(nonatomic, readonly, strong, nullable) NSString *core;
/// CORE module variant.
@property(nonatomic, readonly, strong, nullable) NSString *coreMode;

@end

NS_ASSUME_NONNULL_END
