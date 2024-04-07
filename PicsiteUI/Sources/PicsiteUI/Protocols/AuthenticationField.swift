//
//  Created by Marc Hidalgo on 5/11/22.
//

import UIKit

public protocol AuthenticationField: UIView {
    func showErrorMessage(message: NSAttributedString?)
}
