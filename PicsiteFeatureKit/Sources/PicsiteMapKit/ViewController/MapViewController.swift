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
    private let reloadButton = UIButton(type: .system)
    
    public override var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparentWithoutUserInteractionEnable
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupReloadButton()
    }
    
    private func setupReloadButton() {
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        reloadButton.tintColor = .white
        reloadButton.backgroundColor = ColorPalette.picsiteDeepBlueColor
        reloadButton.layer.cornerRadius = 25
        reloadButton.clipsToBounds = true
        
        view.addSubview(reloadButton)
        
        NSLayoutConstraint.activate([
            reloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            reloadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            reloadButton.widthAnchor.constraint(equalToConstant: 50),
            reloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        reloadButton.addTarget(self, action: #selector(reloadMapData), for: .touchUpInside)
    }
    
    @objc private func reloadMapData() {
        fetchData()
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
    
    override public func deselectCurrentMapAnnotatons() {
        super.deselectCurrentMapAnnotatons()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.reloadButton.alpha = 1
        })
        
    }
    
    override public func showAnnotationView() {
        super.showAnnotationView()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.reloadButton.alpha = 0
        })
    }
}
