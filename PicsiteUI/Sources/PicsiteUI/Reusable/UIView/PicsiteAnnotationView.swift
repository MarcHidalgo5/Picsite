//
//  Created by Marc Hidalgo on 9/11/22.
//

import UIKit
import BSWInterfaceKit
import UIKit
import PicsiteKit

public class PicsiteAnnotationView: UIView {
    
    let profileImage = ShadowImageView(width: 80, height: 80)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
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
    
    private var picsiteAnnotation: PicsiteAnnotation!
    
    public var picsite: Picsite {
        get {
            return picsiteAnnotation.picsiteData
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorPalette.picsiteBackgroundColor

        let photosTitleLabel: UILabel = {
            let label = UILabel()
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.textColor = ColorPalette.picsiteTitleColor
            return label
        }()
        
        photosTitleLabel.attributedText = FontPalette.boldTextStyler.attributedString("map-annotation-photos-titel".localized, forSize: 15)

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

        let annotationSeparator = AnnotationSeparatorView(height: 70, color: UIColor.opaqueSeparator)
        
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 80),
            profileImage.widthAnchor.constraint(equalToConstant: 80),
            photoStackView.widthAnchor.constraint(equalToConstant: 65),
            annotationSeparator.widthAnchor.constraint(equalToConstant: 1),
            
            titleAndSubtitleStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            titleAndSubtitleStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            
            spacer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
            spacer.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
            spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: titleAndSubtitleStackView.topAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: titleAndSubtitleStackView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureFor(picsiteAnnotation: PicsiteAnnotation) {
        self.picsiteAnnotation = picsiteAnnotation
        titleLabel.attributedText = FontPalette.boldTextStyler.attributedString(picsiteAnnotation.title ?? "", forSize: 16)
        subtitleLabel.attributedText = FontPalette.mediumTextStyler.attributedString(picsiteAnnotation.picsiteData.location, color: ColorPalette.picsitePlaceholderColor, forSize: 13)
        if picsiteAnnotation.lastActivityDateString != "" {
            dateLabel.attributedText = FontPalette.mediumTextStyler.attributedString("map-annotation-view-last-update-title".localized(with: [picsiteAnnotation.lastActivityDateString]), forSize: 12)
        } else {
            dateLabel.attributedText = FontPalette.mediumTextStyler.attributedString("Ninguna publicación".localized, forSize: 12)
        }
        photoCountLabel.attributedText = FontPalette.mediumTextStyler.attributedString("\(picsiteAnnotation.picsiteData.photoCount)", color: ColorPalette.picsiteDeepBlueColor, forSize: 15)
        profileImage.imageView.backgroundColor = picsiteAnnotation.markerTintColor.withAlphaComponent(0.5)
        profileImage.imageView.setPhoto(picsiteAnnotation.thumbnailPhoto)
    }
    
    @objc func viewTapped() {
        guard let next = self.next() as PicsiteAnnotationViewObserver? else { return }
        next.didTapOnAnnotation(currentAnnotation: self.picsiteAnnotation)
    }
}
