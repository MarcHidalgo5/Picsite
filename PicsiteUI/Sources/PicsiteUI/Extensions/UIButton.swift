 //
//  Created by Marc Hidalgo on 12/5/22.
//

import UIKit
import BSWInterfaceKit
import BSWFoundation

public extension UIButton {

    static func fillButton(withTitle title: String, color: UIColor = .white, backgroundColor: UIColor = ColorPalette.picsiteDeepBlueColor, handler: @escaping VoidHandler) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.setFont(fontDescriptor: FontPalette.mediumTextStyler.fontDescriptor!, size: 16, foregroundColor: color)
        config.baseBackgroundColor = backgroundColor
        config.title = title
        config.contentInsets = .init(uniform: 10)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { action in
            handler()
        }))
    }
    
    func addCustomPicsiteShadow() {
        /// Turns out that buttons created with `UIButton.Configuration`
        /// using our shadow APIs was not working and we need to add custom code here.
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 2
        self.layer.contentsScale = UIScreen.main.scale
    }
}

public extension UIButton.Configuration {
    mutating func setFont(fontDescriptor: UIFontDescriptor, size: CGFloat = 17, foregroundColor: UIColor? = nil) {
        self.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(descriptor: fontDescriptor, size: size)
            if let foregroundColor {
                outgoing.foregroundColor = foregroundColor
            }
            return outgoing
        }
    }
}
