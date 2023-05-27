
import Foundation
import UIKit
import PicsiteKit
import BSWFoundation
import PicsiteAuthKit
import PicsiteMapKit
import PicisteProfileKit
import PicsiteUploadContentKit

/// It is the AppDelegate's responsibility to initialise the world with the correct environment
var Current: World!

struct World {
  
    @UserDefaultsBacked(key: "enhanced-error-logs", defaultValue: DefaultErrorLogsValue)
    var enhancedErrorLogs: Bool!
    
    let environment: PicsiteAPI.Environment
    
    var apiClient: PicsiteAPIClient
    
    let authDataSource: AuthenticationDataSourceType
    
    var mapDataSourceFactory: () -> MapDataSourceType
    
    var picsiteProfileDataSourceFactory: (String) -> PicsiteProfileDataSourceType
    
    var uploadContentDataSourceFactory: () -> UploadContentDataSourceType
    
    init(environment: PicsiteAPI.Environment) {
        self.environment = environment
        self.apiClient = PicsiteAPIClient(environment: environment)
        self.authDataSource = AuthenticationDataSource(apiClient: apiClient, environment: environment)
        self.mapDataSourceFactory = {
            MapDataSource(apiClient: Current.apiClient)
        }
        self.picsiteProfileDataSourceFactory = {
            PicsiteProfileDataSource(picsiteID: $0, apiClient: Current.apiClient)
        }
        self.uploadContentDataSourceFactory = {
            UploadContentDataSource(apiClient: Current.apiClient, mapDataSource: Current.mapDataSourceFactory())
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
