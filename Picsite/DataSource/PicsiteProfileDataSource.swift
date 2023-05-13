//
//  Created by Marc Hidalgo on 12/5/23.
//

import PicisteProfileKit
import PicsiteKit
import BSWInterfaceKit

class PicsiteProfileDataSource: PicsiteProfileDataSourceType {
    
    let apiClient: PicsiteAPIClient
    
    init(apiClient: PicsiteAPIClient) {
        self.apiClient = apiClient
    }
    
    func fetchPicsiteDetails(picsiteID: String) async throws -> PicsiteProfileViewController.VM {
//        async let photosURLString = apiClient.fetchPicsitePhotosURLStrings(picsiteID: picsiteID)
        async let picsiteDetails = apiClient.fetchPicsiteProfile(picsiteID: picsiteID)
        let picsiteProfileVM = try await picsiteDetails.picsiteProfileVM
        return .init(
            information: picsiteProfileVM.information,
            profilePhoto: picsiteProfileVM.profilePhoto,
            photos: [])
    }
}

private extension Picsite {
    var picsiteProfileVM: (information: PicsiteProfileViewController.InformationCell.Configuration, profilePhoto: Photo) {
        return (
            .init(
                title: self.title,
                subtitle: self.location,
                date: self.lastActivity.dateFormatterString,
                photoCount: String(self.photoCount)
            ), profilePhoto)
    }
    
    var profilePhoto: Photo {
        guard let url = self.imageURLString?.toURL else { return .emptyPhoto() }
        return .init(url: url)
    }
}
