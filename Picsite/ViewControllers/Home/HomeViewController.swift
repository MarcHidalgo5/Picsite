//
//  HomeViewController.swift
//  Picsite
//
//  Created by Marc Hidalgo on 25/2/22.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI
import FirebaseAuth

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
        
        let appleImage = UIImage(named: "apple-icon")!.scaleTo(CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate)
        let loginAppleButton = UIButton(buttonConfiguration: .init(buttonTitle: .textAndImage(FontPalette.mediumTextStyler.attributedString("Login with Apple", color: .picsiteTitleColorReversed, forSize: 15), appleImage), tintColor: .picsiteTitleColorReversed, backgroundColor: .picsiteBackgroundColorReversed, contentInset: UIEdgeInsets(uniform: 10), cornerRadius: MainViewController.CornerRadius) {
            let firebaseAuth = Auth.auth()
           do {
             try firebaseAuth.signOut()
           } catch let signOutError as NSError {
             print("Error signing out: %@", signOutError)
           }
        })
        
        let contentStackView = UIStackView(arrangedSubviews: [
           loginAppleButton,
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
            loginAppleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.isTallScreen ? 50 : 30),
            loginAppleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginAppleButton.heightAnchor.constraint(equalToConstant: 84),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



