//
//  Created by Marc Hidalgo on 22/3/23.
//

#if canImport(UIKit)

import UIKit

public extension UIScreen {
    var smallestScreen: Bool {
        return self.bounds.width <= 380
    }
}
#endif
