//
//  Created by Marc Hidalgo on 12/5/23.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI

extension PicsiteProfileViewController {
    
    public enum ImageCell {
        
        public struct Configuration: UIContentConfiguration, Equatable {
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
                    
                imageView.contentMode = .scaleAspectFit
                addAutolayoutSubview(imageView)
                imageView.pinToSuperview()
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
        
        public struct Configuration: UIContentConfiguration, Equatable {
            let title: String
            let subtitle: String
            let date: String
            let photoCount: String
            let profilPhoto: Photo
            
            private(set) var state: UICellConfigurationState?
            
            public init(title: String, subtitle: String, date: String, photoCount: String, profilPhoto: Photo, state: UICellConfigurationState? = nil) {
                self.title = title
                self.subtitle = subtitle
                self.date = date
                self.photoCount = photoCount
                self.profilPhoto = profilPhoto
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
            
            let profileImage = ShadowImageView(width: 80, height: 80)
            
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
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.9
                return label
            }()
            
            private let photoCountLabel: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.minimumScaleFactor = 0.8
                label.textColor = UIColor.gray.withAlphaComponent(0.9)
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
                backgroundColor = .white
                
                let photosTitleLabel: UILabel = {
                    let label = UILabel()
                    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
                    label.textColor = ColorPalette.picsiteTitleColor
                    return label
                }()
                
                let annotationSeparator = AnnotationSeparatorView(height: 70)
                
                // Setup labels
                photosTitleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("map-annotation-photos-titel".localized, forSize: 16)

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
                photoStackView.spacing = 0
                photoStackView.alignment = .center
                photoStackView.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
                photoStackView.isLayoutMarginsRelativeArrangement = true
                
                let horizontalStackView = UIStackView(arrangedSubviews: [
                    profileImage,
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
                
                NSLayoutConstraint.activate([
                    profileImage.heightAnchor.constraint(equalToConstant: 80),
                    profileImage.widthAnchor.constraint(equalToConstant: 80),
                    photoStackView.widthAnchor.constraint(equalToConstant: 50),
                    annotationSeparator.widthAnchor.constraint(equalToConstant: 1),
                    
                    titleAndSubtitleStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
                    titleAndSubtitleStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
                    
                    spacer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
                    spacer.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
                    spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
                    titleLabel.topAnchor.constraint(equalTo: titleAndSubtitleStackView.topAnchor),
                    subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                    dateLabel.bottomAnchor.constraint(equalTo: titleAndSubtitleStackView.bottomAnchor),
                ])
                
                configureFor(configuration: configuration)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            func configureFor(configuration: Configuration){
                titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString(configuration.title, forSize: 18)
                subtitleLabel.attributedText = FontPalette.mediumTextStyler.attributedString(configuration.subtitle, color: ColorPalette.picsitePlaceholderColor, forSize: 12)
                dateLabel.attributedText = FontPalette.mediumTextStyler.attributedString("map-annotation-view-last-update-title".localized(with: [configuration.date]), forSize: 12)
                photoCountLabel.attributedText = FontPalette.mediumTextStyler.attributedString("\(configuration.photoCount)", color: ColorPalette.picsiteDeepBlueColor, forSize: 16)
                profileImage.imageView.setPhoto(configuration.profilPhoto)
            }
        }
    }
}

