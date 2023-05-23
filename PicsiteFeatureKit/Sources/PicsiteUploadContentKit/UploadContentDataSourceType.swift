//
//  Created by Marc Hidalgo on 14/5/23.
//

import Foundation
import PicsiteKit
import CoreLocation

public protocol UploadContentDataSourceType {
    func uploadImageToFirebaseStorage(with localImageURL: URL, into picsiteID: Picsite.ID) async throws
    func getPicsite(for location: CLLocation) -> Picsite
}
