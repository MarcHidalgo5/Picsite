//
//  Created by Marc Hidalgo on 24/5/23.
//

import UIKit
import PicsiteUI; import PicsiteKit
import BSWInterfaceKit
import CoreLocation

class UploadPicsiteConfirmationViewController: UIViewController, UITextFieldDelegate{
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = ColorPalette.picsiteLightGray
        imageView.tintColor = .white
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = ColorPalette.picsiteTitleColor
        return label
    }()
    
    private lazy var scrollableStackView: ScrollableStackView = {
        let stackView = ScrollableStackView(axis: .vertical, alignment: .fill)
        stackView.spacing = 10
        stackView.layoutMargins = .init(uniform: 16)
        return stackView
    }()
    
    let titleTextField = TitleTextField(
        kind: .custom(
            returnKeyType: .done,
            textContentType: .name,
            keyboardType: .asciiCapable,
            autocapitalizationType: .none,
            title: FontPalette.boldTextStyler.attributedString("upload-picsite-confirmation-title-text-field-picsite-name".localized, color: ColorPalette.picsiteTitleColor, forSize: 14)
        )
    )
    
    private var nextButton: UIButton!
    
    private let mediaPicker = PicsiteMediaPickerBehavior()
    private let dataSource = ModuleDependencies.dataSource!
    private let location: CLLocation!
    private var localImageURL: URL?
    
    let mode: UploadNewPicsiteMode
    
    let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
    
    init(location: CLLocation, mode: UploadNewPicsiteMode) {
        self.location = location
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        addPlainBackButton(tintColorWhite: false)
        self.title = "upload-picsite-confirmation-navigation-title".localized
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView()
        view.backgroundColor = ColorPalette.picsiteBackgroundColor
        
        titleTextField.textField.delegate = self
        
        titleLabel.attributedText = FontPalette.boldTextStyler.attributedString("upload-picsite-confirmation-select-profile-photo-title".localized, forSize: 14)
        
        let image = UIImage(systemName: "plus")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .bold))
        imageView.image = image
        
        imageView.roundCorners(radius: 12)
        
        nextButton = {
            var configuration = UIButton.Configuration.filled()
            configuration.title = "upload-picsite-confirmation-upload-picsite-button".localized
            configuration.setFont(fontDescriptor: FontPalette.boldTextStyler.fontDescriptor!, size: 16)
            configuration.cornerStyle = .large
            let action = UIAction { [weak self] _ in
                self?.onSelectUpload()
            }
            
            let button = UIButton(configuration: configuration, primaryAction: action)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return button
        }()
        
        nextButton.isEnabled = false
        
        nextButton.configurationUpdateHandler = { button in
            if button.state.contains(.disabled) {
                button.configuration?.baseBackgroundColor = .gray.withAlphaComponent(0.2)
                button.configuration?.baseForegroundColor = ColorPalette.picsiteTitleColor
            } else {
                button.configuration?.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
                button.configuration?.baseForegroundColor = .white
            }
        }
        
        nextButton.addCustomPicsiteShadow()
        nextButton.roundCorners(radius: 12)
        
        scrollableStackView.addArrangedSubview(titleLabel)
        scrollableStackView.addArrangedSubview(imageView)
        scrollableStackView.addArrangedSubview(titleTextField)
        scrollableStackView.addArrangedSubview(nextButton)
        
        scrollableStackView.keyboardDismissMode = .onDrag
        
        view.addAutolayoutSubview(scrollableStackView)
        
        NSLayoutConstraint.activate([
            scrollableStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: -10),
            scrollableStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollableStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.textField.becomeFirstResponder()
    }
    
    //MARK: Private
    
    private func onSelectUpload() {
        Task {
            try await uploadTask()
            self.dismiss(animated: true)
        }
    }
    
    private func uploadTask() async throws {
        guard let text = self.titleTextField.text else { return }
        performBlockingTask(loadingMessage: "upload-picsite-confirmation-loading-message".localized, successMessage: "upload-picsite-map-create-picsite-success".localized) { [weak self] in
            guard let self = self else { return }
            _ = try await self.dataSource.uploadNewPicsite(title: text, location: self.location, localImageURL: self.localImageURL)
            try await Task.sleep(nanoseconds: 1_500_000_000)
            NotificationCenter.default.post(name: UploadContentNotification, object: nil)
        }
    }
    
    //MARK: Objc
    
    @objc func imageTapped() {
        Task { @MainActor in
            guard let imageData = await self.mediaPicker.getMedia(fromVC: self, kind: .photo, source: .photoAlbum), imageData.localURL != nil else { return }
            imageView.contentMode = .scaleAspectFill
            imageView.setPhoto(Photo(url: imageData.localURL))
            self.localImageURL = imageData.localURL
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !textField.isTextFieldValid {
            self.nextButton.isEnabled = false
            animator.addAnimations {
                self.titleTextField.showErrorMessage(message: FontPalette.mediumTextStyler.attributedString("upload-picsite-confirmation-title-text-field-picsite-error".localized, color: ColorPalette.picsiteErrorColor, forSize: 14))
            }
            animator.startAnimation()
        } else {
            self.nextButton.isEnabled = true
            animator.addAnimations {
                self.titleTextField.showErrorMessage(message: nil)
            }
            animator.startAnimation()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.textField.resignFirstResponder()
        return true
    }
}

private extension UITextField {
    var isTextFieldValid: Bool {
         guard let text = self.text, text.count > 0 else { return false }
        return true
    }
}
