//
//  Created by Marc Hidalgo on 14/5/23.
//

import Foundation

public protocol UploadContentDataSourceType {
    func uploadImageToFirebaseStorage(data: Data, at path: String) async throws -> URL
}
