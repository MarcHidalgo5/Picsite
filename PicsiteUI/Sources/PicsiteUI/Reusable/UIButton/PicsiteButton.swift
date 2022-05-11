//
//  Created by Marc Hidalgo on 7/5/22.
//

import UIKit
import BSWInterfaceKit

public class PicsiteButton: UIButton {
    
    let color: UIColor
    
    public init(color: UIColor = UIColor.black) {
        self.color = color
        super.init(frame: .zero)
        backgroundColor = color
        addTarget(self, action: #selector(buttonTap), for: .touchDown)
        isPointerInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var stringAttributes: [NSAttributedString.Key: Any] = [
        .kern: 0.5,
        .foregroundColor: ColorPalette.picsiteButtonTitleColor!,
        .font: UIFont(descriptor: FontPalette.mediumTextStyler.fontDescriptor!, size: 22)
    ]
    
    private enum Constants {
        static let HighlightedAnimationDuration: TimeInterval = 0.25
        static let IntrinsicContentSize = CGSize(width: 56, height: 56)
    }
    
    private let animator = UIViewPropertyAnimator(duration: Constants.HighlightedAnimationDuration, curve: .easeInOut)
    
    public override var intrinsicContentSize: CGSize {
        return Constants.IntrinsicContentSize
    }
    
    public override var isHighlighted: Bool {
        didSet {
            guard !isSelected else { return }
            animator.addAnimations {
                self.backgroundColor = self.isHighlighted ? self.color.withAlphaComponent(0.5) : self.color
            }
            animator.startAnimation()
        }
    }

    public override var isSelected: Bool {
        didSet {
            animator.addAnimations {
                self.backgroundColor = self.isSelected ? self.color : self.color.withAlphaComponent(0.5)
            }
            animator.startAnimation()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            animator.addAnimations {
                self.backgroundColor = self.isEnabled ? self.color : self.color.withAlphaComponent(0.5)
            }
            animator.startAnimation()
        }
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        
        guard let title = title else {
            self.setAttributedTitle(nil, for: .normal)
            return
        }
        
        let attributedTitle = NSAttributedString(string: title, attributes: stringAttributes)
        super.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    @objc private func buttonTap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

public class RoundButton: PicsiteButton {
    
    public override init(color: UIColor = UIColor.black.withAlphaComponent(0.6)) {
        super.init(color: color)
        self.stringAttributes = [
            .kern: 0.5,
            .foregroundColor: UIColor.white,
            .font : UIFont(descriptor: FontPalette.mediumTextStyler.fontDescriptor!, size: 24)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.setNeedsDisplay()
    }
    
    public override class var layerClass: AnyClass {
        return RoundLayer.self
    }
}
