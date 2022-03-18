 //
//  Created by Marc Hidalgo on 18/3/22.
//

import UIKit

public class GradientView: UIView {
    
    public class func blackGradient() -> GradientView {
        let gradientView = GradientView(frame: .zero)
        gradientView.startPoint = 0.5
        gradientView.topColor = .clear
        gradientView.bottomColor = .black
        return gradientView
    }

    public class func deepPurpleGradient() -> GradientView {
        let gradientView = GradientView(frame: .zero)
        gradientView.startPoint = 0.9
        gradientView.topColor = .clear
        gradientView.bottomColor = ColorPalette.picsiteTintColor
        return gradientView
    }

    public var startPoint: Float = 0 {
        didSet {
            updateGradientColors()
        }
    }

    public var topColor: UIColor = .white {
        didSet {
            updateGradientColors()
        }
    }
    
    public var bottomColor: UIColor = .black {
        didSet {
            updateGradientColors()
        }
    }
        
    private let gradientLayer = CAGradientLayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        isUserInteractionEnabled = false
        layer.addSublayer(gradientLayer)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateGradientColors()
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [topColor.cgColor,  bottomColor.cgColor]
        gradientLayer.locations = [0, NSNumber(value: startPoint)]
    }
    
}

//
//  Created by Nathan Gitter on 7/15/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

public class ThreePointGradientView: UIView {
    
    public var topColor: UIColor = .white {
        didSet {
            updateGradientColors()
        }
    }

    public var middleColor: UIColor = .white {
        didSet {
            updateGradientColors()
        }
    }

    public var bottomColor: UIColor = .black {
        didSet {
            updateGradientColors()
        }
    }
        
    private let gradientLayer = CAGradientLayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        isUserInteractionEnabled = false
        layer.addSublayer(gradientLayer)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateGradientColors()
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, NSNumber(value: 0.5), 1]
    }
    
}

