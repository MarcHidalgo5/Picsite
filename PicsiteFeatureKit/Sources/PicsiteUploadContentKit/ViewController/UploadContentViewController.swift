//
//  Created by Marc Hidalgo on 14/5/23.
//

import UIKit
import PicsiteUI
import BSWInterfaceKit
import Photos

public class UploadContentViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
    enum Constants {
        static let TinySpacing: CGFloat = 8
        static let SmallSpacing: CGFloat = 12
        static let Spacing: CGFloat = 20
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mediaPicker = PicsiteMediaPickerBehavior()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.picsiteDeepBlueColor
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.attributedText = FontPalette.boldTextStyler.attributedString("Crea contenido", color: ColorPalette.picsiteSecondaryTitleColor, forSize: 24)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        let photoUploadSection = SectionContainerView(PhotoUploadView())
        let picsiteUploadSection = SectionContainerView(PicsiteUploadView())
        
        photoUploadSection.view.onSelectUploadPhoto = {
            self.onSelectPhoto()
        }
        
        picsiteUploadSection.view.onSelectCreatePicsite = {
            print("create picsite")
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, photoUploadSection, picsiteUploadSection])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Constants.Spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparent
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func onSelectPhoto() {
        requestPhotoLibraryAccess()
        Task { @MainActor in
            guard let imageData = await self.mediaPicker.getMedia(fromVC: self, kind: .photo, source: .photoAlbum), imageData.localURL != nil else { return }
            let vc = UploadPhotoConfirmationViewController(imageData: imageData)
            self.show(vc, sender: self)
        }
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("El acceso a la biblioteca de fotos ha sido autorizado.")
            case .denied:
                print("El acceso a la biblioteca de fotos ha sido denegado.")
            case .restricted:
                print("El acceso a la biblioteca de fotos está restringido.")
            case .limited:
                print("El acceso a la biblioteca de fotos es limitado.")
            case .notDetermined:
                print("El usuario todavía no ha decidido si permitir el acceso a la biblioteca de fotos.")
            @unknown default:
                print("Un estado desconocido ha sido retornado.")
            }
        }
    }
    
    public class PhotoUploadView: UIStackView {
        var onSelectUploadPhoto: () -> () = { }
        
        public init() {
            super.init(frame: .zero)
            axis = .vertical
            alignment = .fill
            
            let uploadPhotoLabel: UILabel = {
                let label = UILabel()
                label.attributedText = FontPalette.mediumTextStyler.attributedString("Sube tus fotografías y compártelas en los picsites existentes en el mapa", color: ColorPalette.picsiteTitleColor, forSize: 16)
                label.textAlignment = .center
                label.numberOfLines = 0
                return label
            }()
            
            let uploadPhotoButton: UIButton = {
                var configuration = UIButton.Configuration.filled()
                configuration.title = "Subir foto"
                configuration.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
                configuration.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!)
                configuration.cornerStyle = .large
                let action = UIAction { action in
                    self.onSelectUploadPhoto()
                }
                return UIButton(configuration: configuration, primaryAction: action)
            }()
            
            spacing = Constants.SmallSpacing
            addArrangedSubview(uploadPhotoLabel)
            addArrangedSubview(uploadPhotoButton)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    public class PicsiteUploadView: UIStackView {
        
        var onSelectCreatePicsite: () -> () = { }
        
        public init() {
            super.init(frame: .zero)
            axis = .vertical
            alignment = .fill
            spacing = Constants.SmallSpacing
            
            let uploadPhotoLabel: UILabel = {
                let label = UILabel()
                label.attributedText = FontPalette.mediumTextStyler.attributedString("Crea un nuevo punto de interes en el mapa para poder compartir nuevas fotos", color: ColorPalette.picsiteTitleColor, forSize: 16)
                label.textAlignment = .center
                label.numberOfLines = 0
                return label
            }()
            
            let uploadPhotoButton: UIButton = {
                var configuration = UIButton.Configuration.filled()
                configuration.title = "Crear picsite"
                configuration.baseBackgroundColor = ColorPalette.picsiteDeepBlueColor
                configuration.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!)
                configuration.cornerStyle = .large
                let action = UIAction { _ in
                    self.onSelectCreatePicsite()
                }
                return UIButton(configuration: configuration, primaryAction: action)
            }()
            
            addArrangedSubview(uploadPhotoLabel)
            addArrangedSubview(uploadPhotoButton)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
