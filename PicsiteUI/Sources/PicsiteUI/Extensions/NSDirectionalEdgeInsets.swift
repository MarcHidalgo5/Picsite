//
//  Created by Marc Hidalgo on 11/5/23.
//
#if canImport(UIKit)

import UIKit

extension NSDirectionalEdgeInsets {
    
    public init(uniform: CGFloat) {
        self.init()
        top = uniform
        leading = uniform
        bottom = uniform
        trailing = uniform
    }
}
#endif

