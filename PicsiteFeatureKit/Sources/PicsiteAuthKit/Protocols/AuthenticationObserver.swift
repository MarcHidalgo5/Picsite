//
//  Created by Marc Hidalgo on 5/5/22.
//

import Foundation; import UIKit
import PicsiteKit

@MainActor
public protocol AuthenticationObserver: AnyObject {
    func didAuthenticate(kind: AuthenticationPerformerKind)
    func didCancelAuthentication()
}
