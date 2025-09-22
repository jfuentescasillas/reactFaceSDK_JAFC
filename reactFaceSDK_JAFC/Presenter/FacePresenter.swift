//
//  FacePresenter.swift
//  reactFaceSDK_JAFC
//
//  Created by jfuentescasillas on 20/09/2025.
//


import UIKit


// MARK: - Protocols
// Presenter protocol
public protocol FacePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapCapture()
    func didReceiveGalleryImage(_ image: UIImage)
    func didTapCompare()
    func didTapReset()
}

 
// FaceView Protocol: conformed in ViewController
public protocol FaceViewProtocol: AnyObject {
    func showLoading(_ show: Bool)
    func showCapturedImage(_ image: UIImage)
    func showGalleryImage(_ image: UIImage)
    func showSimilarity(_ percentage: Double)
    func showError(_ message: String)
    func resetUI()
}


// MARK: - FacePresenter
public class FacePresenter: FacePresenterProtocol {
    public weak var view: FaceViewProtocol?
    private let sdk: FaceSDKServiceProtocol

    private var capturedImage: UIImage?
    private var galleryImage: UIImage?

    
    init(view: FaceViewProtocol, sdk: FaceSDKServiceProtocol = FaceSDKService()) {
        self.view = view
        self.sdk = sdk
    }
    

    public func viewDidLoad() {
        view?.showLoading(true)
       
        sdk.initializeSDK { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.view?.showLoading(false)
                
                switch result {
                case .success():
                    // Ready to use
                    break
                case .failure(let err):
                    self.view?.showError("SDK init failed: \(err.localizedDescription)")
                }
            }
        }
    }
    

    public func didTapCapture() {
        guard let vc = view as? UIViewController else {
            view?.showError("No view controller")
            
            return
        }
        
        view?.showLoading(true)
       
        sdk.presentFaceCapture(from: vc) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.view?.showLoading(false)
                
                switch result {
                case .success(let image):
                    self.capturedImage = image
                    
                    self.view?.showCapturedImage(image)
                case .failure(let err):
                    self.view?.showError("Capture failed: \(err)")
                }
            }
        }
    }
    

    public func didReceiveGalleryImage(_ image: UIImage) {
        galleryImage = image
        
        view?.showGalleryImage(image)
    }
    
    

    public func didTapCompare() {
        guard let img1 = capturedImage, let img2 = galleryImage else {
            view?.showError("Missing images to compare")
         
            return
        }
        
        view?.showLoading(true)
        
        sdk.compareFaces(img1, img2) { [weak self] result in
            guard let self else { return }
            
            self.view?.showLoading(false)
            
            switch result {
            case .success(let score):
                let percent = score * 100.0
                self.view?.showSimilarity(percent)
            case .failure(let err):
                self.view?.showError("Comparison failed: \(err)")
            }
        }
    }
    

    public func didTapReset() {
        capturedImage = nil
        galleryImage = nil
        
        view?.resetUI()
    }
    
    
    public func stop() {
        sdk.deinitializeSDK()
    }
}
