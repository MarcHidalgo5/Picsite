//
//  Created by Marc Hidalgo on 6/4/22.
//

import BSWInterfaceKit
import BSWFoundation
import UIKit; import Foundation

extension StartingViewController {
    
    @objc(StartingBottomButtonViewController)
    class BottomButtonViewController: UIViewController {
        
        static let CornerRadius: CGFloat = 12
        
        var onGetStarted: VoidHandler?
        
        override func loadView() {
            let fontSize: CGFloat = UIScreen.main.isSmallScreen ? 16 : 20

            let getStartedButton = UIButton(buttonConfiguration: .init(buttonTitle: .text(mediumTextStyler.attributedString("start-button".localized, color: .white, forSize: fontSize)), tintColor: .white, backgroundColor: UIColor.picsiteDeepBlueColor, contentInset: UIEdgeInsets(uniform: 20), cornerRadius: BottomButtonViewController.CornerRadius) { [weak self] in
                self?.onGetStarted?()
                })
            getStartedButton.layer.shadowColor = UIColor.black.cgColor
            getStartedButton.layer.shadowOpacity = 0.5
            getStartedButton.layer.shadowRadius = 6
            getStartedButton.layer.shadowOffset = .zero
            
            let stackView = UIStackView(arrangedSubviews: [getStartedButton])
            stackView.spacing = Constants.SmallPadding
            stackView.layoutMargins = Constants.LayoutMargins
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.axis = .vertical
            
            view = UIView()
            view.addAutolayoutSubview(stackView)
            
            stackView.pinToSuperviewSafeLayoutEdges()
        }
    }
}
