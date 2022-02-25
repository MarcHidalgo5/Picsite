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
        view.backgroundColor = .red
        
        let contentStackView = UIStackView(arrangedSubviews: [
           photoImageView
        ])
        contentStackView.axis = .vertical
        contentStackView.layoutMargins = .init(uniform: 32)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.spacing = 20
        contentStackView.alignment = .fill
        
        view.addAutolayoutSubview(contentStackView)
        contentStackView.pinToSuperviewSafeLayoutEdges()
        NSLayoutConstraint.activate([
         
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


