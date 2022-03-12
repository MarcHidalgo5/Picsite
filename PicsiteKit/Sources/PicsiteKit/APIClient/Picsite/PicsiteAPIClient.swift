//
//  PicsiteAPIClient.swift
//  
//
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation

open class PicsiteAPIClient {
    
    let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
    
    /*
     guard let env = environment as? VideoAskAPI.Environment else {
         return nil
     }
     guard let baseURL: URL = {
         switch env {
         case .production:
             return URL(string: "https://app.videoask.com/")!
         case .staging:
             return URL(string: "https://app.dev.videoask.com/")!
         case .development:
             return nil
         }
     }() else { return nil }
     
     return URL(string: "\(baseURL.absoluteString)app/organizations/\(organizationID)/live-call/\(sessionID)#access_token=\(token)")!
     */
}

