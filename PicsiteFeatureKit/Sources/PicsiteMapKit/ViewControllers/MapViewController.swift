//
//  Created by Marc Hidalgo on 7/11/22.
//

import UIKit
import MapKit
import PicsiteUI

public class MapViewController: UIViewController {
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    let mapView : MKMapView = {
        let map = MKMapView()
//        map.overrideUserInterfaceStyle = .dark
        map.pointOfInterestFilter = .excludingAll
//        map.showsUserLocation = true
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
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        createTestAnnotation()
    }
}

extension MapViewController {
    
    func createTestAnnotation() {
        let startPin = MKPointAnnotation()
        startPin.title = "start"
        startPin.coordinate = CLLocationCoordinate2D(
            latitude: 41.61803,
            longitude: 0.62772
        )
        mapView.addAnnotation(startPin)
        
        let secondPin = MKPointAnnotation()
        secondPin.title = "second"
        secondPin.coordinate = CLLocationCoordinate2D(
            latitude: 41.62803,
            longitude: 0.63772
        )
        mapView.addAnnotation(secondPin)
        
        let lastPin = MKPointAnnotation()
        lastPin.title = "last"
        lastPin.coordinate = CLLocationCoordinate2D(
            latitude: 41.60803,
            longitude: 0.61772
        )
        mapView.addAnnotation(lastPin)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
                let mapCamera = MKMapCamera()
                    mapCamera.centerCoordinate = userLocation.coordinate
                    mapCamera.pitch = 25
                    mapCamera.altitude = 3000
                mapView.setRegion(viewRegion, animated: false)
                mapView.setCamera(mapCamera, animated: true)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    static let annotationIdentifier = "PicsiteCustomAnnotation"
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MapViewController.annotationIdentifier)
        switch annotation.title {
        case "start":
            annotationView.markerTintColor = UIColor.green
            annotationView.glyphImage = UIImage(systemName: "binoculars.fill")
        case "second":
            annotationView.markerTintColor = UIColor.yellow
            annotationView.glyphImage = UIImage(systemName: "binoculars.fill")
        case "last":
            annotationView.markerTintColor = UIColor.red
            annotationView.glyphImage = UIImage(systemName: "binoculars.fill")
        default:
            annotationView.markerTintColor = UIColor.blue
        }
        
        return annotationView
    }
}

extension MapViewController: TransparentNavigationBarPreferenceProvider {
    public var barStyle: TransparentNavigationBar.TintColorStyle { .transparent }
}
