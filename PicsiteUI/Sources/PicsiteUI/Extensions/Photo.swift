//
//  File.swift
//  
//
//  Created by Marc Hidalgo on 13/5/23.
//

import Foundation
import BSWInterfaceKit
import UIKit

public extension Photo {
    
    static func createPhoto(withURL url: URL?, placeholderImage: PlaceholderImage? = nil, size: CGSize? = nil, preferredContentMode: UIView.ContentMode? = nil) -> Photo {
        return Photo(url: url, averageColor: ColorPalette.picsiteDeepBlueColor.withAlphaComponent(0.2), placeholderImage: placeholderImage, size: size, preferredContentMode: preferredContentMode)
    }
    
    static func createEmptyPhoto() -> Photo {
        return Photo(kind: .empty, averageColor: ColorPalette.picsiteDeepBlueColor.withAlphaComponent(0.2), size: nil)
    }
}
