  //
//  Created by Marc Hidalgo on 11/5/23.
//

import Foundation

public protocol PicsiteProfileDataSourceType {
    
    var picsiteID: String { get }
    
    var morePagesAreAvailable: Bool { get }
    func fetchPicsiteDetails() async throws -> PicsiteProfileViewController.VM
    func fetchPhotosNextPage() async throws -> [PicsiteProfileViewController.ImageCell.Configuration]
}
