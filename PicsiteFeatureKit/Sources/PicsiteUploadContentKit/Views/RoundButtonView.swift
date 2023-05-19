//
//  Created by Marc Hidalgo on 17/5/23.
//

import UIKit
import PicsiteUI

public class RoundButtonView: UIView {
    
    public var onTapButton: (() -> ())?

    public init(imageButton: UIImage?, color: UIColor) {
        super.init(frame: .zero)
        let cancelButton: UIButton = {
            var config = UIButton.Configuration.plain()
            config.image = imageButton
            config.baseForegroundColor = color
            config.imagePadding = 10
            let button = UIButton(configuration: config, primaryAction: UIAction(handler: { [weak self] _ in
                self?.onTapButton?()
            }))
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = ColorPalette.picsiteSecondaryBackgroundColor
            button.layer.cornerRadius = 25
            button.clipsToBounds = true
            return button
        }()
        
        self.addSubview(cancelButton)
        cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        roundCorners(radius: 25)
        addPicsiteShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        self.onTapButton?()
    }
}
