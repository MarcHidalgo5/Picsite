//
//  Created by Marc Hidalgo on 16/5/23.
//

import UIKit
import PicsiteUI
import BSWInterfaceKit
import PicsiteKit

extension UIView {
    public func addCustomShadow() {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2
    }
}

class UploadPhotoConfirmationViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
    private var selectedPhoto: Photo
    private var localImageURL: URL
    
    private var currentPicsiteIDselected: Picsite.ID?
    
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
     
    init(localImageURL: URL) {
        self.selectedPhoto = Photo(url: localImageURL)
        self.localImageURL = localImageURL
        super.init(nibName: nil, bundle: nil)
        addPlainBackButton(tintColorWhite: false)
        self.title = "Foto Seleccionada"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.picsiteBackgroundColor
        
        let nextButton: UIButton = {
            var configuration = UIButton.Configuration.filled()
            configuration.title = "Subir foto"
            configuration.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
            configuration.setFont(fontDescriptor: FontPalette.boldTextStyler.fontDescriptor!, size: 16, foregroundColor: ColorPalette.picsiteSecondaryTitleColor)
            configuration.cornerStyle = .large
            let action = UIAction { [weak self] _ in
                guard let self, let picsiteID = self.currentPicsiteIDselected else { return }
                Task {
                    do {
                        try await self.dataSource.uploadImageToFirebaseStorage(with: self.localImageURL, into: picsiteID)
                    } catch {
                        self.showErrorAlert("error".localized, error: error)
                    }
                }
            }
            let button = UIButton(configuration: configuration, primaryAction: action)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return button
        }()
        
        imageView.setPhoto(selectedPhoto)
        nextButton.addCustomVideoAskShadow()
        
        let confirmButtonView = ConfirmButtonView()
        confirmButtonView.selectPicsite = {
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
    }

    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparent
    }
    
    public class ConfirmButtonView: UIStackView {
        
        var selectPicsite: (() -> ())?
        
        let picsiteLabel: UILabel = {
            let label = UILabel()
            label.attributedText = FontPalette.mediumTextStyler.attributedString("Selecciona el lugar donde pertenece esta fotografia:", color: ColorPalette.picsiteTitleColor, forSize: 16)
            label.numberOfLines = 2
            label.textAlignment = .center
            return label
        }()
        
        public init() {
            super.init(frame: .zero)
            axis = .vertical
            alignment = .fill
            spacing = 5
            backgroundColor = ColorPalette.picsiteBackgroundColor
            addPicsiteShadow()
            roundCorners(radius: 12)
            layoutMargins = .init(uniform: 10)
            isLayoutMarginsRelativeArrangement = true
            
            let confirmButton: UIButton = {
                var configuration = UIButton.Configuration.plain()
                configuration.title = "La seu vella"
                configuration.baseForegroundColor = ColorPalette.picsiteDeepBlueColor
                configuration.setFont(fontDescriptor: FontPalette.boldTextStyler.fontDescriptor!, size: 16)
                configuration.cornerStyle = .large
                let image = UIImage(systemName: "chevron.right")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold))
                configuration.image = image
                configuration.imagePadding = 5
                configuration.imagePlacement = .trailing
                let action = UIAction { [weak self] _ in
                    self?.selectPicsite?()
                }
                return UIButton(configuration: configuration, primaryAction: action)
            }()
            confirmButton.backgroundColor = .clear
            
            addArrangedSubview(picsiteLabel)
            addArrangedSubview(confirmButton)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension UploadPhotoConfirmationViewController: UploadPhotoMapViewControllerDelegate {
    func didSelectPicsite(id: Picsite.ID) {
        self.dismiss(animated: true) {
            self.currentPicsiteIDselected = id
        }
    }
}
