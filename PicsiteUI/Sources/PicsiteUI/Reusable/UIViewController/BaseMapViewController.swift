//
//  Created by Marc Hidalgo on 17/5/23.
//

import UIKit
import MapKit
import PicsiteKit
import CoreLocation
import BSWInterfaceKit

public protocol BaseMapViewControlleType: UIViewController, TransparentNavigationBarPreferenceProvider, PicsiteAnnotationViewObserver{
    func fetchData()
    func didTapOnAnnotation(currentAnnotation: PicsiteAnnotation)
    func configureFor(viewModel: BaseMapViewController.VM)
}

open class BaseMapViewController: UIViewController, BaseMapViewControlleType, TransparentNavigationBarPreferenceProvider {
        
    public struct VM {
        public let annotations: [PicsiteAnnotation]
        
        public init(annotations: [PicsiteAnnotation]) {
            self.annotations = annotations
        }
    }
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    private let picsitAnnotationView = PicsiteAnnotationView(frame: CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 100))
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    public let mapView : MKMapView = {
        let map = MKMapView()
        map.pointOfInterestFilter = .excludingAll
        return map
    }()
    
    public var currentIDSelected: String {
        get {
            picsitAnnotationView.id
        }
    }

    open override func loadView() {
        view = UIView()
        view.addSubview(mapView)
        view.addSubview(picsitAnnotationView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.pinToSuperview()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
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
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {

        let touchPoint = gestureRecognizer.location(in: self.view?.window)

        if gestureRecognizer.state == .began {
            initialTouchPoint = touchPoint
        } else if gestureRecognizer.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.picsitAnnotationView.frame.origin.y = touchPoint.y - initialTouchPoint.y + UIScreen.main.bounds.height - (UIScreen.main.smallestScreen ? 180 : 210)
            }
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            if mapView.selectedAnnotations.count > 0 {
                if touchPoint.y - self.initialTouchPoint.y > 45 {
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
            deselectCurrentMapAnnotatons()
        }
    }
    
    open func showAnnotationView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.picsitAnnotationView.frame.origin.y =  UIScreen.main.bounds.height - (UIScreen.main.smallestScreen ? 180 : 210)
        })
    }
    
    func removeAnnotationView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.picsitAnnotationView.frame.origin.y =  UIScreen.main.bounds.height
        })
    }
    
    open func deselectCurrentMapAnnotatons() {
        removeAnnotationView()
        for annotation in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
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
    
    // Implement this
    
    open var barStyle: PicsiteUI.TransparentNavigationBar.TintColorStyle {
        fatalError("barStyle has not been implemented")
    }
    
    open func fetchData() {
        fatalError("fetchData() has not been implemented")
    }
    
    open func didTapOnAnnotation(currentAnnotation: PicsiteAnnotation) {
        fatalError("didTapOnAnnotation(currentAnnotation: PicsiteAnnotation) has not been implemented")
    }
    
    open func configureFor(viewModel: VM) {
        fatalError("configureFor(viewModel: VM)")
    }
}

//MARK: CLLocationManegerDelegate

extension BaseMapViewController: CLLocationManagerDelegate {
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

//MARK: MKMapViewDelegate

extension BaseMapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let currentAnnotation = view as? AnnotationMarkerView, let picsiteAnnotation = currentAnnotation.annotation as? PicsiteAnnotation else { return }
        
        self.picsitAnnotationView.configureFor(picsiteAnnotation: picsiteAnnotation)
        self.showAnnotationView()
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
