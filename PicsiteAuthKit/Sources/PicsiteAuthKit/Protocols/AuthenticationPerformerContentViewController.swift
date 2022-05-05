//
//  Created by Marc Hidalgo on 5/5/22.
//

import UIKit

protocol AuthenticationPerformerContentViewController: UIViewController {
    func performAuthentication() async throws -> (String)
    func validateFields() throws
    
    var authenticationEmail: String? { get set }
    var authenticationName: String? { get set }
}
