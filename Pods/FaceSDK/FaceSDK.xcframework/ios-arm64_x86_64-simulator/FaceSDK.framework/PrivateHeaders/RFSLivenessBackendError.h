//
//  RFSLivenessBackendError.h
//  FaceSDK
//
//  Created by Serge Rylko on 23.08.24.
//  Copyright © 2024 Regula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FaceSDK/RFSBackendError.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const RFSLivenessBackendErrorDomain NS_SWIFT_NAME(LivenessBackendErrorDomain);
typedef NS_ERROR_ENUM(RFSLivenessBackendErrorDomain, RFSLivenessBackendErrorCode) {
    // eFaceRProcessorErrorCodes
    RFSLivenessBackendErrorNoLicense = 200,
    RFSLivenessBackendErrorNotInitialized = 201,
    RFSLivenessBackendErrorCommandIsNotSupported = 202,
    RFSLivenessBackendErrorParamsReadError = 203,
    RFSLivenessBackendErrorClosedEyesDetected = 230,
    RFSLivenessBackendErrorLowQuality = 231,
    RFSLivenessBackendErrorHighAsymmetry = 232,
    RFSLivenessBackendErrorFaceOverEmotional = 233,
    RFSLivenessBackendErrorSunglassesDetected = 234,
    RFSLivenessBackendErrorSmallAge = 235,
    RFSLivenessBackendErrorHeaddressDetected = 236,
    RFSLivenessBackendErrorFacesNotMatched = 237,
    RFSLivenessBackendErrorImagesCountLimitExceeded = 238,
    RFSLivenessBackendErrorMedicineMaskDetected = 239,
    RFSLivenessBackendErrorOcclusionDetected = 240,
    RFSLivenessBackendErrorForeheadGlassesDetected = 242,
    RFSLivenessBackendErrorMouthOpened = 243,
    RFSLivenessBackendErrorArtMaskDetected = 244,
    RFSLivenessBackendErrorElectronicDeviceDetected = 245,
    RFSLivenessBackendErrorTrackBreak = 246,
    RFSLivenessBackendErrorWrongGeo = 247,
    RFSLivenessBackendErrorWrongOf = 248,
    RFSLivenessBackendErrorWrongView = 249,
    RFSLivenessBackendErrorTimeoutLivenessTransaction = 250,
    RFSLivenessBackendErrorFailedLivenessTransaction = 251,
    RFSLivenessBackendErrorAbortedLivenessTransaction = 252,
    RFSLivenessBackendErrorGeneralCheckFail = 253,
    RFSLivenessBackendErrorPassiveLivenessFail = 254,
    RFSLivenessBackendErrorPrintedFaceDetected = 255,
    RFSLivenessBackendErrorBlockedRequest = 256,
    RFSLivenessBackendErrorCorruptedRequest = 257,
    
    RFSLivenessBackendErrorUndefined = -1,
} NS_SWIFT_NAME(LivenessBackendErrorCode);

NS_SWIFT_NAME(LivenessBackendError)
@interface RFSLivenessBackendError: RFSBackendError

@property (nonatomic, assign) RFSLivenessBackendErrorCode backendCode;

@end

NS_ASSUME_NONNULL_END
