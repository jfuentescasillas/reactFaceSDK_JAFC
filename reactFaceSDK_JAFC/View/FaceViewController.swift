//
//  FaceViewController.swift
//  reactFaceSDK_JAFC
//
//  Created by jfuentescasillas on 21/09/2025.
//


import UIKit
import PhotosUI


public class FaceViewController: UIViewController {
    // MARK: - Properties
    private lazy var presenter = FacePresenter(view: self)

    // Image picker (reutilizable)
    private lazy var imagePicker = ImagePicker(presenter: self, delegate: self)

    // UI references
    private var capturedImageView: UIImageView!
    private var galleryImageView: UIImageView!
    private var resultLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!

    // Buttons
    private var captureButton: UIButton!
    private var chooseButton: UIButton!
    private var compareButton: UIButton!
    private var resetButton: UIButton!

    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Activity indicator
        let activity = UIActivityIndicatorView(style: .large)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        view.addSubview(activity)
        activityIndicator = activity

        // Left (captured) image view
        let leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.clipsToBounds = true
        leftImageView.layer.borderWidth = 1
        leftImageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.isUserInteractionEnabled = false
        view.addSubview(leftImageView)
        capturedImageView = leftImageView

        // Right (gallery) image view
        let rightImageView = UIImageView()
        rightImageView.contentMode = .scaleAspectFill
        rightImageView.clipsToBounds = true
        rightImageView.layer.borderWidth = 1
        rightImageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.isUserInteractionEnabled = false
        view.addSubview(rightImageView)
        galleryImageView = rightImageView

        // Result label
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl)
        resultLabel = lbl

        // Buttons
        let capBtn = UIButton(type: .system)
        capBtn.setTitle("Capture face", for: .normal)
        capBtn.addTarget(self, action: #selector(captureTapped), for: .touchUpInside)
        capBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(capBtn)
        captureButton = capBtn

        let chooseBtn = UIButton(type: .system)
        chooseBtn.setTitle("Select From Gallery", for: .normal)
        chooseBtn.addTarget(self, action: #selector(chooseTapped), for: .touchUpInside)
        chooseBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chooseBtn)
        chooseButton = chooseBtn

        let compareBtn = UIButton(type: .system)
        compareBtn.setTitle("Compare", for: .normal)
        compareBtn.addTarget(self, action: #selector(compareTapped), for: .touchUpInside)
        compareBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(compareBtn)
        compareButton = compareBtn

        let resetBtn = UIButton(type: .system)
        resetBtn.setTitle("Reset", for: .normal)
        resetBtn.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        resetBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetBtn)
        resetButton = resetBtn

        // Constraints
        NSLayoutConstraint.activate([
            // activity
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),

            // left image (captured)
            leftImageView.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 12),
            leftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            leftImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.42),
            leftImageView.heightAnchor.constraint(equalTo: leftImageView.widthAnchor),

            // right image (gallery)
            rightImageView.topAnchor.constraint(equalTo: leftImageView.topAnchor),
            rightImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rightImageView.widthAnchor.constraint(equalTo: leftImageView.widthAnchor),
            rightImageView.heightAnchor.constraint(equalTo: leftImageView.heightAnchor),

            // result label
            resultLabel.topAnchor.constraint(equalTo: leftImageView.bottomAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultLabel.heightAnchor.constraint(equalToConstant: 28),

            // buttons stack
            captureButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 16),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            chooseButton.topAnchor.constraint(equalTo: captureButton.bottomAnchor, constant: 12),
            chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            compareButton.topAnchor.constraint(equalTo: chooseButton.bottomAnchor, constant: 12),
            compareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            resetButton.topAnchor.constraint(equalTo: compareButton.bottomAnchor, constant: 12),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
        
    
    // MARK: - Actions
    @objc private func captureTapped() {
        presenter.didTapCapture()
    }
    

    @objc private func chooseTapped() {
        presenter.presentPicker(from: chooseButton)
    }

    
    @objc private func compareTapped() {
        presenter.didTapCompare()
    }

    
    @objc private func resetTapped() {
        presenter.didTapReset()
    }
    
    
    deinit {
        presenter.stop()
    }
}


// MARK: - Extension. FaceViewProtocol
extension FaceViewController: FaceViewProtocol {
public func showLoading(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if show {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            
            self.captureButton.isEnabled = !show
            self.chooseButton.isEnabled = !show
            self.compareButton.isEnabled = !show
            self.resetButton.isEnabled = !show
        }
    }
    
    
    public func showCapturedImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.capturedImageView.image = image
            
            // Make sure that left view is visible over the right one
            self.view.bringSubviewToFront(self.capturedImageView)
            
            // optional: remove background debug
            self.capturedImageView.backgroundColor = .clear
        }
    }
    
    
    public func showGalleryImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.galleryImageView.image = image
            self.view.bringSubviewToFront(self.galleryImageView)
            self.galleryImageView.backgroundColor = .clear
        }
    }
    
    
    public func showSimilarity(_ percentage: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.resultLabel.text = String(format: "Similarity: %.1f %%", percentage)
        }
    }
    
    
    public func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    
    public func resetUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.capturedImageView.image = nil
            self.galleryImageView.image = nil
            self.resultLabel.text = ""
        }
    }
    
    
    public func presentImagePicker(from sourceView: UIView?) {
        // Present ImagePicker action sheet (pop-over from button on iPad)
        imagePicker.presentPickerActions(from: sourceView)
    }
}


// MARK: - Extension. ImagePickerDelegate
extension FaceViewController: ImagePickerDelegate {
    public func didPickImage(delegate: ImagePicker, image: UIImage, sourceType: UIImagePickerController.SourceType) {
        presenter.didReceiveGalleryImage(image)
    }
}
