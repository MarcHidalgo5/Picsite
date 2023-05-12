//
//  Created by Marc Hidalgo on 11/5/23.
//

import UIKit
import PicsiteUI
import BSWInterfaceKit

public class PicsiteProfileViewController: UIViewController {
    
    enum Constants {
        static let Spacing: CGFloat = 16
        static let MediumSpacing: CGFloat = 8
    }
    
    private enum Section: Hashable {
        case profileImage
        case information
        case photos
        case loading
    }
    
    private enum ItemID: PagingCollectionViewItem {
        case profileImage
        case information
        case photo
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
    private var diffDataSource: PagingCollectionViewDiffableDataSource<Section, ItemID>!
    
    public init() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        view = UIView()
        collectionView.backgroundColor = ColorPalette.picsiteBackgroundColor
        collectionView.delegate = self
        view.addAutolayoutSubview(collectionView)
        collectionView.pinToSuperview()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        createDataSource()
        Task { @MainActor in
            await configureFor()
        }
    }
    
    private func createDataSource() {
        
        let imageCellRegistration = ImageCell.View.defaultCellRegistration()
        let informationCellRegistration = InformationCell.View.defaultCellRegistration()
        
        diffDataSource = .init(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { fatalError() }
            switch itemIdentifier {
            case .profileImage:
                let config = ImageCell.Configuration(photo: .emptyPhoto())
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: config)
            case .information:
                let config = InformationCell.Configuration(title: "La seu vella", subtitle: "Lleida", date: "22/09/22", photoCount: "10")
                return collectionView.dequeueConfiguredReusableCell(using: informationCellRegistration, for: indexPath, item: config)
            case .photo:
                fatalError()
            case .loading:
                fatalError()
            }
        })
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { view, _, indexPath in
            var configuration = UIListContentConfiguration.plainHeader()
            let _conf: (text: String, spacing: CGFloat) = {
                return ("", 0)
            }()
            configuration.attributedText = FontPalette.mediumTextStyler.attributedString(
                _conf.text,
                color: ColorPalette.picsiteTitleColor,
                forStyle: .headline
            )
            configuration.directionalLayoutMargins = .init(uniform: 0)
            view.contentConfiguration = configuration
        }
        diffDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath
            )
        }
        
        let layout = UICollectionViewCompositionalLayout { [weak self] rawValue, layoutEnviroment in
            guard let self = self else { return Self.emptyLayout }
            let snapshot = self.diffDataSource.snapshot()
            let section = snapshot.sectionIdentifiers[rawValue]
            switch section {
            case .profileImage: return .list(using: Self.imageProfileLayout, layoutEnvironment: layoutEnviroment)
            case .information: return .list(using: Self.informationLayout, layoutEnvironment: layoutEnviroment)
            case .photos: return Self.photosLayout
            case .loading: return Self.loadingLayout
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    private func configureFor() async {
        var snapshot = diffDataSource.snapshot()
        snapshot.appendSections([.profileImage,.information])
        snapshot.appendItems([.profileImage], toSection: .profileImage)
        snapshot.appendItems([.information], toSection: .information)
        await diffDataSource.apply(snapshot)
    }
}

extension PicsiteProfileViewController: UICollectionViewDelegate {
    
}

private extension PicsiteProfileViewController {
    
    static var emptyLayout: NSCollectionLayoutSection {
        .init(group: .init(layoutSize: .init(widthDimension: .absolute(0), heightDimension: .absolute(0))))
    }
    
    static var loadingLayout: NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 25, leading: Constants.Spacing, bottom: Constants.Spacing, trailing: Constants.Spacing)
        section.interGroupSpacing = Constants.Spacing
        return section
    }
    
    static var photosLayout: NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: Constants.Spacing, bottom: Constants.Spacing, trailing: Constants.Spacing)
        section.interGroupSpacing = Constants.Spacing
//        section.addHeaderElement(estimatedHeight: 46)
        return section
    }
    
    static var imageProfileLayout: UICollectionLayoutListConfiguration {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.showsSeparators = true
        config.backgroundColor = ColorPalette.picsiteBackgroundColor
        config.headerTopPadding = 0
        config.headerMode = .supplementary
        return config
    }
    
    static var informationLayout: UICollectionLayoutListConfiguration {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.showsSeparators = true
        config.backgroundColor = ColorPalette.picsiteBackgroundColor
        config.headerTopPadding = 0
        config.headerMode = .supplementary
        return config
    }
}
