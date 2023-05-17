//
//  Created by Marc Hidalgo on 17/5/23.
//
import UIKit
import MapKit
import PicsiteUI; import PicsiteKit
import CoreLocation
import BSWInterfaceKit

public class UploadPhotoMapViewController: BaseMapViewController {
    
    let dataSource = ModuleDependencies.dataSource!
    
    private let picsiteCheckView = RoundCheckButtonView()
    private let picsiteCancelView = RoundCancelButtonView()
    
    override public init() {
        super.init()
        addCloseButton(tintColorWhite: false)
        self.title = "Picsite seleccionado"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        picsiteCheckView.alpha = 0
        picsiteCancelView.alpha = 0
        view.addSubview(picsiteCancelView)
        view.addSubview(picsiteCheckView)

        picsiteCheckView.translatesAutoresizingMaskIntoConstraints = false
        picsiteCancelView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            picsiteCheckView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            picsiteCheckView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            picsiteCheckView.widthAnchor.constraint(equalToConstant: 50),
            picsiteCheckView.heightAnchor.constraint(equalToConstant: 50),

            picsiteCancelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            picsiteCancelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            picsiteCancelView.widthAnchor.constraint(equalToConstant: 50),
            picsiteCancelView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    override public func deselectCurrentMapAnnotatons() {
        super.deselectCurrentMapAnnotatons()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.picsiteCheckView.alpha = 0
            self?.picsiteCancelView.alpha = 0
        })
    }
    
    override public func showAnnotationView() {
        super.showAnnotationView()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.picsiteCheckView.alpha = 1
            self?.picsiteCancelView.alpha = 1
        })
    }
    
    public override var barStyle: TransparentNavigationBar.TintColorStyle {
        return .solid()
    }
    
    public override func fetchData() {
        performBlockingTask(loadingMessage: "map-fetch-data-loading".localized, errorMessage: "map-fetch-error-fetching".localized) {
            let vm = try await ModuleDependencies.fetchAnnotations()
            self.configureFor(viewModel: vm)
        }
    }
    
    public override func didTapOnAnnotation(currentAnnotation: PicsiteAnnotation) { }
    
    public override func configureFor(viewModel: BaseMapViewController.VM) {
        mapView.addAnnotations(viewModel.annotations)
    }
}





