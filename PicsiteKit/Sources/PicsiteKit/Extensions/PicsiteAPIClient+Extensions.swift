//
//  Created by Marc Hidalgo on 4/3/23.
//

import Foundation

public extension PicsiteAPIClient {
    
    enum FirestoreRootCollections: String {
        case users = "users"
        case picsites = "picsites"
    }
    
    enum FirestoreCollections: String {
        case photos = "photos"
        case profilePhotos = "profile_Photos"
    }
    
    enum StoragePath {
        case uploadImageIntoPicsite(picsiteID: String, newDocumentID: String)
        case uploadPicsiteWithProfilePhoto(newPicsiteID: String, newProfilePhotoID: String)
        
        var path: String {
            switch self {
            case .uploadImageIntoPicsite(let picsiteID, let newDocumentID):
                return "\(FirestoreRootCollections.picsites.rawValue)/\(picsiteID)/\(FirestoreCollections.photos.rawValue)/\(newDocumentID).jpeg"
            case .uploadPicsiteWithProfilePhoto(let newPicsiteID, let newProfilePhotoID):
                return "\(FirestoreRootCollections.picsites.rawValue)/\(newPicsiteID)/\(FirestoreCollections.profilePhotos.rawValue)/\(newProfilePhotoID).jpeg"
            }
        }
    }

    
    enum FirestoreFields: String {
        case username = "username"
        case createdAt = "created_at"
        case coordinate = "coordinate"
    }
}
