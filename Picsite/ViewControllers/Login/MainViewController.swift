//
//  ViewController.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/11/21.
//

import UIKit
import BSWInterfaceKit
import SwiftUI

class MainViewController: UIViewController {
    
    enum Constants {
        static let Spacing: CGFloat = 16
        static let PhotoHeight: CGFloat = 85
        static let CornerRadius: CGFloat = 16
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.roundCorners(radius: Constants.CornerRadius)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.PhotoHeight),
        ])
        return imageView
    }()
    
    override func loadView() {
        view = UIView()
        let contentStackView = UIStackView()
        contentStackView.spacing = 10
        contentStackView.alignment = .center
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        
        photoImageView.tintColor = .blue
        
        contentStackView.addArrangedSubview(photoImageView)
        
        view.addAutolayoutSubview(contentStackView)
        contentStackView.pinToSuperview()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


