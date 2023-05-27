//
//  Created by Marc Hidalgo on 24/5/23.
//

import UIKit
import MapKit
import PicsiteUI
import BSWInterfaceKit
import SwiftUI

class UploadPicsiteMapViewController: BaseMapViewController {
    
    struct Constants {
        static let AnimationDuration = 0.3
        static let ButtonSize: CGFloat = 50
        static let ButtonMargin: CGFloat = 10
    }
    
    var horizontalLine: UIView!
    var verticalLine: UIView!
    var createPicsiteButton: UIButton!
    var pinImageView: UIImageView!
    let currentAnnotation = MKPointAnnotation()
    
    private let picsiteCheckView = RoundButtonView(imageButton: UIImage(systemName: "checkmark")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold)), color: ColorPalette.picsiteGreenColor)
    private let picsiteCancelView = RoundButtonView(imageButton: UIImage(systemName: "xmark")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold)), color: ColorPalette.picsiteErrorColor)
    
    let dataSource = ModuleDependencies.dataSource!
    
    override init() {
        super.init()
        addPlainBackButton(tintColorWhite: false)
        self.title = "Crear lugar"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()

        horizontalLine = UIView()
        horizontalLine.backgroundColor = ColorPalette.picsiteDeepBlueColor
        horizontalLine.alpha = 0.3
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        horizontalLine.isUserInteractionEnabled = false
        view.addAutolayoutSubview(horizontalLine)
        
        verticalLine = UIView()
        verticalLine.backgroundColor = ColorPalette.picsiteDeepBlueColor
        verticalLine.alpha = 0.3
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.isUserInteractionEnabled = false
        view.addAutolayoutSubview(verticalLine)
        
        createPicsiteButton = {
            var configuration = UIButton.Configuration.filled()
            configuration.title = "Añadir picsite"
            configuration.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!, size: 18, foregroundColor: .white)
            configuration.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
            configuration.cornerStyle = .large

            return UIButton(configuration: configuration, primaryAction: UIAction(handler: { [weak self] _ in
                self?.createPicsiteSelected()
            }))
        }()

        createPicsiteButton.translatesAutoresizingMaskIntoConstraints = false
        createPicsiteButton.addCustomShadow()
        view.addAutolayoutSubview(createPicsiteButton)
                
        pinImageView = UIImageView(image: UIImage(systemName: "pin.fill")?.withRenderingMode(.alwaysTemplate))
        pinImageView.tintColor = ColorPalette.picsiteDeepBlueColor
        pinImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addAutolayoutSubview(pinImageView)

        picsiteCheckView.alpha = 0
        picsiteCancelView.alpha = 0
        view.addAutolayoutSubview(picsiteCancelView)
        view.addAutolayoutSubview(picsiteCheckView)
        
        picsiteCheckView.onTapButton = { [weak self] in
            guard let self else { return }
            self.confirmCreatePicsite()
        }
        
        picsiteCancelView.onTapButton = { [weak self] in
            guard let self else { return }
            self.cancelCreatePicsite()
        }
        
        picsiteCheckView.translatesAutoresizingMaskIntoConstraints = false
        picsiteCancelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalLine.widthAnchor.constraint(equalToConstant: 2),
            verticalLine.topAnchor.constraint(equalTo: view.topAnchor),
            verticalLine.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            horizontalLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            horizontalLine.heightAnchor.constraint(equalToConstant: 2),
            horizontalLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            createPicsiteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            createPicsiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createPicsiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createPicsiteButton.heightAnchor.constraint(equalToConstant: 40),
            
            pinImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pinImageView.widthAnchor.constraint(equalToConstant: 25),
            pinImageView.heightAnchor.constraint(equalToConstant: 25),
            
            picsiteCheckView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.ButtonMargin),
            picsiteCheckView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.ButtonMargin),
            picsiteCheckView.widthAnchor.constraint(equalToConstant: Constants.ButtonSize),
            picsiteCheckView.heightAnchor.constraint(equalToConstant: Constants.ButtonSize),

            picsiteCancelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.ButtonMargin),
            picsiteCancelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.ButtonMargin),
            picsiteCancelView.widthAnchor.constraint(equalToConstant: Constants.ButtonSize),
            picsiteCancelView.heightAnchor.constraint(equalToConstant: Constants.ButtonSize)
        ])
    }
    
    //MARK: Override
    
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
    
    public override func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { }
    
    //MARK: Objc actions
    
    @objc func createPicsiteSelected() {
        
        UIView.animate(withDuration: Constants.AnimationDuration, animations: { [weak self] in
            self?.picsiteCheckView.alpha = 1
            self?.picsiteCancelView.alpha = 1
            self?.createPicsiteButton.alpha = 0
            self?.verticalLine.alpha = 0
            self?.horizontalLine.alpha = 0
            self?.pinImageView.alpha = 0
        })
        currentAnnotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(currentAnnotation)
        mapView.selectAnnotation(currentAnnotation, animated: true)
        mapView.isUserInteractionEnabled = false
        self.title = "Confirmar?"
    }
    
    //MARK: Private
    
    private func cancelCreatePicsite() {
        UIView.animate(withDuration: Constants.AnimationDuration, animations: { [weak self] in
            self?.picsiteCheckView.alpha = 0
            self?.picsiteCancelView.alpha = 0
            self?.createPicsiteButton.alpha = 1
            self?.verticalLine.alpha = 0.3
            self?.horizontalLine.alpha = 0.3
            self?.pinImageView.alpha = 1
        })
        
        mapView.removeAnnotation(currentAnnotation)
        mapView.isUserInteractionEnabled = true
        self.title = "Crear lugar"
    }
    
    private func confirmCreatePicsite() {
        let location: CLLocation = .init(latitude: currentAnnotation.coordinate.latitude, longitude: currentAnnotation.coordinate.longitude)
        let vc = UploadPicsiteConfirmationViewController(location: location)
        self.show(vc, sender: self)
    }
}
