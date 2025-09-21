//
//  RFSFaceSDK+Private.h
//  FaceSDK
//
//  Created by Serge Rylko on 17.05.23.
//  Copyright © 2023 Regula. All rights reserved.
//

#import <FaceSDK/FaceSDK.h>
#import <RegulaCommon/RegulaCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface RFSFaceSDK (Private)

- (void)setSessionManager:(RGLCURLSessionManager *)sessionManager;
- (void)notifyLivenessCameraChanged:(RFSCameraPosition)position;
- (void)notifyFaceCaptureCameraChanged:(RFSCameraPosition)position;

@end

NS_ASSUME_NONNULL_END
