//
//  Created by Marc Hidalgo on 17/5/23.
//
import UIKit
import MapKit
import PicsiteUI; import PicsiteKit
import CoreLocation
import BSWInterfaceKit

public protocol UploadPhotoMapViewControllerDelegate: AnyObject {
    func didSelectPicsite(_ picsite: Picsite)
}
 
public class UploadPhotoMapViewController: BaseMapViewController {
    
    struct Constants {
        static let AnimationDuration = 0.3
        static let ButtonSize: CGFloat = 50
        static let ButtonMargin: CGFloat = 25
    }
    
    private let uploadPhotoTitleView = UploadPhotoTitleView()
    private let uploadPhotoButtonView = UploadPhotoButtonView()
    
    private let picsiteCheckView = RoundButtonView(imageButton: UIImage(systemName: "checkmark")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold)), color: ColorPalette.picsiteGreenColor)
    private let picsiteCancelView = RoundButtonView(imageButton: UIImage(systemName: "xmark")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold)), color: ColorPalette.picsiteErrorColor)
    
    let dataSource = ModuleDependencies.dataSource!

    weak var delegate: UploadPhotoMapViewControllerDelegate?
    
    public init(delegate: UploadPhotoMapViewControllerDelegate) {
        self.delegate = delegate
        super.init()
        addCloseButton(tintColorWhite: false)
        self.title = "upload-photo-map-title".localized
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        picsiteCheckView.alpha = 0
        picsiteCancelView.alpha = 0
        view.addAutolayoutSubview(picsiteCancelView)
        view.addAutolayoutSubview(picsiteCheckView)
        
        uploadPhotoButtonView.onSelectCreatePicsite = { [weak self]  in
            self?.createPicsiteSelected()
        }
        
        view.addAutolayoutSubview(uploadPhotoTitleView)
        view.addAutolayoutSubview(uploadPhotoButtonView)
        
        picsiteCheckView.onTapButton = { [weak self] in
            guard let self else { return }
            self.delegate?.didSelectPicsite(self.currentPicsiteSelected)
        }
        
        picsiteCancelView.onTapButton = { [weak self] in
            self?.deselectCurrentMapAnnotatons()
        }

        NSLayoutConstraint.activate([
            picsiteCheckView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.ButtonMargin / 2),
            picsiteCheckView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.ButtonMargin / 2),
            picsiteCheckView.widthAnchor.constraint(equalToConstant: Constants.ButtonSize),
            picsiteCheckView.heightAnchor.constraint(equalToConstant: Constants.ButtonSize),

            picsiteCancelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.ButtonMargin),
            picsiteCancelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.ButtonMargin),
            picsiteCancelView.widthAnchor.constraint(equalToConstant: Constants.ButtonMargin),
            picsiteCancelView.heightAnchor.constraint(equalToConstant: Constants.ButtonMargin),
            
            uploadPhotoTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            uploadPhotoTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uploadPhotoTitleView.topAnchor.constraint(equalTo: view.topAnchor),
            
            uploadPhotoButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            uploadPhotoButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uploadPhotoButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc func createPicsiteSelected() {
        let vc = UploadPicsiteMapViewController(mode: .withUploadPhoto)
        let navVC = MinimalNavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    override public func deselectCurrentMapAnnotatons() {
        super.deselectCurrentMapAnnotatons()
        UIView.animate(withDuration: Constants.AnimationDuration, animations: { [weak self] in
            self?.picsiteCheckView.alpha = 0
            self?.picsiteCancelView.alpha = 0
            self?.uploadPhotoButtonView.alpha = 1
            self?.uploadPhotoTitleView.alpha = 1
            self?.title = "upload-photo-map-title".localized
        })
    }
    
    override public func showAnnotationView() {
        super.showAnnotationView()
        UIView.animate(withDuration: Constants.AnimationDuration, animations: { [weak self] in
            self?.picsiteCheckView.alpha = 1
            self?.picsiteCancelView.alpha = 1
            self?.uploadPhotoButtonView.alpha = 0
            self?.uploadPhotoTitleView.alpha = 0
            self?.title = "upload-photo-map-second-title".localized
        })
    }
    
    public override var barStyle: TransparentNavigationBar.TintColorStyle {
        return .solid()
    }
    
    public override func fetchData() {
        performBlockingTask(loadingMessage: "map-fetch-data-loading".localized, errorMessage: "map-fetch-error-fetching".localized) {
            let vm = try await self.dataSource.fetchAnnotations()
            self.configureFor(viewModel: vm)
        }
    }
    
    public override func didTapOnAnnotation(currentAnnotation: PicsiteAnnotation) { }
    
    public override func configureFor(viewModel: BaseMapViewController.VM) {
        mapView.addAnnotations(viewModel.annotations)
    }
}

extension UploadPhotoMapViewController {
    private class UploadPhotoTitleView: UIView {
        
        enum Constants {
            static let SmallSpacing: CGFloat = 12
        }
                
        let uploadPhotoLabel: UILabel = {
            let label = UILabel()
            label.attributedText = FontPalette.mediumTextStyler.attributedString("upload-photo-map-select-picsite-section-title".localized, color: ColorPalette.picsiteTitleColor, forSize: 16).settingLineSpacing(5)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
                    
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = Constants.SmallSpacing
            stackView.addArrangedSubview(uploadPhotoLabel)
            
            let sectionContainer = SectionContainerView(stackView)
            addSubview(sectionContainer)
            sectionContainer.pinToSuperviewLayoutMargins()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private class UploadPhotoButtonView: UIView {
        
        enum Constants {
            static let SmallSpacing: CGFloat = 12
        }
        
        public var onSelectCreatePicsite: () -> () = { }
        
        let uploadPhotoLabel: UILabel = {
            let label = UILabel()
            label.attributedText = FontPalette.mediumTextStyler.attributedString("upload-photo-map-select-picsite-button-section-title".localized, color: ColorPalette.picsiteTitleColor, forSize: 16).settingLineSpacing(5)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        let createPicsiteButton: UIButton = {
            var configuration = UIButton.Configuration.filled()
            configuration.title = "upload-content-upload-picsite-button".localized
            configuration.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
            configuration.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!)
            configuration.cornerStyle = .large
            return UIButton(configuration: configuration)
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
                    
            createPicsiteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = Constants.SmallSpacing
            stackView.addArrangedSubview(uploadPhotoLabel)
            stackView.addArrangedSubview(createPicsiteButton)
            
            let sectionContainer = SectionContainerView(stackView)
            addSubview(sectionContainer)
            sectionContainer.pinToSuperviewLayoutMargins()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc func buttonPressed() {
            onSelectCreatePicsite()
        }
    }
}
