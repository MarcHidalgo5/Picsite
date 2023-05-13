//
//  Created by Marc Hidalgo on 12/5/23.
//

import PicisteProfileKit
import PicsiteKit
import BSWInterfaceKit
import Foundation

class PicsiteProfileDataSource: PicsiteProfileDataSourceType {
    
    let apiClient: PicsiteAPIClient
    
    init(apiClient: PicsiteAPIClient) {
        self.apiClient = apiClient
    }
    
    func fetchPicsiteDetails(picsiteID: String) async throws -> PicsiteProfileViewController.VM {
        async let photosURLString = apiClient.fetchPhotoURLs(for: picsiteID)
        async let picsiteDetails = apiClient.fetchPicsiteProfile(picsiteID: picsiteID)
        let picsiteProfileVM = try await picsiteDetails.picsiteProfileVM
        let photos = try await photosURLString.profilePhotosConfig
        return .init(
            informationConfig: picsiteProfileVM.informationConfig,
            profilePhotoConfig: picsiteProfileVM.profilePhotoConfig,
            photos: photos)
    }
}

extension Array where Element == PhotoDocument {
    var profilePhotosConfig: [PicsiteProfileViewController.ImageCell.Configuration] {
        return self.compactMap({
            guard let photoURL = URL(string: $0.photoURLString), let thumnbnailPhotoURL = URL(string: $0.thumbnailPhotoURLString) else { fatalError() }
            return .init(id: $0.id, photo: Photo(url: photoURL), thumbnailPhoto: Photo(url: thumnbnailPhotoURL))
        })
    }
}

private extension Picsite {
    var picsiteProfileVM: (informationConfig: PicsiteProfileViewController.InformationCell.Configuration, profilePhotoConfig: PicsiteProfileViewController.ProfileImageCell.Configuration) {
        return (
            .init(
                title: self.title,
                subtitle: self.location,
                date: self.lastActivity.dateFormatterString,
                photoCount: String(self.photoCount)
            ), .init(photo: profilePhoto))
    }
    
    var profilePhoto: Photo {
        guard let url = self.imageURLString?.toURL else { return .emptyPhoto() }
        return .init(url: url)
    }
}
