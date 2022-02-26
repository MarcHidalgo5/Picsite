//
//  ViewController.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/11/21.
//

import UIKit
import BSWInterfaceKit

class MainViewController: UIViewController {
    
    enum Constants {
        static let Spacing: CGFloat = 16
        static let PhotoHeight: CGFloat = 85
        static let CornerRadius: CGFloat = 16
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.roundCorners(radius: Constants.CornerRadius)
        imageView.backgroundColor = .picsiteTitleColor
        return imageView
    }()
    
    private let photoImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.roundCorners(radius: Constants.CornerRadius)
        imageView.backgroundColor = .picsiteTintColor
        return imageView
    }()
    
    private let photoImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.roundCorners(radius: Constants.CornerRadius)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let photoImageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.roundCorners(radius: Constants.CornerRadius)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let contentStackView = UIStackView(arrangedSubviews: [
           photoImageView,
           photoImageView2,
           photoImageView3,
           photoImageView4,
           UIView(),
        ])
        contentStackView.axis = .vertical
        contentStackView.layoutMargins = .init(uniform: 32)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.spacing = 20
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillProportionally
        
        view.addAutolayoutSubview(contentStackView)
        contentStackView.pinToSuperview()
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.isTallScreen ? 50 : 30),
            photoImageView.heightAnchor.constraint(equalToConstant: 400),
            photoImageView2.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            photoImageView2.heightAnchor.constraint(equalToConstant: 84),
            photoImageView3.topAnchor.constraint(equalTo: photoImageView2.bottomAnchor, constant: 10),
            photoImageView3.heightAnchor.constraint(equalToConstant: 84),
            photoImageView4.topAnchor.constraint(equalTo: photoImageView3.bottomAnchor, constant: 10),
            photoImageView4.heightAnchor.constraint(equalToConstant: 84)
            
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


