//
//  Created by Marc Hidalgo on 7/11/22.
//

import UIKit
import MapKit
import PicsiteUI; import PicsiteKit
import CoreLocation
import BSWInterfaceKit

public class MapViewController: BaseMapViewController {
    
    private let dataSource = ModuleDependencies.dataSource!
    
    public override var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparentWithoutUserInteractionEnable
    }

    public override func fetchData()  {
        performBlockingTask(loadingMessage: "map-fetch-data-loading".localized, errorMessage: "map-fetch-error-fetching".localized) {
            let vm = try await self.dataSource.fetchAnnotations()
            self.configureFor(viewModel: vm)
        }
    }
    
    public override func configureFor(viewModel: BaseMapViewController.VM) {
        self.deselectCurrentMapAnnotatons()
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(viewModel.annotations)
    }
    
    public override func didTapOnAnnotation(currentAnnotation: PicsiteAnnotation) {
        let profileVC = dataSource.picsiteProfileViewController(picsite: currentAnnotation.picsiteData)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
