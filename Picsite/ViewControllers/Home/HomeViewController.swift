//
//  HomeViewController.swift
//  Picsite
//
//  Created by Marc Hidalgo on 25/2/22.
//

import UIKit
import BSWInterfaceKit

class HomeViewController: UIViewController {
    
    enum Constants {
        static let Spacing: CGFloat = 16
        static let PhotoHeight: CGFloat = 85
        static let CornerRadius: CGFloat = 16
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.roundCorners(radius: Constants.CornerRadius)
        imageView.backgroundColor = .black
        return imageView
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let contentStackView = UIStackView(arrangedSubviews: [
           photoImageView,
        ])
        contentStackView.axis = .vertical
        contentStackView.layoutMargins = .init(uniform: 32)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.spacing = 20
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillProportionally
        
        view.addAutolayoutSubview(contentStackView)
        contentStackView.pinToSuperviewSafeLayoutEdges()
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.isTallScreen ? 50 : 30),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 84),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



