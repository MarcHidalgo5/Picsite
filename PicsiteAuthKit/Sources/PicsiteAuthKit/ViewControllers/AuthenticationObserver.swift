//
//  Created by Marc Hidalgo on 5/5/22.
//

import Foundation; import UIKit
import PicsiteKit

public protocol AuthenticationObserver: AnyObject {
    func didAuthenticate(userID: String, kind: AuthenticationKind)
    func didCancelAuthentication()
}
