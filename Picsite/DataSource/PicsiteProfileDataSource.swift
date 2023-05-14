//
//  Created by Marc Hidalgo on 12/5/23.
//

import PicisteProfileKit
import PicsiteKit
import BSWInterfaceKit
import Foundation

class PicsiteProfileDataSource: PicsiteProfileDataSourceType {
    
    struct NoPagingAvailable: Swift.Error { }
    
    let apiClient: PicsiteAPIClient
    
    private var pagingInfo: PagingInfo!
    
    let picsiteID: String
    
    init(picsiteID: String, apiClient: PicsiteAPIClient) {
        self.picsiteID = picsiteID
        self.apiClient = apiClient
    }
    
    var morePagesAreAvailable: Bool {
        return self.pagingInfo?.morePagesAreAvailable ?? false
    }
    
    func fetchPicsiteDetails() async throws -> PicsiteProfileViewController.VM {
        self.pagingInfo = PagingInfo()
        async let photosURLString = apiClient.fetchPhotoURLs(for: self.picsiteID)
        async let picsiteDetails = apiClient.fetchPicsiteProfile(picsiteID: self.picsiteID)
        let picsiteProfileVM = try await picsiteDetails.picsiteProfileVM
        let photoURLsResults = try await photosURLString
        let photos = photoURLsResults.photos.profilePhotosConfig
        self.pagingInfo.morePagesAreAvailable = photoURLsResults.morePageAvaliable
        self.pagingInfo.lastDocument = photoURLsResults.lastDocument
        return .init(
            informationConfig: picsiteProfileVM.informationConfig,
            profilePhotoConfig: picsiteProfileVM.profilePhotoConfig,
            photos: photos)
    }
    
    func fetchPhotosNextPage() async throws -> [PicsiteProfileViewController.ImageCell.Configuration] {
        guard morePagesAreAvailable else {
           throw NoPagingAvailable()
        }
        let photosURLsString = try await apiClient.fetchPhotoURLs(for: self.picsiteID, startAfter: pagingInfo.lastDocument)
        self.pagingInfo.morePagesAreAvailable = photosURLsString.morePageAvaliable
        self.pagingInfo.lastDocument = photosURLsString.lastDocument
        return photosURLsString.photos.profilePhotosConfig
    }
}

extension Array where Element == PhotoURLsResult.PhotoDocument {
    var profilePhotosConfig: [PicsiteProfileViewController.ImageCell.Configuration] {
        return self.compactMap({
            guard let photoURL = $0.photoURL, let thumnbnailPhotoURL = $0.thumbnailPhotoURL else { fatalError() }
            return .init(id: $0.id, photo: Photo.createWithDeepBlueColor(withURL: photoURL), thumbnailPhoto: Photo.createWithDeepBlueColor(withURL: thumnbnailPhotoURL))
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
        return Photo.createWithDeepBlueColor(withURL: url)
    }
}
