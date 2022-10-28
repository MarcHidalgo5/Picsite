 //
//  Created by Marc Hidalgo on 12/5/22.
//

import UIKit
import BSWInterfaceKit
import BSWFoundation

public extension UIButton {

    override func addPicsiteShadow() {
        super.addPicsiteShadow()
        let constraint = imageView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20)
        constraint.priority = .defaultLow
        constraint.isActive = true
    }
}
