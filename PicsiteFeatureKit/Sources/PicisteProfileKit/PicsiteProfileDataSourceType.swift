  //
//  Created by Marc Hidalgo on 11/5/23.
//

import Foundation

public protocol PicsiteProfileDataSourceType {
    func fetchPicsiteDetails(picsiteID: String) async throws -> PicsiteProfileViewController.VM
}
