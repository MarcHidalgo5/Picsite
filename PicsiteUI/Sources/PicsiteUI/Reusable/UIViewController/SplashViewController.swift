//
//  Created by Marc Hidalgo on 9/11/22.
//

import UIKit
import BSWInterfaceKit

open class SplashViewController: UIViewController {
    
    open override func loadView() {
        let placeholderIdentifier = "LaunchScreen"
        let storyboard = UIStoryboard(name: placeholderIdentifier, bundle: .main)
        let baseVC = storyboard.instantiateViewController(withIdentifier: placeholderIdentifier)
        let view = baseVC.view
        baseVC.view = nil
        self.view = view
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        guard let centerView = view?.findSubviewWithTag(80) else {
            return
        }
        let activityView = UIView.picsiteLoadingView(color: ColorPalette.picsiteTintColor)
        view.addAutolayoutSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: centerView.centerXAnchor),
            activityView.topAnchor.constraint(equalTo: centerView.bottomAnchor, constant: 32),
        ])
    }
}

