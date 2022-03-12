
import Foundation
import UIKit
import PicsiteKit
import BSWFoundation

/// It is the AppDelegate's responsibility to initialise the world with the correct environment
var Current: World!

struct World {
  
    @UserDefaultsBacked(key: "enhanced-error-logs", defaultValue: DefaultErrorLogsValue)
    var enhancedErrorLogs: Bool!
    
    let environment: PicsiteAPI.Environment
    
    var apiClient: PicsiteAPIClient
    
    lazy var authProvider: AuthenticationProviderType = AuthenticationProvider(environment: environment)
    
    init(environment: PicsiteAPI.Environment) {
        self.environment = environment
        self.apiClient = PicsiteAPIClient(environment: environment)
    }
}

private let DefaultErrorLogsValue: Bool = {
    #if APPSTORE
    return false
    #else
    return true
    #endif
}()
