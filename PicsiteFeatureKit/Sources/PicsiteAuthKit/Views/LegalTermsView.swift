//
//  Created by Marc Hidalgo on 4/11/22.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI
import PicsiteKit

class LegalTermsView: UIView {
        
    private let stackView = UIStackView()

    init() {
        super.init(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = AuthenticationPerformerViewController.Constants.Padding
        addSubview(stackView)
        stackView.pinToSuperview()
        
        stackView.addArrangedSubview(_termsAndConditionsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var termsAndConditionsAccepted: Bool {
        get {
            _termsAndConditionsView.onSwitch.isOn
        } set {
            _termsAndConditionsView.onSwitch.setOn(newValue, animated: true)
        }
    }
    
    var termsAndConditionsView: AuthenticationField {
        _termsAndConditionsView
    }
    
    // MARK: Private

    private let _termsAndConditionsView: SwitchField = {
        let message = FontPalette.regularTextStyler
            .attributedString("register-t&c-message".localized, color: ColorPalette.picsiteTitleColor, forSize: 14)
            .addingLink(onSubstring: "register-t&c-message-link".localized, linkURL: URL(string: "https://www.google.es")!, linkColor: ColorPalette.picsiteDeepBlueColor)
            .settingLineHeightMultiplier(1.3)
        return SwitchField(message: message)
    }()
}

