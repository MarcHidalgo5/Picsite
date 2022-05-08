 //
//  Created by Marc Hidalgo on 8/5/22.
//

import UIKit
import PicsiteKit; import PicsiteUI

extension AuthenticationPerformerViewController {
    
    class LoginViewController: UIViewController, UITextFieldDelegate,
                               AuthenticationPerformerContentViewController {
        func performAuthentication() async throws -> (String) {
            fatalError()
        }
        
        func validateFields() throws {
            fatalError()
        }
        
        func animationsFor(errors: AuthenticationPerformerViewController.ValidationErrors) -> [AuthenticationPerformerViewController.ValidationErrorAnimation] {
            fatalError()
        }
        
        var authenticationEmail: String?
        
        var authenticationName: String?
        
        override func loadView() {
            view = UIView()
            view.backgroundColor = .red
        }
    }
}
