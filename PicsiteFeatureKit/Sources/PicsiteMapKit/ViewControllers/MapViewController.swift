//
//  Created by Marc Hidalgo on 7/11/22.
//

import UIKit
import MapKit
import PicsiteUI; import PicsiteKit
import CoreLocation

public class MapViewController: UIViewController {
    
    public struct VM {
        let annotations: [PicsiteAnnotation]
        
        public init(annotations: [PicsiteAnnotation]) {
            self.annotations = annotations
        }
    }
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    private let dataSource = ModuleDependencies.mapDataSource!
    private var annotationCalloutView: AnnotationCalloutView?
    
    private let mapView : MKMapView = {
        let map = MKMapView()
        map.pointOfInterestFilter = .excludingAll
        return map
    }()
    
    public override func loadView() {
        view = UIView()
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(
            AnnotationMarkerView.self,
            forAnnotationViewWithReuseIdentifier:
                MKMapViewDefaultAnnotationViewReuseIdentifier)
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnMap))
        mapView.addGestureRecognizer(singleTapRecognizer)
        createLocationManeger()
        fetchData()
    }
    
    //MARK: Private
    
    private func fetchData(animated: Bool = true) {
        fetchData(taskGenerator: { [unowned self] in
            try await dataSource.fetchAnnotations()
        },
        animated: animated,
        errorMessage: "fetch-error-message".localized,
        completion: { [weak self] vm in
            self?.configureFor(viewModel: vm)
        })
    }
    
    @objc private func didTapOnMap() {
        if annotationCalloutView != nil {
            annotationCalloutView?.dismissPicsiteView(animated: true)
        }
    }
    
    private func configureFor(viewModel: VM) {
        mapView.addAnnotations(viewModel.annotations)
    }
    
    private func createLocationManeger() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                currentLocation = userLocation
                mapView.centerToLocation(userLocation)
                mapView.centerCameraToLocation(userLocation)
            }
        }
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 3000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: false)
    }
    
    func centerCameraToLocation(_ location: CLLocation, altitude: CLLocationDistance = 3000) {
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = location.coordinate
            mapCamera.pitch = 25
            mapCamera.altitude = altitude
        setCamera(mapCamera, animated: true)
    }
}

//MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let currentAnnotation = view as? AnnotationMarkerView, let picsiteAnnotation = currentAnnotation.annotation as? PicsiteAnnotation  else { return }
        createPicsiteAnnotationView(picsiteAnnotation: picsiteAnnotation)
    }
    
    func createPicsiteAnnotationView(picsiteAnnotation: PicsiteAnnotation) {
        Task { @MainActor in
            let vm = try await self.dataSource.fetchDetailAFor(annotation: picsiteAnnotation)
            let annotationCallout = AnnotationCalloutView()
            annotationCallout.addPicsiteShadow()
            annotationCallout.configureView(with: vm, fromVC: self) {
                self.mapView.deselectAnnotation(picsiteAnnotation, animated: true)
                self.annotationCalloutView = nil
            }
            guard let window = self.view.window else {
                print("Failed to show annotationCalloutView. No keywindow available.")
                return
            }
            window.addSubview(annotationCallout)
            annotationCallout.showPicsiteView()
            annotationCalloutView = annotationCallout
        }
        
    }
}
