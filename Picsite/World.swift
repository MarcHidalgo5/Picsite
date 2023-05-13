
import Foundation
import UIKit
import PicsiteKit
import BSWFoundation
import PicsiteAuthKit
import PicsiteMapKit
import PicisteProfileKit

/// It is the AppDelegate's responsibility to initialise the world with the correct environment
var Current: World!

struct World {
  
    @UserDefaultsBacked(key: "enhanced-error-logs", defaultValue: DefaultErrorLogsValue)
    var enhancedErrorLogs: Bool!
    
    let environment: PicsiteAPI.Environment
    
    var apiClient: PicsiteAPIClient
    
    let authDataSource: AuthenticationDataSourceType
    
    var mapDataSourceFactory: () -> MapDataSourceType
    
    var picsiteProfileDataSourceFactory: () -> PicsiteProfileDataSourceType
    
    init(environment: PicsiteAPI.Environment) {
        self.environment = environment
        self.apiClient = PicsiteAPIClient(environment: environment)
        self.authDataSource = AuthenticationDataSource(apiClient: apiClient, environment: environment)
        self.mapDataSourceFactory = {
            MapDataSource(apiClient: Current.apiClient)
        }
        self.picsiteProfileDataSourceFactory = {
            PicsiteProfileDataSource(apiClient: Current.apiClient)
        }
    }
}

private let DefaultErrorLogsValue: Bool = {
    #if APPSTORE
    return false
    #else
    return true
    #endif
}()
