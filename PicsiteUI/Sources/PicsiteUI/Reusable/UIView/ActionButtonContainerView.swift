//
//  Created by Marc Hidalgo on 7/5/22.
//

import UIKit
import BSWInterfaceKit

public class ActionButtonContainerView: UIView {
    
    public let actionButton = PicsiteButton(color: ColorPalette.picsiteDeepBlueColor)
    
    public init(actionTitle: String) {
        super.init(frame: .zero)

        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.addArrangedSubview(actionButton)
        
        stackView.roundCorners()
        
        addAutolayoutSubview(stackView)
        stackView.pinToSuperviewLayoutMargins()
        
        actionButton.stringAttributes[.foregroundColor] = ColorPalette.picsiteButtonTitleColor
            
        actionButton.setTitle(actionTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
