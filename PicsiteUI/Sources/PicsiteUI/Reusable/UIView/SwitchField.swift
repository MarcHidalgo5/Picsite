//
//  Created by Marc Hidalgo on 4/11/22.
//

import UIKit
import BSWInterfaceKit
import PicsiteKit

open class SwitchField: UIStackView, ViewModelConfigurable, AuthenticationField {
    
    public let onSwitch = UISwitch()
    public let messageLabel = LinkAwareLabel()
    public let errorLabel = UILabel.unlimitedLinesLabel()
    
    public init(message: NSAttributedString) {
        super.init(frame: .zero)
        axis = .vertical
        addArrangedSubview({
            let stackView = UIStackView(arrangedSubviews: [messageLabel, onSwitch])
            stackView.axis = .horizontal
            stackView.spacing = CGFloat(14)
            stackView.alignment = .center
            return stackView
        }())
        addArrangedSubview(errorLabel)
        messageLabel.attributedText = message
        messageLabel.numberOfLines = 0
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        onSwitch.setContentHuggingPriority(.required, for: .horizontal)
        onSwitch.onTintColor = ColorPalette.picsiteDeepBlueColor
        showErrorMessage(message: nil)        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureFor(viewModel: Bool) {
        onSwitch.isOn = viewModel
    }
    
    public func showErrorMessage(message: NSAttributedString?) {
        guard let message = message else {
            errorLabel.attributedText = nil
            errorLabel.isHidden = true
            return
        }
        errorLabel.attributedText = message
        errorLabel.isHidden = false
    }
}
