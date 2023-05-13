//
//  Created by Marc Hidalgo on 12/5/23.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI

extension PicsiteProfileViewController {
    
    public enum ProfileImageCell {
        
        public struct Configuration: UIContentConfiguration, Hashable {
             let photo: Photo
            
            private(set) var state: UICellConfigurationState?
            
            public init(photo: Photo, state: UICellConfigurationState? = nil) {
                self.photo = photo
                self.state = state
            }

            public func makeContentView() -> UIView & UIContentView {
                View(configuration: self)
            }
            
            public func updated(for state: UIConfigurationState) -> Configuration {
                var mutableCopy = self
                if let cellState = state as? UICellConfigurationState {
                    mutableCopy.state =  cellState
                }
                return mutableCopy
            }
        }
        
        @objc(ImageCellView)
        class View: UIView, UIContentView {
            
            private let imageView = UIImageView()
            
            var configuration: UIContentConfiguration {
                didSet {
                    guard let config = configuration as? Configuration,
                          let oldConfig = oldValue as? Configuration,
                          config != oldConfig
                    else { return }
                    configureFor(configuration: config)
                }
            }
            
            init(configuration: Configuration) {
                self.configuration = configuration
                super.init(frame: .zero)
                backgroundColor = .white
                    
                imageView.contentMode = .scaleAspectFill
                addAutolayoutSubview(imageView)
                imageView.pinToSuperview()
                
                roundCorners(radius: 2)
                
                let darkOverlayView = UIView(frame: imageView.bounds)
                darkOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                darkOverlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                imageView.addSubview(darkOverlayView)
                
                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalToConstant: 300)
                ])
                
                configureFor(configuration: configuration)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            private func configureFor(configuration: Configuration){
                imageView.setPhoto(configuration.photo)
            }
        }
    }
    
    public enum InformationCell {
        
        public struct Configuration: UIContentConfiguration, Hashable {
            let title: String
            let subtitle: String
            let date: String
            let photoCount: String
            
            private(set) var state: UICellConfigurationState?
            
            public init(title: String, subtitle: String, date: String, photoCount: String, state: UICellConfigurationState? = nil) {
                self.title = title
                self.subtitle = subtitle
                self.date = date
                self.photoCount = photoCount
                self.state = state
            }
            
            public func makeContentView() -> UIView & UIContentView {
                View(configuration: self)
            }
            
            public func updated(for state: UIConfigurationState) -> Configuration {
                var mutableCopy = self
                if let cellState = state as? UICellConfigurationState {
                    mutableCopy.state =  cellState
                }
                return mutableCopy
            }
        }
        
        @objc(AnnotationCellView)
        class View: UIView, UIContentView {
                        
            let titleLabel: UILabel = {
                let label = UILabel()
                label.numberOfLines = 1
                label.textAlignment = .center
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.9
                return label
            }()
            
            let dateLabel: UILabel = {
                let label = UILabel()
                label.numberOfLines = 1
                label.textAlignment = .center
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.9
                label.textColor = ColorPalette.picsitePlaceholderColor
                return label
            }()
            
            private let subtitleLabel: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.numberOfLines = 0
                label.textAlignment = .center
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.9
                return label
            }()
            
            private let photoCountLabel: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.minimumScaleFactor = 0.8
                return label
            }()
            
            var configuration: UIContentConfiguration {
                didSet {
                    guard let config = configuration as? Configuration,
                          let oldConfig = oldValue as? Configuration,
                          config != oldConfig
                    else { return }
                    configureFor(configuration: config)
                }
            }
            
            init(configuration: Configuration) {
                self.configuration = configuration
                super.init(frame: .zero)
                backgroundColor = ColorPalette.picsiteBackgroundColor
                
                let photosTitleLabel: UILabel = {
                    let label = UILabel()
                    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
                    label.textColor = ColorPalette.picsiteTitleColor
                    return label
                }()
                
                let annotationSeparator = AnnotationSeparatorView(height: 70, color: .gray.withAlphaComponent(0.6))
                
                // Setup labels
                photosTitleLabel.attributedText = FontPalette.boldTextStyler.attributedString("map-annotation-photos-titel".localized, forSize: 18)

                let titleAndSubtitleStackView = UIStackView()
                 titleAndSubtitleStackView.axis = .vertical
                 titleAndSubtitleStackView.alignment = .center
                 titleAndSubtitleStackView.distribution = .fill
                 titleAndSubtitleStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

                 titleAndSubtitleStackView.addArrangedSubview(titleLabel)
                 titleAndSubtitleStackView.addArrangedSubview(subtitleLabel)

                 let spacer = UILayoutGuide()
                 titleAndSubtitleStackView.addLayoutGuide(spacer)

                 titleAndSubtitleStackView.addArrangedSubview(dateLabel)

                let photoStackView = UIStackView(arrangedSubviews: [photosTitleLabel, photoCountLabel])
                photoStackView.axis = .vertical
                photoStackView.spacing = 5
                photoStackView.alignment = .center
                photoStackView.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
                photoStackView.isLayoutMarginsRelativeArrangement = true
                
                let horizontalStackView = UIStackView(arrangedSubviews: [
                    titleAndSubtitleStackView,
                    annotationSeparator,
                    photoStackView
                ])
                horizontalStackView.contentMode = .center
                horizontalStackView.alignment = .center
                horizontalStackView.layoutMargins = .init(uniform: 10)
                horizontalStackView.spacing = 10
                horizontalStackView.distribution = .fill
                horizontalStackView.isLayoutMarginsRelativeArrangement = true
                            
                addAutolayoutSubview(horizontalStackView)
                horizontalStackView.pinToSuperview()
                
                roundCorners(radius: 12)
                
                NSLayoutConstraint.activate([
                    photoStackView.widthAnchor.constraint(equalToConstant: 70),
                    annotationSeparator.widthAnchor.constraint(equalToConstant: 1),
                    
                    spacer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
                    spacer.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
                    spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
                    titleLabel.topAnchor.constraint(equalTo: titleAndSubtitleStackView.topAnchor),
                    titleLabel.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor, constant: 10),
                    subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                    subtitleLabel.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor, constant: 10),
                    dateLabel.bottomAnchor.constraint(equalTo: titleAndSubtitleStackView.bottomAnchor),
                ])
                
                configureFor(configuration: configuration)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            func configureFor(configuration: Configuration){
                titleLabel.attributedText = FontPalette.boldTextStyler.attributedString(configuration.title, forSize: 20)
                subtitleLabel.attributedText = FontPalette.mediumTextStyler.attributedString(configuration.subtitle, color: ColorPalette.picsitePlaceholderColor, forSize: 16)
                dateLabel.attributedText = FontPalette.mediumTextStyler.attributedString("map-annotation-view-last-update-title".localized(with: [configuration.date]), forSize: 14)
                photoCountLabel.attributedText = FontPalette.mediumTextStyler.attributedString("\(configuration.photoCount)", color: ColorPalette.picsiteDeepBlueColor, forSize: 16)
                addPicsiteShadow()
            }
        }
    }
    
    public enum ImageCell {
        
        public struct Configuration: UIContentConfiguration, Hashable, Identifiable {
            public let id: String
            let photo: Photo
            let thumbnailPhoto: Photo
            public var isThumbnail: Bool = true
            
            private(set) var state: UICellConfigurationState?
            
            public init(id: String, photo: Photo, thumbnailPhoto: Photo, state: UICellConfigurationState? = nil) {
                self.id = id
                self.photo = photo
                self.thumbnailPhoto = thumbnailPhoto
                self.state = state
            }
            
            public func makeContentView() -> UIView & UIContentView {
                if isThumbnail {
                   return ThumbnailPhotoView(configuration: self)
                    
                } else{
                   return PhotoView(configuration: self)
                }
            }
            
            public func updated(for state: UIConfigurationState) -> Configuration {
                var mutableCopy = self
                if let cellState = state as? UICellConfigurationState {
                    mutableCopy.state =  cellState
                }
                return mutableCopy
            }
        }
        
        @objc(ImageCellView)
        class PhotoView: UIView, UIContentView {
            
            private let imageView = UIImageView()
            
            var configuration: UIContentConfiguration {
                didSet {
                    guard let config = configuration as? Configuration,
                          let oldConfig = oldValue as? Configuration,
                          config != oldConfig
                    else { return }
                    configureFor(configuration: config)
                }
            }
            
            init(configuration: Configuration) {
                self.configuration = configuration
                super.init(frame: .zero)
                backgroundColor = .white
                    
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                addAutolayoutSubview(imageView)
                imageView.pinToSuperview()
                
                roundCorners(radius: 12)

                imageView.pinToSuperview()
                
                addPicsiteShadow()
                
                configureFor(configuration: configuration)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            private func configureFor(configuration: Configuration){
                imageView.setPhoto(configuration.photo)
            }
        }
        
        @objc(ThumbnailImageCellView)
        class ThumbnailPhotoView: UIView, UIContentView {
            
            private let imageView = UIImageView()
            
            var configuration: UIContentConfiguration {
                didSet {
                    guard let config = configuration as? Configuration,
                          let oldConfig = oldValue as? Configuration,
                          config != oldConfig
                    else { return }
                    configureFor(configuration: config)
                }
            }
            
            init(configuration: Configuration) {
                self.configuration = configuration
                super.init(frame: .zero)
                backgroundColor = .white
                    
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.roundCorners(radius: 12)
                addAutolayoutSubview(imageView)
                imageView.pinToSuperview()
                
                roundCorners(radius: 12)

                imageView.pinToSuperview()
                
                addPicsiteShadow()
                
                configureFor(configuration: configuration)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            private func configureFor(configuration: Configuration){
                imageView.setPhoto(configuration.photo)
            }
        }
    }
}

