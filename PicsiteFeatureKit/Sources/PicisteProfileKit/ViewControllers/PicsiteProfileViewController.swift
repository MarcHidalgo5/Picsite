//
//  Created by Marc Hidalgo on 11/5/23.
//

import UIKit
import PicsiteUI
import BSWInterfaceKit

public class PicsiteProfileViewController: UIViewController {
    
    private enum Section: Hashable {
        case main
    }
    
    private enum ItemID: PagingCollectionViewItem {
        case information
        case photos
        case loading
        
        public var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
        
        public static func loadingItem() -> ItemID {
            return .loading
        }
    }
    
    private var collectionView: UICollectionView!
    private var diffableDataSource: PagingCollectionViewDiffableDataSource<Section, ItemID>!
    
    public init() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        view = UIView()
        collectionView.backgroundColor = ColorPalette.picsiteBackgroundColor
        collectionView.delegate = self
        view.addAutolayoutSubview(collectionView)
        collectionView.pinToSuperview()
    }
    
    private func createDataSource() {
        
    }
    
    private func configureFor() {
        
    }
}

extension PicsiteProfileViewController: UICollectionViewDelegate {
    
}
