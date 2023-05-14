//
//  Created by Marc Hidalgo on 12/5/23.
//

import Foundation
import PicsiteKit

public extension Date {
    var dateFormatterString: String {
        return PicsiteDateDecodingStrategy.string(from: self)
    }
    
    func days(toDate: Date?) -> Int? {
        guard let toDate = toDate else { return nil }
        return Calendar.current.dateComponents([.day], from: self, to: toDate).day
    }
}

public extension Optional where Wrapped == Date {
    var dateFormatterString: String {
        guard let lastActivity = self else { return "" }
        return PicsiteDateDecodingStrategy.string(from: lastActivity)
    }
}
