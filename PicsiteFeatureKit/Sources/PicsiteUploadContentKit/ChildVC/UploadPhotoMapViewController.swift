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
    
    override public init() {
        super.init()
        addCloseButton(tintColorWhite: false)
        self.title = "Picsite seleccionado"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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





