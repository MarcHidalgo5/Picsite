//
//  Created by Marc Hidalgo on 14/5/23.
//

import UIKit
import BSWInterfaceKit

public class SectionContainerView<T: UIView>: UIView {
    
    public let view: T
    
    @objc public var onTap: (() -> ())? {
        didSet {
            if onTap != nil {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
                addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    public init(_ view: T, attributedTitle: NSAttributedString? = nil, addSeparators: Bool = true) {
        self.view = view
        super.init(frame: .zero)
        backgroundColor = ColorPalette.picsiteBackgroundColor
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 6
        
        if let attrTitle = attributedTitle {
            let titleLabel = UILabel()
            titleLabel.attributedText = attrTitle
            titleLabel.dontMakeBiggerOrSmallerVertically()
            stackView.addArrangedSubview(titleLabel)
            
            layoutMargins = [.top: 14, .left: 18, .bottom: 18, .right: 18]
        } else {
            layoutMargins = .init(uniform: 16)
        }
        
        stackView.addArrangedSubview(view)
        
        addSubview(stackView)
        stackView.pinToSuperviewLayoutMargins()
        roundCorners(radius: 12)
        addPicsiteShadow()
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func onTapGesture() {
        self.onTap?()
    }
}


