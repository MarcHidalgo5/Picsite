//
//  Created by Marc Hidalgo on 14/5/23.
//

import Foundation
import PicsiteKit; import PicsiteUI
import CoreLocation

public protocol UploadContentDataSourceType {
    func uploadImageToFirebaseStorage(with localImageURL: URL, into picsiteID: Picsite.ID) async throws
    func getClosestPicsite(to location: CLLocation?) async throws -> Picsite?
    func fetchAnnotations() async throws -> BaseMapViewController.VM
}
