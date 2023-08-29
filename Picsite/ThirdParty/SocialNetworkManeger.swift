//
//  Created by Marc Hidalgo on 3/5/22.
//

import BSWFoundation
import GoogleSignIn
import PicsiteAuthKit
import PicsiteKit
import Firebase

class SocialNetworkManager: NSObject, UIApplicationDelegate, AuthenticationManagerSocialType {
    
    static let shared = SocialNetworkManager()
    
    private lazy var googleProvider: GIDSignIn = { GIDSignIn.sharedInstance }()
    
    func fetchSocialNetworkInfo(forSocialType socialType: AuthenticationManagerSocial, fromVC: UIViewController) async throws -> AuthenticationManagerSocialInfo {
        
        switch socialType {
        case .apple:
            //Implement this
            fatalError()
        case .google:
            guard let clientID = FirebaseApp.app()?.options.clientID else { fatalError() }
            return try await fetchGoogleData(clientID: clientID, fromVC: fromVC)
        }
    }
}

// MARK: Google
    
private extension SocialNetworkManager {
    func fetchGoogleData(clientID: String, fromVC: UIViewController) async throws -> AuthenticationManagerSocialInfo {
        try await withCheckedThrowingContinuation { cont in
            let googleSignInConfig = GIDConfiguration(clientID: clientID)
            googleProvider.signIn(with: googleSignInConfig, presenting: fromVC) { user, error in
                guard error == nil else {
                    let nsError = error! as NSError
                    if nsError.domain == "com.google.GIDSignIn", nsError.code == -5 {
                        cont.resume(throwing: AuthenticationManagerError.userCanceled)
                    } else {
                        cont.resume(throwing: error!)
                    }
                    return
                }
                
                guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
                let accessToken = authentication.accessToken
                cont.resume(returning: (idToken, accessToken))
            }
        }
    }
}
