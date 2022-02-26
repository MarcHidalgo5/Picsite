//
//  FontPalette.swift
//  
//
//  Created by Marc Hidalgo on 26/2/22.
//

import UIKit
import BSWInterfaceKit

/// Please hook this up from the host app
public enum FontPalette {
    public static var regularTextStyler: TextStyler!
    public static var mediumTextStyler: TextStyler!
    public static var boldTextStyler: TextStyler!
}

public extension TextStyler {
    
    func attributedString(_ string: String, color: UIColor? = nil, forSize size: CGFloat) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key : Any] = [
            .font: fontForSize(size)
        ]
        if let color = color {
            attributes[.foregroundColor] = color
        }
        return NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    func fontForSize(_ size: CGFloat) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size)
        guard let fontDescriptor = self.fontDescriptor else {
            return systemFont
        }
        return UIFont.init(descriptor: fontDescriptor, size: size)
    }
}
