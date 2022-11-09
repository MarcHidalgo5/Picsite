//
//  Created by Marc Hidalgo on 9/11/22.
//

import UIKit
import PicsiteUI

class AnnotationCalloutView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textColor = .white
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private var completion: () -> () = {}
    
    init() {
        super.init(frame: .zero)
        setupLayer()
        setupSubviews()
        setupTargets()
    }
    
    required internal init?(coder aDecoder:NSCoder) { fatalError("Not implemented.") }
    
    func configureView(fromVC: UIViewController, completion: @escaping () -> ()) {
        setBackgroundColor(color: .blue)
        setImage(image: nil)
        setTitle(title: FontPalette.mediumTextStyler.attributedString("hjkuhlijokpl", forSize: 22))
        setMessage(message: nil)
//        setDismisTimer(delay: 0)
        setCompletionBlock(completion)
        prepareFrame(fromVC: fromVC)
//        showPicsiteView()
    }
    
    func prepareFrame(fromVC: UIViewController) {
        let bounds = fromVC.view.window?.bounds ?? UIScreen.main.bounds
        let deviceWidth = min(bounds.width, bounds.height)
        let widthFactor: CGFloat = (fromVC.view.window?.traitCollection.horizontalSizeClass == .compact) ? 0.85 : 0.5
        let width = deviceWidth * widthFactor
        let height: CGFloat = {
            let size = systemLayoutSizeFitting(
                CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            return size.height
        }()
        
        self.frame = CGRect(x: 0, y: bounds.height - height, width: width, height: height)
        self.center.x = bounds.width/2
    }
    
    // MARK: - Setup
    
    private func setupLayer() {
        layer.cornerRadius = 5
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    private func setupSubviews() {
        let textStackView = UIStackView(arrangedSubviews: [titleLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 3
        textStackView.alignment = .center

        let contentStackView = UIStackView(arrangedSubviews: [textStackView])
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.layoutMargins = .init(uniform: 12)
        contentStackView.isLayoutMarginsRelativeArrangement = true

        addAutolayoutSubview(contentStackView)
        contentStackView.pinToSuperview()
    }
    
    private func setupTargets() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(_dismissNotification))
        swipeRecognizer.direction = .down
        addGestureRecognizer(swipeRecognizer)
    }
    
    func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
    
    func setTitle(title: NSAttributedString?) {
        titleLabel.attributedText = title
        titleLabel.isHidden = (title == nil)
    }
    
    func setMessage(message: NSAttributedString?) {
//        messageLabel.attributedText = message
//        messageLabel.isHidden = (message == nil)
    }
    
    func setImage(image: UIImage?) {
//        imageView.image = image
//        imageView.isHidden = (image == nil)
    }
    
    func setCompletionBlock(_ completion: @escaping () -> ()) {
        self.completion = completion
    }
    
    func showPicsiteView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.1, options: UIView.AnimationOptions(), animations: {
            let newValue : CGFloat = {
                return UIScreen.main.isSmallTabBar ? 80 : 150
            }()
            self.frame.origin.y += self.safeAreaInsets.bottom - newValue
        })
    }
    
    @objc private func _dismissNotification() {
        dismissNotification(animated: true)
    }
    
    func dismissNotification(animated: Bool) {
        guard animated else {
            removeFromSuperview()
            return
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.frame.origin.y = self.frame.origin.y - 5
        }, completion: {
            (complete: Bool) in
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y -= -self.frame.height - 180
            }, completion: { [weak self] (complete) in
                self?.completion()
                self?.removeFromSuperview()
            })
        })
    }
}

public extension UIScreen {
    var isSmallTabBar: Bool {
        return self.bounds.width <= 380
    }
}
