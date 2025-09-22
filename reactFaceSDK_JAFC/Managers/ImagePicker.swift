//
//  ImagePicker.swift
//  reactFaceSDK_JAFC
//
//  Created by jfuentescasillas on 21/09/2025.
//


import UIKit
import PhotosUI


// MARK: - Protocols
public protocol ImagePickerDelegate: AnyObject {
    func didPickImage(delegate: ImagePicker, image: UIImage, sourceType: UIImagePickerController.SourceType)
}


// MARK: - ImagePicker class
public class ImagePicker: NSObject, UINavigationControllerDelegate {
    private weak var presenter: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    
    public init(presenter: UIViewController, delegate: ImagePickerDelegate) {
        self.presenter = presenter
        self.delegate = delegate
       
        super.init()
    }
    

    public func presentPickerActions(from sourceView: UIView? = nil) {
        let alert = UIAlertController(title: "Choose a Photography from:", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.presentCamera()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Library", style: .default) { [weak self] _ in
            self?.presentPhotoLibrary()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // iPad popover handling
        if let pop = alert.popoverPresentationController, let sv = sourceView {
            pop.sourceView = sv
            pop.sourceRect = sv.bounds
        }
        
        presenter?.present(alert, animated: true)
    }
    
    
    private func presentCamera() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.modalPresentationStyle = .fullScreen
            
            self.presenter?.present(picker, animated: true)
        }
    }
    
    
    private func presentPhotoLibrary() {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .images
            config.selectionLimit = 1
           
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            
            presenter?.present(picker, animated: true)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
            
                self.presenter?.present(picker, animated: true)
            }
        }
    }
}


// MARK: - Extension. UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            delegate?.didPickImage(delegate: self, image: image, sourceType: picker.sourceType)
        }
    }
}


// MARK: - Extension. PHPickerViewControllerDelegate
@available(iOS 14, *)
extension ImagePicker: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let item = results.first else { return }
        
        if item.itemProvider.canLoadObject(ofClass: UIImage.self) {
            item.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (obj, err) in
                guard let self else { return }
                
                if let err {
                    print("ImagePicker: error loading image: \(err.localizedDescription)")
                    
                    return
                }
                
                guard let image = obj as? UIImage else { return }
                
                self.delegate?.didPickImage(delegate: self, image: image, sourceType: .photoLibrary)
            }
        }
    }
}
