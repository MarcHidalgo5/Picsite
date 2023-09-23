//
//  Created by Marc Hidalgo on 21/8/23.
//

import UIKit
import PicsiteUI; import PicsiteKit
import BSWInterfaceKit

public class UserProfileViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
     
    public init() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Constants {
        static let Spacing: CGFloat = 16
        static let MediumSpacing: CGFloat = 12
    }
    
    private enum Section: Hashable {
        case profileImage
        case information
        case photos
        case loading
    }
    
    private enum ItemID: PagingCollectionViewItem {
        case profileImage(ProfileImageCell.Configuration)
        case information(InformationCell.Configuration)
        case photo(ImageCell.Configuration.ID)
        case loading
        
        public var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
        
        public static func loadingItem() -> UserProfileViewController.ItemID {
            return .loading
        }
    }
    
    public struct VM {
        public init(informationConfig: InformationCell.Configuration, profilePhotoConfig: ProfileImageCell.Configuration, photos: [ImageCell.Configuration]) {
            self.informationConfig = informationConfig
            self.profilePhotoConfig = profilePhotoConfig
            self.photos = photos
        }
        
        let informationConfig: InformationCell.Configuration
        let profilePhotoConfig: ProfileImageCell.Configuration
        var photos: [ImageCell.Configuration]
    }
    
    private let collectionView: UICollectionView
    private var diffDataSource: PagingCollectionViewDiffableDataSource<Section, ItemID>!
    private var emptyView: ErrorView!
    
    private var viewModel: VM!
//    private let currentUser:
    private let mediaPicker = PicsiteMediaPickerBehavior()
    
    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparent
    }
}
