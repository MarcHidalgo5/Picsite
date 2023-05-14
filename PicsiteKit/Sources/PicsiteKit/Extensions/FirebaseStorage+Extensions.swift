//
//  Created by Marc Hidalgo on 15/5/23.
//

import Foundation
import FirebaseStorage

public extension StorageReference {
    func putData(data: Data, metadata: StorageMetadata) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.putData(data, metadata: metadata) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
