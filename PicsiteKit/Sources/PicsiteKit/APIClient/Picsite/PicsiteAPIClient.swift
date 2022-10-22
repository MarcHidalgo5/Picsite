 //
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation

public class PicsiteAPIClient {
    
    let environment: PicsiteAPI.Environment
    
    open var userID: String?
    
    public init(environment: PicsiteAPI.Environment) {
        self.environment = environment
    }
    
}

