//
//  Created by Marc Hidalgo on 18/3/22.
//

import BSWFoundation
import UIKit

public extension UIView {

    static func picsiteLoadingView(color: UIColor = ColorPalette.picsiteTintColor) -> some LoadingIndicator {
        let loadingView = MaterialActivityIndicatorView()
        loadingView.color = color
        loadingView.startAnimating()
        return loadingView
    }
}

public extension UIView {
    
    struct PicsiteShadow {
        public init() {}
        public let opacity: CGFloat = 0.4
        public let radius: CGFloat = 2
        public let offset = CGSize(width: 0, height: 2)
    }

    @objc func addPicsiteShadow() {
        let shadow = PicsiteShadow()
        addShadow(opacity: shadow.opacity, radius: shadow.radius, offset: shadow.offset)
        setNeedsLayout()
    }
    
    func addCustomShadow() {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2
    }
}

