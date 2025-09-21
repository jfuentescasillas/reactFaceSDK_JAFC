//
//  RFSDetectFacesBackendError.h
//  FaceSDK
//
//  Created by Serge Rylko on 23.08.24.
//  Copyright © 2024 Regula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FaceSDK/RFSBackendError.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const RFSDetectFacesBackendErrorDomain NS_SWIFT_NAME(DetectFacesBackendErrorDomain);

typedef NS_ERROR_ENUM(RFSDetectFacesBackendErrorDomain, RFSDetectFacesBackendErrorCode) {
    RFSDetectFacesBackendErrorFaceNotDetected = 2,
    // NOTE: General FaceService errors (aka `eFaceRProcessorErrorCodes`).
    RFSDetectFacesBackendErrorNotInitialized = 201,
    RFSDetectFacesBackendErrorCommandIsNotSupported = 202,
    RFSDetectFacesBackendErrorParamsReadError = 203,

    /// Service is missing a valid license file.
    RFSDetectFacesBackendErrorNoLicense = 200,
  
    RFSDetectFacesBackendErrorUndefined = -1,
} NS_SWIFT_NAME(DetectFacesBackendErrorCode);


NS_SWIFT_NAME(DetectFacesBackendError)
@interface RFSDetectFacesBackendError: RFSBackendError

@property (nonatomic, assign) RFSDetectFacesBackendErrorCode backendCode;

@end

NS_ASSUME_NONNULL_END
