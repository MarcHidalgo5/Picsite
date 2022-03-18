//
//  Created by Marc Hidalgo on 18/3/22.
//

import UIKit

class MaterialActivityIndicatorView: UIView, LoadingIndicator {
    @IBInspectable
    public var color: UIColor = .red {
        didSet {
            indicator.strokeColor = color.cgColor
        }
    }
    
    public var lineWidth: CGFloat = 2.0 {
        didSet {
            indicator.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    private let indicator = CAShapeLayer()
    private let animator = MaterialActivityIndicatorAnimator()
    
    private var isAnimating = false {
        didSet {
            if window == nil {
                shouldForceAnimationAfterComingBack = true
            }
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        self.setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        indicator.strokeColor = color.cgColor
    }
    
    private func setup() {
        indicator.strokeColor = color.cgColor
        indicator.fillColor = nil
        indicator.lineWidth = lineWidth
        indicator.strokeStart = 0.0
        indicator.strokeEnd = 0.0
        layer.addSublayer(indicator)
    }
    
    private var shouldForceAnimationAfterComingBack = false
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil && isAnimating {
            shouldForceAnimationAfterComingBack = true
        }
        if newWindow != nil && shouldForceAnimationAfterComingBack {
            self.stopAnimating()
            self.startAnimating()
        }
    }
}

extension MaterialActivityIndicatorView {
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 32, height: 32)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        indicator.frame = bounds
        
        let diameter = bounds.size.min - indicator.lineWidth
        let path = UIBezierPath(center: bounds.center, radius: diameter / 2)
        indicator.path = path.cgPath
    }
}

extension MaterialActivityIndicatorView {
    public func startAnimating() {
        guard !isAnimating else { return }
        
        animator.addAnimation(to: indicator)
        isAnimating = true
    }
    
    public func stopAnimating() {
        guard isAnimating else { return }
        
        animator.removeAnimation(from: indicator)
        isAnimating = false
    }
}

private final class MaterialActivityIndicatorAnimator {
    enum Animation: String {
        var key: String {
            return rawValue
        }
        
        case spring = "material.indicator.spring"
        case rotation = "material.indicator.rotation"
    }
    
    public func addAnimation(to layer: CALayer) {
        layer.add(rotationAnimation(), forKey: Animation.rotation.key)
        layer.add(springAnimation(), forKey: Animation.spring.key)
    }
    
    public func removeAnimation(from layer: CALayer) {
        layer.removeAnimation(forKey: Animation.rotation.key)
        layer.removeAnimation(forKey: Animation.spring.key)
    }
}

extension MaterialActivityIndicatorAnimator {
    private func rotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .rotationZ)
        animation.duration = 3.4
        animation.fromValue = 0
        animation.toValue = (2.0 * .pi)
        animation.repeatCount = .infinity
        
        return animation
    }
    
    private func springAnimation() -> CAAnimationGroup {
        let animation = CAAnimationGroup()
        animation.duration = 1.275
        animation.animations = [
            strokeStartAnimation(),
            strokeEndAnimation(),
            strokeCatchAnimation(),
            strokeFreezeAnimation()
        ]
        animation.repeatCount = .infinity
        
        return animation
    }
    
    private func strokeStartAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .strokeStart)
        animation.duration = 0.85
        animation.fromValue = 0
        animation.toValue = 0.15
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return animation
    }
    
    private func strokeEndAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .strokeEnd)
        animation.duration = 0.85
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return animation
    }
    
    private func strokeCatchAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .strokeStart)
        animation.beginTime = 0.85
        animation.duration = 0.5
        animation.fromValue = 0.15
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return animation
    }
    
    private func strokeFreezeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(key: .strokeEnd)
        animation.beginTime = 0.85
        animation.duration = 0.5
        animation.fromValue = 1
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return animation
    }
}

private extension CGSize {
    var min: CGFloat {
        return CGFloat.minimum(width, height)
    }
}

private extension UIBezierPath {
    convenience init(center: CGPoint, radius: CGFloat) {
        self.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
    }
}

private extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

private extension CAPropertyAnimation {
    enum Key: String {
        var path: String {
            return rawValue
        }
        
        case strokeStart = "strokeStart"
        case strokeEnd = "strokeEnd"
        case strokeColor = "strokeColor"
        case rotationZ = "transform.rotation.z"
        case scale = "transform.scale"
    }
    
    convenience init(key: Key) {
        self.init(keyPath: key.path)
    }
}

