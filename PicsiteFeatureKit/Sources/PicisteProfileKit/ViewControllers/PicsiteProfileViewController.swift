//
//  Created by Marc Hidalgo on 11/5/23.
//

import UIKit
import PicsiteUI; import PicsiteKit
import BSWInterfaceKit
import PicsiteUploadContentKit

public class PicsiteProfileViewController: UIViewController, TransparentNavigationBarPreferenceProvider {
    
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
        
        public static func loadingItem() -> ItemID {
            return .loading
        }
    }
    
    public struct VM {
        public init(informationConfig: PicsiteProfileViewController.InformationCell.Configuration, profilePhotoConfig: ProfileImageCell.Configuration, photos: [ImageCell.Configuration]) {
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
    private let currentPicsite: Picsite
    private let mediaPicker = PicsiteMediaPickerBehavior()
    
    private let dataSource: PicsiteProfileDataSourceType
    
    public init(picsite: Picsite) {
        self.currentPicsite = picsite
        self.dataSource = ModuleDependencies.dataSource(picsite.id)
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
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        addPlainBackButton()
        createDataSource()
        fetchData()
    }
    
    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparent
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func fetchData() {
        fetchData {
            try await self.dataSource.fetchPicsiteDetails()
        } completion: { [weak self] vm in
            await self?.configureFor(viewModel: vm)
        }
    }
    
    private func createDataSource() {
        
        let imageCellRegistration = ProfileImageCell.View.defaultCellRegistration()
        let informationCellRegistration = InformationCell.View.defaultCellRegistration()
        let photoCellRegistration = ImageCell.ThumbnailPhotoView.defaultCellRegistration()
        let loadingRegistration = UICollectionView.CellRegistration<GridLoadingCell, ItemID> { (cell, indexPath, vm) in
            guard case .loading = vm else { fatalError() }
            cell.accessories = []
        }
        
        diffDataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .profileImage(let config):
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: config)
            case .information(let config):
                return collectionView.dequeueConfiguredReusableCell(using: informationCellRegistration, for: indexPath, item: config)
            case .photo(let id):
                guard var config = self.viewModel.photos.first(where: { $0.id == id }) else { fatalError() }
                config.isThumbnail = true
                return collectionView.dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: config)
            case .loading:
                return collectionView.dequeueConfiguredReusableCell(using: loadingRegistration, for: indexPath, item: itemIdentifier)
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
            guard let self = self else { fatalError() }
            let snapshot = self.diffDataSource.snapshot()
            let section = snapshot.sectionIdentifiers[rawValue]
            switch section {
            case .profileImage: return Self.imageProfileLayout
            case .information: return Self.informationLayout
            case .photos: return Self.photosLayout
            case .loading: return Self.loadingLayout
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: false)
        configureDataSource()
    }
    
    private func addEmptyViewIfNecessary(photos: [ImageCell.Configuration]) {
        if emptyView != nil {
            emptyView.removeFromSuperview()
            emptyView = nil
        }
        if photos.isEmpty {
            emptyView = .init(config: createEmptyConfiguration())
            view.addAutolayoutSubview(emptyView)
            view.layoutMargins = UIEdgeInsets(uniform: Constants.Spacing)
            NSLayoutConstraint.activate([
                view.layoutMarginsGuide.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20),
                view.layoutMarginsGuide.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor),
                view.layoutMarginsGuide.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor),
            ])
            collectionView.isScrollEnabled = false
        } else {
            collectionView.isScrollEnabled = true
        }
    }
    private func createEmptyConfiguration() -> ErrorView.Configuration {
        return .init(title: FontPalette.mediumTextStyler.attributedString("picsite-profile-empty-photos-error".localized, color: ColorPalette.picsiteTitleColor, forSize: 16).settingParagraphStyle {
            $0.alignment = .center
        }, button: .fillButton(withTitle: "picsite-profile-empty-photos-button-title".localized, handler: { [weak self] in
            self?.onSelectPhoto()
        }))
    }
    
    private func onSelectPhoto() {
        Task { @MainActor in
            guard let imageData = await self.mediaPicker.getMedia(fromVC: self, kind: .photo, source: .photoAlbum), imageData.localURL != nil else { return }
            let vc = UploadPhotoConfirmationViewController(imageData: imageData, selectedPicsite: self.currentPicsite)
            self.show(vc, sender: self)
        }
    }
    
    private func configureDataSource() {
        diffDataSource.pullToRefreshProvider = .init(tintColor: ColorPalette.picsiteTitleColor, fetchHandler: { [weak self] snapshot in
            await self?.handlePullToRefresh(snapshot: &snapshot)
        })
    }

    private func prepareForInfinitePages() {
        if dataSource.morePagesAreAvailable {
            diffDataSource.infiniteScrollProvider = .init(fetchHandler: { [weak self] snapshot in
                guard let self else { return false }
                return await self.fetchNextPage(snapshot: &snapshot)
            })
        } else {
            diffDataSource.infiniteScrollProvider = nil
        }
    }
    
    private func fetchNextPage(snapshot: inout NSDiffableDataSourceSnapshot<Section,ItemID>) async -> Bool {
        do {
            let photos = try await dataSource.fetchPhotosNextPage()
            self.viewModel.photos.append(contentsOf: photos)
            photos.forEach({
                snapshot.appendItems([.photo($0.id)])
            })
            return dataSource.morePagesAreAvailable
        } catch {
            self.showErrorAlert(error.localizedDescription, error: error)
            return true
        }
    }
    
    private func handlePullToRefresh(snapshot: inout NSDiffableDataSourceSnapshot<Section, ItemID>) async {
        do {
            self.viewModel = try await self.dataSource.fetchPicsiteDetails()
            snapshot.deleteSections([.profileImage, .information, .photos])
            snapshot.appendSections([.profileImage,.information, .photos])
            snapshot.appendItems([.profileImage(viewModel.profilePhotoConfig)], toSection: .profileImage)
            snapshot.appendItems([.information(viewModel.informationConfig)], toSection: .information)
            viewModel.photos.forEach({
                snapshot.appendItems([.photo($0.id)], toSection: .photos)
            })
            prepareForInfinitePages()
        } catch {
            showErrorAlert("error".localized, error: error)
        }
    }

    private func configureFor(viewModel: VM) async {
        self.viewModel = viewModel
        var snapshot = diffDataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.profileImage,.information, .photos])
        snapshot.appendItems([.profileImage(viewModel.profilePhotoConfig)], toSection: .profileImage)
        snapshot.appendItems([.information(viewModel.informationConfig)], toSection: .information)
        viewModel.photos.forEach({
            snapshot.appendItems([.photo($0.id)], toSection: .photos)
        })
        await diffDataSource.apply(snapshot)
        addEmptyViewIfNecessary(photos: viewModel.photos)
        prepareForInfinitePages()
    }
}

extension PicsiteProfileViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = diffDataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .profileImage(let config):
            guard let image = config.photo.uiImage else { return }
            let previewVC = ImagePreviewViewController()
            previewVC.image = image
            let navVC = MinimalNavigationController(rootViewController: previewVC)
            present(navVC, animated: true, completion: nil)
        case .photo(let id):
            guard let imageConfiguration = viewModel.photos.filter({ $0.id == id }).first, let image = imageConfiguration.photo.uiImage else { return }
            let previewVC = ImagePreviewViewController()
            previewVC.image = image
            let navVC = MinimalNavigationController(rootViewController: previewVC)
            present(navVC, animated: true, completion: nil)
        default:
            return
        }
    }
}

private extension PicsiteProfileViewController {
    
    static var loadingLayout: NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: Constants.Spacing, leading: Constants.Spacing, bottom: Constants.Spacing, trailing: Constants.Spacing)
        section.interGroupSpacing = Constants.Spacing
        return section
    }
    
    static var photosLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let spacing = NSCollectionLayoutSpacing.fixed(Constants.Spacing)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = spacing
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.MediumSpacing, leading: Constants.MediumSpacing, bottom: Constants.MediumSpacing, trailing: Constants.MediumSpacing)
        section.interGroupSpacing = Constants.MediumSpacing / 2
        return section
    }
    
    static var informationLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: Constants.MediumSpacing, leading: Constants.MediumSpacing, bottom: 0, trailing: Constants.MediumSpacing)
        return section
    }
    
    static var imageProfileLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: UIScreen.main.smallestScreen ? -70 : -100, leading: 0, bottom: 0, trailing: 0)
        return section
    }
}

