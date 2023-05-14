//
//  Created by Marc Hidalgo on 28/2/22.
//

import BSWFoundation
import Foundation
import UIKit

public enum PicsiteAPI {
    
    public enum PagingConfiguration {
        public static var PageSize: Int = 40
    }
    
    public enum Environment {
        case production
        case development
    }
}

public let PicsiteDateDecodingStrategy: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "Europe/Madrid")
    formatter.locale = Locale(identifier: "es_ES")
    formatter.dateFormat = "dd/MM/yy"
    return formatter
}()
