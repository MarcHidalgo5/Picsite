//
//  Created by Marc Hidalgo on 7/11/22.
//

import UIKit
import MapKit
import PicsiteUI; import PicsiteKit
import CoreLocation
import BSWInterfaceKit

public class MapViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
    public struct VM {
        let annotations: [PicsiteAnnotation]
        
        public init(annotations: [PicsiteAnnotation]) {
            self.annotations = annotations
        }
    }
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    private let dataSource = ModuleDependencies.mapDataSource!
    private let picsitAnnotationView = PicsiteAnnotationView(frame: CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 100))
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    private let mapView : MKMapView = {
        let map = MKMapView()
        map.pointOfInterestFilter = .excludingAll
        return map
    }()
    
    public override func loadView() {
        view = UIView()
        view.addSubview(mapView)
        view.addSubview(picsitAnnotationView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.pinToSuperview()
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        picsitAnnotationView.addGestureRecognizer(panGesture)
        createLocationManeger()
        fetchData()
    }
    
    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparentWithoutUserInteractionEnable
    }
    
    //MARK: Private

    private func fetchData()  {
        performBlockingTask(loadingMessage: "map-fetch-data-loading".localized, errorMessage: "map-fetch-error-fetching".localized) {
            let vm = try await self.dataSource.fetchAnnotations()
            self.configureFor(viewModel: vm)
        }
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {

        let touchPoint = gestureRecognizer.location(in: self.view?.window)

        if gestureRecognizer.state == .began {
            initialTouchPoint = touchPoint
        } else if gestureRecognizer.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.picsitAnnotationView.frame.origin.y =  touchPoint.y - initialTouchPoint.y + UIScreen.main.bounds.height - (UIScreen.main.smallestScreen ? 180 : 210)
            }
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            if mapView.selectedAnnotations.count > 0 {
                if touchPoint.y - self.initialTouchPoint.y > 45 {
                    self.removeAnnotationView()
                    self.deselectCurrentMapAnnotatons()
                } else {
                    // Redisplay in the initial position
                    self.showAnnotationView()
                }
            }
            initialTouchPoint = CGPoint(x: 0,y: 0)
        }
    }
    
    @objc private func didTapOnMap() {
        if mapView.selectedAnnotations.count > 0 {
            removeAnnotationView()
            deselectCurrentMapAnnotatons()
        }
    }
    
    private func showAnnotationView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.picsitAnnotationView.frame.origin.y =  UIScreen.main.bounds.height - (UIScreen.main.smallestScreen ? 180 : 210)
        })
    }
    
    func removeAnnotationView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.picsitAnnotationView.frame.origin.y =  UIScreen.main.bounds.height
        })
    }
    
    private func deselectCurrentMapAnnotatons() {
        for annotation in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: true)
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
            if let userLocation = locations.last {
                currentLocation = userLocation
                mapView.centerToLocation(userLocation)
                mapView.centerCameraToLocation(userLocation)
            }
        }
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 4000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: false)
    }
    
    func centerCameraToLocation(_ location: CLLocation, altitude: CLLocationDistance = 4000) {
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
        
        guard let currentAnnotation = view as? AnnotationMarkerView, let picsiteAnnotation = currentAnnotation.annotation as? PicsiteAnnotation else { return }
        
        self.picsitAnnotationView.configureFor(picsiteAnnotation: picsiteAnnotation)
        self.showAnnotationView()
    }
}

//MARK: PicsiteAnnotationViewObserver

extension MapViewController: PicsiteAnnotationViewObserver {
    func didTapOnAnnotation(currentAnnotation: PicsiteAnnotation) {
        let profileVC = dataSource.picsiteProfileViewController()
        show(profileVC, sender: nil)
    }
}

