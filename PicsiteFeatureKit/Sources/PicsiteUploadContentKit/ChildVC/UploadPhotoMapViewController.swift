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

        picsiteCheckView.onTapButton = { [weak self] in
            guard let self else { return }
            self.delegate?.didSelectPicsite(self.currentPicsiteSelected)
        }
        
        picsiteCancelView.onTapButton = { [weak self] in
            self?.deselectCurrentMapAnnotatons()
        }
        
        picsiteCheckView.translatesAutoresizingMaskIntoConstraints = false
        picsiteCancelView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            picsiteCheckView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.ButtonMargin),
            picsiteCheckView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.ButtonMargin),
            picsiteCheckView.widthAnchor.constraint(equalToConstant: Constants.ButtonMargin),
            picsiteCheckView.heightAnchor.constraint(equalToConstant: Constants.ButtonMargin),

            picsiteCancelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.ButtonMargin),
            picsiteCancelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.ButtonMargin),
            picsiteCancelView.widthAnchor.constraint(equalToConstant: Constants.ButtonMargin),
            picsiteCancelView.heightAnchor.constraint(equalToConstant: Constants.ButtonMargin)
        ])
    }

    
    override public func deselectCurrentMapAnnotatons() {
        super.deselectCurrentMapAnnotatons()
        UIView.animate(withDuration: Constants.AnimationDuration, animations: { [weak self] in
            self?.picsiteCheckView.alpha = 0
            self?.picsiteCancelView.alpha = 0
            self?.title = "upload-photo-map-title".localized
        })
    }
    
    override public func showAnnotationView() {
        super.showAnnotationView()
        UIView.animate(withDuration: Constants.AnimationDuration, animations: { [weak self] in
            self?.picsiteCheckView.alpha = 1
            self?.picsiteCancelView.alpha = 1
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





