//
//  RFSMatchFacesBackendError.h
//  FaceSDK
//
//  Created by Serge Rylko on 28.08.24.
//  Copyright © 2024 Regula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FaceSDK/RFSBackendError.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const RFSMatchFacesBackendErrorDomain NS_SWIFT_NAME(MatchFacesBackendErrorDomain);

typedef NS_ERROR_ENUM(RFSMatchFacesBackendErrorDomain, RFSMatchFacesBackendErrorCode) {
    // NOTE: General FaceService errors (aka `eFaceRecognizerErrorCode`)
    RFSMatchFacesBackendErrorImageEmpty = 1,
    RFSMatchFacesBackendErrorFaceNotDetected = 2,
    RFSMatchFacesBackendErrorLandmarksNotDetected = 3,
    RFSMatchFacesBackendErrorFaceAlignerFailed = 4,
    RFSMatchFacesBackendErrorDescriptorExtractorError = 5,
    RFSMatchFacesBackendErrorImageDecodeError = 6,
    RFSMatchFacesBackendErrorInternalError = 7,

    // NOTE: General FaceService errors (aka `eFaceRProcessorErrorCodes`)
    RFSMatchFacesBackendErrorNoLicense = 200,
    RFSMatchFacesBackendErrorNotInitialized = 201,
    RFSMatchFacesBackendErrorCommandIsNotSupported = 202,
    RFSMatchFacesBackendErrorParamsReadError = 203,
    RFSMatchFacesBackendErrorImagesCountLimitExceeded = 238,

    RFSMatchFacesBackendErrorUndefined = -1,
} NS_SWIFT_NAME(MatchFacesBackendErrorCode);

NS_SWIFT_NAME(MatchFacesBackendError)
@interface RFSMatchFacesBackendError: RFSBackendError

@property (nonatomic, assign) RFSMatchFacesBackendErrorCode backendCode;

@end

NS_ASSUME_NONNULL_END
