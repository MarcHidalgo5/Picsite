//
//  Created by Marc Hidalgo on 11/01/2022.
//

/// What state the app is in
enum AppState: Equatable {
    /// In this state, there is no user, so the user should login
    case start
    /// In this state, there is a user
    case normal
    /// In this state, async configurations are performing
    case loading
}
