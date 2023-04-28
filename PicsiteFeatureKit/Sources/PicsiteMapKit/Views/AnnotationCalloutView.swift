//
//  Created by Marc Hidalgo on 9/11/22.
//

import UIKit
import PicsiteUI
import BSWInterfaceKit
import UIKit

public class PicsiteAnnotationView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorPalette.picsiteBackgroundColor

        let photosTitleLabel: UILabel = {
            let label = UILabel()
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.textColor = ColorPalette.picsiteTitleColor
            return label
        }()
        
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

        let annotationSeparator = AnnotationSeparatorView(height: 70)
        
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

        roundCorners(radius: 12)
        addPicsiteShadow()

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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFor(picsiteAnnotation: PicsiteAnnotation) {
        titleLabel.attributedText = FontPalette.mediumTextStyler.attributedString(picsiteAnnotation.title ?? "", forSize: 18)
        subtitleLabel.attributedText = FontPalette.mediumTextStyler.attributedString(picsiteAnnotation.picsiteData.location, color: ColorPalette.picsitePlaceholderColor, forSize: 12)
        dateLabel.attributedText = FontPalette.mediumTextStyler.attributedString("map-annotation-view-last-update-title".localized(with: [picsiteAnnotation.lastActivityDateString]), forSize: 12)
        photoCountLabel.attributedText = FontPalette.mediumTextStyler.attributedString("\(picsiteAnnotation.picsiteData.photoCount)", color: ColorPalette.picsiteDeepBlueColor, forSize: 16)
        profileImage.imageView.backgroundColor = picsiteAnnotation.markerTintColor.withAlphaComponent(0.5)
        guard let thumbnailURL = picsiteAnnotation.thumbnailURL else { return }
        profileImage.imageView.setImageWithURL(thumbnailURL)
    }
}

extension PicsiteAnnotationView {
    
    public class AnnotationSeparatorView: UIView {
        public init(height: CGFloat) {
            super.init(frame: .zero)
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor.opaqueSeparator
            addAutolayoutSubview(separatorView)
            NSLayoutConstraint.activate([
                separatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
                separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: height),
                separatorView.widthAnchor.constraint(equalToConstant: 1)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
