//
//  FaceSDKService.swift
//  reactFaceSDK_JAFC
//
//  Created by jfuentescasillas on 20/09/2025.
//


import UIKit
import FaceSDK


// MARK: - FaceSDKError enum
public enum FaceSDKError: Error {
    case notInitialized
    case captureFailed(String)
    case comparisonFailed(String)
}


// MARK: - Protocols
public protocol FaceSDKServiceProtocol {
    func initializeSDK(completion: @escaping (Result<Void, Error>) -> Void)
    func deinitializeSDK()
    func presentFaceCapture(from viewController: UIViewController, completion: @escaping (Result<UIImage, FaceSDKError>) -> Void)
    func compareFaces(_ img1: UIImage, _ img2: UIImage, completion: @escaping (Result<Double, FaceSDKError>) -> Void)
}


// MARK: - FaceSDKService class
public class FaceSDKService: FaceSDKServiceProtocol {
    private var initialized: Bool = false

    
    public init() {}

    
    // Initialize SDK (completion always returned on main thread)
    public func initializeSDK(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                _ = try await FaceSDK.service.initialize()
                
                initialized = true
               
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    
    // Deinitialize (main thread) with small log and guard
    public func deinitializeSDK() {
        if initialized || FaceSDK.service.isInitialized {
            DispatchQueue.main.async {
                print("FaceSDKService: deinitializing FaceSDK")
                FaceSDK.service.deinitialize()
            }
            
            initialized = false
        }
    }
    

    // Present capture — ensure presentation on main thread
    public func presentFaceCapture(from viewController: UIViewController, completion: @escaping (Result<UIImage, FaceSDKError>) -> Void) {
        guard initialized else {
            DispatchQueue.main.async { completion(.failure(.notInitialized)) }
           
            return
        }

        let config = FaceCaptureConfiguration {
            $0.cameraPosition = .front
            $0.isCameraSwitchButtonEnabled = true
        }

        DispatchQueue.main.async { // present UI on main
            FaceSDK.service.presentFaceCaptureViewController(
                from: viewController,
                animated: true,
                configuration: config,
                onCapture: { response in
                    if let error = response.error {
                        completion(.failure(.captureFailed(error.localizedDescription)))
                       
                        return
                    }

                    if let imgWrapper = response.image {
                        completion(.success(imgWrapper.image))
                    } else {
                        completion(.failure(.captureFailed("No image in response")))
                    }
                },
                completion: {
                    // finished presenting
                }
            )
        }
    }

    // Compare faces — run heavy work in background, completion on main; defensive single-call
    public func compareFaces(_ img1: UIImage, _ img2: UIImage, completion: @escaping (Result<Double, FaceSDKError>) -> Void) {
        guard initialized else {
            DispatchQueue.main.async { completion(.failure(.notInitialized)) }
            
            return
        }

        let first = MatchFacesImage(image: img1, imageType: .printed)
        let second = MatchFacesImage(image: img2, imageType: .printed)
        let request = MatchFacesRequest(images: [first, second])

        let outputImageParams = OutputImageParams()
        outputImageParams.crop = .init(type: .ratio3x4)
        outputImageParams.backgroundColor = .white
        request.outputImageParams = outputImageParams

        // Prevent UI blocking by executing on background queue
        DispatchQueue.global(qos: .userInitiated).async {
            // defensive flag to ensure completion called once
            var completionCalled: Bool = false
            
            FaceSDK.service.matchFaces(request, completion: { response in
                // Return to main for completion callback to UI
                DispatchQueue.main.async {
                    guard !completionCalled else { return }
                    
                    completionCalled = true

                    if let err = response.error {
                        completion(.failure(.comparisonFailed(err.localizedDescription)))
                        
                        return
                    }

                    guard let firstPair = response.results.first else {
                        completion(.failure(.comparisonFailed("No matched pair found")))
                    
                        return
                    }

                    let similarityValue = firstPair.similarity?.doubleValue ?? firstPair.score?.doubleValue ?? 0.0
                    completion(.success(similarityValue))
                }
            })
        }
    }
}
