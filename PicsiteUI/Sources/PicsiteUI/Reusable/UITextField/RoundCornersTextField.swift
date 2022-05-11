//
//  Created by Marc Hidalgo on 11/5/22.
//

import UIKit

public class RoundCornersTextField: UITextField {
    
    enum Constants {
        static let BackgroundColor = UIColor(light: .white, dark: UIColor(rgb: 0x262627))
        static let TransparentBackgroundColor = UIColor.clear
        static let TextColor = ColorPalette.picsiteTitleColor
        static let PlaceholderColor = ColorPalette.picsitePlaceholderColor
        static let FontSize: CGFloat = 16
        static let Insets: UIEdgeInsets = [.left : 10, .right : 10]
        static let TransparentInset: UIEdgeInsets = [.left : 0, .right : 0]
        static let Height: CGFloat = {
            return UIScreen.main.isSmallScreen ? 40 : 46
        }()
    }
    
    public enum Style {
        case solid
        case transparent
    }
    
    private let style: Style!
    
    public init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        switch style {
        case .solid:
            backgroundColor = .gray.withAlphaComponent(0.1)
            keyboardAppearance = .dark
            textColor = Constants.TextColor
            roundCorners()
        case .transparent:
            backgroundColor = Constants.TransparentBackgroundColor
            keyboardAppearance = .dark
            textColor = Constants.TextColor
            tintColor = Constants.TextColor
            let borderView = UIView()
            borderView.backgroundColor = .black
            borderView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(borderView)
            
            NSLayoutConstraint.activate([
                borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.5),
                borderView.heightAnchor.constraint(equalToConstant: 0.5)
            ])

        }
        autocorrectionType = .no
        font = FontPalette.regularTextStyler.fontForSize(Constants.FontSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        if style == .transparent {
            return bounds.inset(by: Constants.TransparentInset)
        } else {
            return bounds.inset(by: Constants.Insets)
        }
        
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.Height)
    }
    
    public override var placeholder: String? {
        set {
            guard let _placeholder = newValue else {
                attributedPlaceholder = nil
                return
            }
            attributedPlaceholder = FontPalette.regularTextStyler.attributedString(_placeholder, color: Constants.PlaceholderColor, forSize: font?.pointSize ?? Constants.FontSize)
        }
        get {
            return attributedPlaceholder?.string
        }
    }
}
