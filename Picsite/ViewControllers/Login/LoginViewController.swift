//
//  LoginViewController.swift
//  Picsite
//
//  Created by Marc Hidalgo on 26/2/22.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI
import PicsiteKit

class LoginViewController: UIViewController {
    
    private let provider: AuthenticationProviderType
    
    public init(provider: AuthenticationProviderType) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { @MainActor in
            do {
                let user = try await provider.loginUser(email: "marchidalgo@icloud.com", password: "123456789")
//                print(user.email)
//                print(user.displayName)
                let vc = HomeViewController()
                show(vc, sender: nil)
            } catch {
                print("There was an issue when trying to sign in: \(error)")
            }
        }
    }
}
