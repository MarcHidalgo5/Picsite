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
    func addBorder(width: CGFloat, color: UIColor) {
        guard layer.borderWidth != width else { return }
        let widthAnimation = CABasicAnimation(keyPath: "borderWidth")
        widthAnimation.fromValue = 0
        widthAnimation.toValue = width
        widthAnimation.duration = 0.3
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.add(widthAnimation, forKey: "width")
    }
    
    func removeBorder() {
        guard layer.borderWidth != 0 else { return }
        let widthAnimation = CABasicAnimation(keyPath: "borderWidth")
        widthAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        widthAnimation.fromValue = layer.borderWidth
        widthAnimation.toValue = 0
        widthAnimation.duration = 0.3
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        layer.add(widthAnimation, forKey: "width")
    }

    func addOverlayView() {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addAutolayoutSubview(overlayView)
        overlayView.pinToSuperview()
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
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

