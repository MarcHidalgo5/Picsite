//
//  Created by Marc Hidalgo on 18/3/22.
//

import BSWFoundation
import UIKit

public extension UIView {
    
    private enum Constants {
        static let GradientTag = 7821
    }
    
    static func picsiteLoadingView(color: UIColor = ColorPalette.picsiteTintColor) -> some LoadingIndicator {
        let loadingView = MaterialActivityIndicatorView()
        loadingView.color = color
        loadingView.startAnimating()
        return loadingView
    }

    var gradientView: UIView? {
        return findSubviewWithTag(Constants.GradientTag)
    }
    
    func addBlackGradient(alpha: CGFloat = 0.5) {
        let gradientView = GradientView.blackGradient()
        addGradientView(gradientView, alpha: alpha)
    }

    func addDeepPurpleGradient(alpha: CGFloat = 0.5) {
        let gradientView = GradientView.deepPurpleGradient()
        addGradientView(gradientView, alpha: alpha)
    }
    
    func removeGradientView() {
        self.gradientView?.removeFromSuperview()
    }
    
    private func addGradientView(_ gradientView: UIView, alpha: CGFloat) {
        guard self.gradientView == nil else { return }

        gradientView.alpha = alpha
        addAutolayoutSubview(gradientView)
        gradientView.tag = Constants.GradientTag
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
            ])
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
        public let opacity: CGFloat = 0.15
        public let radius: CGFloat = 2
        public let offset = CGSize(width: 0, height: 1)
    }

    #warning("edit this")
    @objc func addPicsiteShadow() {
        let shadow = PicsiteShadow()
        addShadow(opacity: shadow.opacity, radius: shadow.radius, offset: shadow.offset)
        setNeedsLayout()
    }
}

