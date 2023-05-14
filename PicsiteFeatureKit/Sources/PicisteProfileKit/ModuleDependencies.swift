//
//  Created by Marc Hidalgo on 11/5/23.
//

import Foundation

public enum ModuleDependencies {
    public static var dataSource: (String) -> PicsiteProfileDataSourceType = { _ in fatalError() }
}
