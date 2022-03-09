//
//  PicsiteAPI.swift
//  
//
//  Created by Marc Hidalgo on 28/2/22.
//

import BSWFoundation
import Foundation
import UIKit

public enum PicsiteAPI {
    
    public enum PagingConfiguration {
        public static var PageSize: Int = 20
    }
    
    public enum Environment: BSWFoundation.Environment {
        case production
        case development
        
        public var baseURL: URL {
            switch self {
            case .production:
                fatalError()
            case .development:
                fatalError()
            }
        }
    }
}

let VideoAskDateDecodingStrategy: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
    return formatter
}()

