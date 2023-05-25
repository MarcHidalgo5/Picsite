 //
//  Created by Marc Hidalgo on 28/2/22.
//

import Foundation
import BSWFoundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import CoreLocation


public class PicsiteAPIClient {
    
    let environment: PicsiteAPI.Environment
    let firestore = Firestore.firestore()
    
    var userID: String {
        get {
            guard let userID = Auth.auth().currentUser?.uid else { fatalError() }
            return userID
        }
    }
    
    public init(environment: PicsiteAPI.Environment) {
        self.environment = environment
    }
    
    //MARK: Auth
    
    public func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    public func login(with credential: AuthCredential) async throws {
        try await Auth.auth().signIn(with: credential)
    }
    
    public func registerUser(email: String, password: String) async throws -> String {
        return try await Auth.auth().createUser(withEmail: email, password: password).user.uid
    }
    
    public func recoverPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    public func createUser(_ user: User) async throws {
        guard let userID = user.id else { throw LogicError.InvalidUser }
        try await firestore.collection(FirestoreRootCollections.users.rawValue).document(userID).setData(user)
    }
    
    public func isUsernameCurrentlyUsed(username: String) async throws -> Bool {
        let usernameQuery = try await firestore.collection(FirestoreRootCollections.users.rawValue).whereField(FirestoreFields.username.rawValue, isEqualTo: username).getDocuments()
        return !usernameQuery.isEmpty
    }
    
//    public func a() {
//        let hash = GFUtils.geoHash(forLocation: location)
//    }
//    
    //MARK: Map
    
    public func fetchPicsites() async throws -> [Picsite] {
        let query = firestore.collection(FirestoreRootCollections.picsites.rawValue)
        return try await query.fetchAllDocuments()
    }
    
    //MARK: Picsite Profile
    
    public func fetchPicsiteProfile(picsiteID: String) async throws -> Picsite {
        let documentRef = firestore.collection(FirestoreRootCollections.picsites.rawValue).document(picsiteID)
        return try await documentRef.fetchDocument()
    }

    public func fetchPhotoURLs(for picsiteID: String, lastDocument: QueryDocumentSnapshot? = nil) async throws -> PagedResult<PhotoDocument> {
        let query = firestore.collection(FirestoreRootCollections.picsites.rawValue).document(picsiteID).collection(FirestoreCollections.photos.rawValue).order(by: FirestoreFields.createdAt.rawValue, descending: true)
        return try await query.fetchPaged(startAfter: lastDocument)
    }
    
    //MARK: Upload Content
    
    public func uploadImage(into picsiteID: String, localImageURL: URL) async throws {
        let ref = firestore.collection(FirestoreRootCollections.picsites.rawValue).document(picsiteID).collection(FirestoreCollections.photos.rawValue)
        let newDocumentID = ref.document().documentID
        let data = try Data(contentsOf: localImageURL)
        let path = "\(PicsiteAPIClient.FirestoreRootCollections.picsites)/\(picsiteID)/photos/\(newDocumentID).jpeg"
        let downloadURL = try await uploadImageToFirebaseStorage(data: data, at: path)
        let photoDocument = PhotoDocument(_photoURLString: downloadURL.absoluteString, _thumbnailPhotoURLString: downloadURL.absoluteString, createdAt: Date(), userCreatedID: userID)
        try await ref.document(newDocumentID).setData(photoDocument)
        
        let picsiteRef = firestore.collection(FirestoreRootCollections.picsites.rawValue).document(picsiteID)
        try await picsiteRef.updateData([
                "photo_count": FieldValue.increment(Int64(1)),
                "last_activity": FieldValue.serverTimestamp()
            ])
    }
    
    public func uploadPicsite(title: String, geoPoint: GeoPoint, city: String, localImageURL: URL?) async throws {
        let picsiteRef = firestore.collection(FirestoreRootCollections.picsites.rawValue)
        let newPicsiteID = picsiteRef.document().documentID

        var thumbnailURLString: String? = nil
        var imageURLString: String? = nil

        if let imageURL = localImageURL {
            let profilePhotoRef = picsiteRef.document(newPicsiteID).collection(FirestoreCollections.profilePhotos.rawValue)
            let newProfilePhotoID = profilePhotoRef.document().documentID

            let data = try Data(contentsOf: imageURL)
            let path = "\(PicsiteAPIClient.FirestoreRootCollections.picsites)/\(newPicsiteID)/profile_photos/\(newProfilePhotoID).jpeg"
            let downloadURL = try await uploadImageToFirebaseStorage(data: data, at: path)

            thumbnailURLString = downloadURL.absoluteString
            imageURLString = downloadURL.absoluteString

            let photoDocument = PhotoDocument(_photoURLString: downloadURL.absoluteString, _thumbnailPhotoURLString: downloadURL.absoluteString, createdAt: Date(), userCreatedID: userID)

            try await profilePhotoRef.document(newProfilePhotoID).setData(photoDocument)
        }

        let picsite = Picsite(title: title, coordinate: geoPoint, _thumbnailURLString: thumbnailURLString, _imageURLString: imageURLString, location: city)
        try await picsiteRef.document(newPicsiteID).setData(picsite)
    }


    //MARK: Storage
    
    private func uploadImageToFirebaseStorage(data: Data, at path: String) async throws -> URL {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(path)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        try await storageRef.putData(data: data, metadata: metadata)
                
        // After the file is uploaded, get the download URL
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL
    }
}

enum PicsiteAPIError: Swift.Error {
    case userNotFound
    case documentNotFound
}

private extension FirebaseFirestore.DocumentReference {
    func setData<T: Encodable>(_ from: T, merge: Bool = false) async throws {
        let encoder = Firestore.Encoder()
        let data = try encoder.encode(from)
        try await setData(data, merge: merge)
    }
}
