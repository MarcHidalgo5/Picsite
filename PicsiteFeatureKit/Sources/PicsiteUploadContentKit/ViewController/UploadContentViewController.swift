//
//  Created by Marc Hidalgo on 14/5/23.
//

import UIKit
import PicsiteUI
import BSWInterfaceKit
import Photos

public class UploadContentViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
    enum Constants {
        static let TinySpacing: CGFloat = 8
        static let SmallSpacing: CGFloat = 12
        static let Spacing: CGFloat = 20
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "upload-content-navigation-title".localized
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mediaPicker = PicsiteMediaPickerBehavior()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.picsiteDeepBlueColor
        
        let photoUploadSection = SectionContainerView(PhotoUploadView())
        let picsiteUploadSection = SectionContainerView(PicsiteUploadView())
        
        photoUploadSection.view.onSelectUploadPhoto = { [weak self] in
            self?.onSelectPhoto()
        }
        
        picsiteUploadSection.view.onSelectCreatePicsite = { [weak self] in
            self?.onSelectCreatePicsite()
        }
        
        let stackView = UIStackView(arrangedSubviews: [picsiteUploadSection, photoUploadSection])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Constants.Spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addAutolayoutSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            picsiteUploadSection.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.width - 40),
            photoUploadSection.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.width - 40)
        ])
    }
    
    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .solid()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func onSelectPhoto() {
        Task { @MainActor in
            guard let imageData = await self.mediaPicker.getMedia(fromVC: self, kind: .photo, source: .photoAlbum), imageData.localURL != nil else { return }
            let vc = UploadPhotoConfirmationViewController(imageData: imageData)
            self.show(vc, sender: self)
        }
    }
    
    private func onSelectCreatePicsite() {
        let vc = UploadPicsiteMapViewController()
        let navVC = MinimalNavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    public class PhotoUploadView: UIStackView {
        var onSelectUploadPhoto: () -> () = { }
        
        public init() {
            super.init(frame: .zero)
            axis = .vertical
            alignment = .fill
            
            let uploadPhotoLabel: UILabel = {
                let label = UILabel()
                label.attributedText = FontPalette.mediumTextStyler.attributedString("upload-content-upload-photo-label".localized, color: ColorPalette.picsiteTitleColor, forSize: 16).settingLineSpacing(5)
                label.textAlignment = .center
                label.numberOfLines = 0
                return label
            }()
            
            let uploadPhotoButton: UIButton = {
                var configuration = UIButton.Configuration.filled()
                configuration.title = "upload-content-upload-photo-button".localized
                configuration.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
                configuration.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!)
                configuration.cornerStyle = .large
                let action = UIAction { action in
                    self.onSelectUploadPhoto()
                }
                return UIButton(configuration: configuration, primaryAction: action)
            }()
            
            uploadPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            spacing = Constants.SmallSpacing
            addArrangedSubview(uploadPhotoLabel)
            addArrangedSubview(uploadPhotoButton)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    public class PicsiteUploadView: UIStackView {
        
        var onSelectCreatePicsite: () -> () = { }
        
        public init() {
            super.init(frame: .zero)
            axis = .vertical
            alignment = .fill
            spacing = Constants.SmallSpacing
            
            let uploadPhotoLabel: UILabel = {
                let label = UILabel()
                label.attributedText = FontPalette.mediumTextStyler.attributedString("upload-content-upload-picsite-label".localized, color: ColorPalette.picsiteTitleColor, forSize: 16).settingLineSpacing(5)
                label.textAlignment = .center
                label.numberOfLines = 0
                return label
            }()
            
            let uploadPhotoButton: UIButton = {
                var configuration = UIButton.Configuration.filled()
                configuration.title = "upload-content-upload-picsite-button".localized
                configuration.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
                configuration.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!)
                configuration.cornerStyle = .large
                let action = UIAction { _ in
                    self.onSelectCreatePicsite()
                }
                return UIButton(configuration: configuration, primaryAction: action)
            }()
            uploadPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            spacing = Constants.SmallSpacing
            addArrangedSubview(uploadPhotoLabel)
            addArrangedSubview(uploadPhotoButton)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
