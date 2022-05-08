//
//  Created by Marc Hidalgo on 7/5/22.
//

import UIKit
import BSWInterfaceKit

public class ActionButtonContainerView: UIView {
     
    enum Constants {
        static let LayoutMargins = UIEdgeInsets(top: 5, left: 62, bottom: 5, right: 62)
    }
    
    public let actionButton = PicsiteButton(color: ColorPalette.picsiteTintColor)
    
    public init(actionTitle: String) {
        super.init(frame: .zero)
        
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.layoutMargins = Constants.LayoutMargins
        stackView.addArrangedSubview(actionButton)
        
        stackView.roundCorners()
        
        addAutolayoutSubview(stackView)
        stackView.pinToSuperviewLayoutMargins()
        
        actionButton.stringAttributes[.foregroundColor] = ColorPalette.picsiteButtonTitleColor
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        actionButton.setTitle(actionTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
