//
//  File.swift
//  
//
//  Created by Marc Hidalgo on 5/5/22.
//

import UIKit
import PicsiteUI
import PicsiteKit

class AuthenticationPerformerViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
    enum Mode {
        case login
        case register
    }
    
    private let provider: AuthenticationProviderType
    private weak var observer: AuthenticationObserver!
    private let mode: Mode
    
    var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparent
    }
    init(mode: Mode, provider: AuthenticationProviderType, observer: AuthenticationObserver) {
        self.mode = mode
        self.provider = provider
        self.observer = observer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = ColorPalette.picsiteBackgroundColor
        
        
    }
    
}
