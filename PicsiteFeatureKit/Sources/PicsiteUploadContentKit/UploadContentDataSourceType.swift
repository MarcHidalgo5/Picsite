//
//  Created by Marc Hidalgo on 14/5/23.
//

import Foundation

public protocol UploadContentDataSourceType {
    func uploadImageToFirebaseStorage(with localImageURL: URL) async throws -> URL
}
