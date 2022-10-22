 //
//  Created by Marc Hidalgo on 12/5/22.
//

import UIKit
import BSWInterfaceKit
import BSWFoundation

public extension UIButton {

    override func addPicsiteShadow() {
        super.addPicsiteShadow()
        /// Altough this constraint is not working, it's triggering
        /// `layoutSubviews` on the UIButton subclass instead
        /// that doing it on UIButtonLabel. Seems like UIButton is doing
        /// tricks to optimize performance and those are breaking the
        /// whole `bsw_shadowInfo` integration
        let constraint = imageView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20)
        constraint.priority = .defaultLow
        constraint.isActive = true
    }
}
