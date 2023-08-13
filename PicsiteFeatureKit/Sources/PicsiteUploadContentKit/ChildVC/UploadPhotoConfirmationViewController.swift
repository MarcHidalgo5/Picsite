//
//  Created by Marc Hidalgo on 16/5/23.
//

import UIKit
import PicsiteUI
import BSWInterfaceKit
import PicsiteKit
import CoreLocation

class UploadPhotoConfirmationViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
    private var selectedPhoto: Photo
    private let imageData: PicsiteMediaPickerBehavior.ImageData
    
    private var nextButton: UIButton!
    private let confirmButtonView = ConfirmButtonView()
    
    private var currentPicsiteSelected: Picsite? {
        didSet {
            if let title = currentPicsiteSelected?.title {
                nextButton.isEnabled = true
                confirmButtonView.configureFor(title: title)
            } else {
                nextButton.isEnabled = false
            }
        }
    }
    
    private let dataSource = ModuleDependencies.dataSource!

    private lazy var scrollableStackView: ScrollableStackView = {
        let stackView = ScrollableStackView(axis: .vertical, alignment: .fill)
        stackView.spacing = 10
        stackView.layoutMargins = .init(uniform: 10)
        return stackView
    }()

    private lazy var imageViewContainer: UIView = {
        let view = UIView()
        view.addCustomShadow()
        view.addAutolayoutSubview(imageView)
        imageView.pinToSuperview()
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.roundCorners(radius: 12)
        return imageView
    }()
     
    
    init(imageData: PicsiteMediaPickerBehavior.ImageData) {
        self.imageData = imageData
        self.selectedPhoto = Photo(url: imageData.localURL)
             super.init(nibName: nil, bundle: nil)
        addPlainBackButton(tintColorWhite: false)
        self.title = "upload-photo-confirmation-navigation-title".localized
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.picsiteBackgroundColor
        
        nextButton = {
            var configuration = UIButton.Configuration.filled()
            configuration.title = "upload-photo-confirmation-upload-photo-button".localized
            configuration.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!, size: 16)
            configuration.cornerStyle = .large
            let action = UIAction { [weak self] _ in
                guard let self, let picsiteID = self.currentPicsiteSelected?.id, let localImageURL = self.imageData.localURL else { return }
                performBlockingTask(loadingMessage: "upload-photo-confirmation-loading-message".localized) {
                    do {
                        try await self.dataSource.uploadImageToFirebaseStorage(with: localImageURL, into: picsiteID)
                        NotificationCenter.default.post(name: UploadContentNotification, object: nil)
                        self.closeViewController(sender: nil)
                    } catch {
                        self.showErrorAlert("error".localized, error: error)
                    }
                }
            }
            let button = UIButton(configuration: configuration, primaryAction: action)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return button
        }()
        
        nextButton.isEnabled = currentPicsiteSelected != nil
        
        nextButton.configurationUpdateHandler = { button in
            if button.state.contains(.disabled) {
                button.configuration?.baseBackgroundColor = .gray.withAlphaComponent(0.2)
                button.configuration?.baseForegroundColor = ColorPalette.picsiteTitleColor
            } else {
                button.configuration?.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
                button.configuration?.baseForegroundColor = .white
            }
        }

        imageView.setPhoto(selectedPhoto)
        nextButton.addCustomPicsiteShadow()
        nextButton.roundCorners(radius: 12)
        
        confirmButtonView.selectPicsite = { [weak self] in
            guard let self else { return }
            let vc = UploadPhotoMapViewController(delegate: self)
            let navVC = MinimalNavigationController(rootViewController: vc)
            self.present(navVC, animated: true)
        }
        
        scrollableStackView.addArrangedSubview(imageViewContainer)
        scrollableStackView.addArrangedSubview(confirmButtonView)
        scrollableStackView.addArrangedSubview(nextButton)
        
        view.addAutolayoutSubview(scrollableStackView)
        
        NSLayoutConstraint.activate([
            scrollableStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: -10),
            scrollableStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollableStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            imageViewContainer.heightAnchor.constraint(equalToConstant: 355),
        ])
        
        fetchData()
    }

    func fetchData() {
        fetchData {
            try await self.dataSource.getClosestPicsite(to: self.imageData.location)
        } completion: { [weak self] vm in
            self?.configureFor(picsite: vm)
        }
    }
    
    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparent
    }
    
    public func configureFor(picsite: Picsite?) {
        guard let picsite else { return }
        self.confirmButtonView.configureFor(title: picsite.title)
        self.currentPicsiteSelected = picsite
    }
    
    public class ConfirmButtonView: UIStackView {
        
        var selectPicsite: (() -> ())?
        
        var confirmButton: UIButton!
        
        let picsiteLabel: UILabel = {
            let label = UILabel()
            label.attributedText = FontPalette.mediumTextStyler.attributedString("upload-photo-confirmation-select-place-title".localized, color: ColorPalette.picsiteTitleColor, forSize: 16).settingLineSpacing(5)
            label.numberOfLines = 2
            label.textAlignment = .center
            return label
        }()
        
        public init() {
            super.init(frame: .zero)
            axis = .vertical
            alignment = .fill
            spacing = 10
            backgroundColor = ColorPalette.picsiteBackgroundColor
            addPicsiteShadow()
            roundCorners(radius: 12)
            layoutMargins = .init(uniform: 10)
            isLayoutMarginsRelativeArrangement = true
            
            confirmButton = {
                var configuration = UIButton.Configuration.filled()
                configuration.title = "upload-photo-confirmation-select-place-button".localized
                configuration.baseForegroundColor = .white
                configuration.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
                configuration.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!, size: 16)
                configuration.cornerStyle = .large
                let image = UIImage(systemName: "chevron.down")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold))
                configuration.image = image
                configuration.imagePadding = 5
                configuration.imagePlacement = .trailing
                let action = UIAction { [weak self] _ in
                    self?.selectPicsite?()
                }
                return UIButton(configuration: configuration, primaryAction: action)
            }()
            confirmButton.backgroundColor = .clear
            confirmButton.translatesAutoresizingMaskIntoConstraints = false
            confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            addArrangedSubview(picsiteLabel)
            addArrangedSubview(confirmButton)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func configureFor(title: String) {
            confirmButton.configuration?.title = title
            confirmButton.configuration?.baseForegroundColor = ColorPalette.picsiteDeepBlueColor
            confirmButton.configuration?.baseBackgroundColor = .clear
        }
    }
}

extension UploadPhotoConfirmationViewController: UploadPhotoMapViewControllerDelegate {
    func didSelectPicsite(_ picsite: Picsite) {
        self.dismiss(animated: true) {
            self.currentPicsiteSelected = picsite
        }
    }
}
