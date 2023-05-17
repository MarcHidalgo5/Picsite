//
//  Created by Marc Hidalgo on 17/5/23.
//

import UIKit
import PicsiteUI

public class RoundCheckButtonView: UIView {
    
    let checkButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "checkmark")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        config.baseForegroundColor = ColorPalette.picsiteGreenColor
        config.imagePadding = 10
        let button = UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            print("Botón check presionado")
        }))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorPalette.picsiteSecondaryBackgroundColor
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(checkButton)
        checkButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        roundCorners(radius: 25)
        addPicsiteShadow()
    }
    
    @objc func buttonTapped() {
        print("Botón check presionado")
        // Aquí puedes configurar lo que sucede cuando se toca el botón
    }
}

public class RoundCancelButtonView: UIView {
    
    let cancelButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        config.baseForegroundColor = ColorPalette.picsiteErrorColor
        config.imagePadding = 10
        let button = UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            print("Botón check presionado")
        }))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorPalette.picsiteSecondaryBackgroundColor
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(cancelButton)
        cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        roundCorners(radius: 25)
        addPicsiteShadow()
    }
    
    @objc func buttonTapped() {
        print("Botón check presionado")
        // Aquí puedes configurar lo que sucede cuando se toca el botón
    }
}
