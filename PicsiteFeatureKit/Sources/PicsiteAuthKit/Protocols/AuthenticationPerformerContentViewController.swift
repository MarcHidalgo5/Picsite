//
//  Created by Marc Hidalgo on 5/5/22.
//

import UIKit

protocol AuthenticationPerformerContentViewController: UIViewController {
    func performAuthentication() async throws
    func validateFields() throws
    func animationsFor(errors: AuthenticationPerformerViewController.ValidationErrors) -> [AuthenticationPerformerViewController.ValidationErrorAnimation]
    func disableAllErrorFields()
}

extension AuthenticationPerformerContentViewController {
    func performValidationAnimations(_ animations: [AuthenticationPerformerViewController.ValidationErrorAnimation]) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        animator.addAnimations {
            animations.forEach({ (animation) in
                if let message = animation.message {
                    let attributedMessage = AuthenticationPerformerViewController.attributeErrorString(message)
                    animation.field.showErrorMessage(message: attributedMessage)
                } else {
                    animation.field.showErrorMessage(message: nil)
                }
            })
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}

