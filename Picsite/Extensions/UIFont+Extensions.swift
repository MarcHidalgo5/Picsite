//
//  UIFont+Extensions.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/2/22.
//

import UIKit
import CoreText

enum Fonts {
    case system
    case compact
    
    enum Variant {
        case regular
        case medium
        case bold
    }
    
    func descriptor(variant: Variant = .regular) -> UIFontDescriptor {
        switch self {
        case .system:
            switch variant {
            case .regular:
                let systemFont = UIFont.systemFont(ofSize: 12, weight: .regular)
                return systemFont.fontDescriptor
            case .bold:
                let systemFont = UIFont.systemFont(ofSize: 12, weight: .bold)
                return systemFont.fontDescriptor
            case .medium:
                let systemFont = UIFont.systemFont(ofSize: 12, weight: .medium)
                return systemFont.fontDescriptor
            }
        case .compact:
            let fontName: String = {
                switch variant {
                case .regular:
                    return "SF-Compact-Text-Regular"
                case .medium:
                    return "SF-Compact-Text-Medium"
                case .bold:
                    return "SF-Compact-Text-Bold"
                }
            }()
            
            /// https://stackoverflow.com/a/59471639/1152289
            return UIFontDescriptor(fontAttributes: [
                .name : fontName,
                .featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kStylisticAlternativesType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: 8
                    ],
                ]
            ])
        }
    }
}

