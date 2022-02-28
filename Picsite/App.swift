
import Foundation
import UIKit
import PicsiteKit

/// It is the AppDelegate's responsibility to initialise the world with the correct environment
var Current: App!

struct App {
  
    var apiClient: PicsiteAPIClient
    
    lazy var authProvider: AuthenticationProviderType = AuthenticationProvider()
    
    init(environement: PicsiteAPI.Environment) {
        self.apiClient = PicsiteAPIClient(environment: environement)
    }
}

