//
//  Created by Marc Hidalgo on 9/11/22.
//

import UIKit
import PicsiteUI
import BSWInterfaceKit

public class AnnotationCalloutView: UIView {
    
    public struct VM {
        let annotation: PicsiteAnnotation
        let photo: Photo
        
        public init(annotation: PicsiteAnnotation, photo: Photo) {
            self.annotation = annotation
            self.photo = photo
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPalette.picsiteTitleColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPalette.picsitePlaceholderColor
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let photoCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPalette.picsiteDeepBlueColor
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = ColorPalette.picsiteTitleColor
        view.roundCorners(radius: 12)
        view.backgroundColor = ColorPalette.picsiteBackgroundColor
        view.addPicsiteShadow()
        return view
    }()
    
    private var completion: () -> () = {}
    
    init() {
        super.init(frame: .zero)
        setupLayer()
        setupSubviews()
        setupTargets()
    }
    
    required internal init?(coder aDecoder:NSCoder) { fatalError("Not implemented.") }
    
    func configureView(with viewModel: VM, fromVC: UIViewController, completion: @escaping () -> ()) {
        setBackgroundColor(color: ColorPalette.picsiteBackgroundColor)
        setImage(photo: viewModel.photo)
        setTitle(title: FontPalette.mediumTextStyler.attributedString(viewModel.annotation.title ?? "", forSize: 18))
//        setSubtitle(subtitle: FontPalette.mediumTextStyler.attributedString(viewModel.annotation.location, forSize: 12))
//        setNumberOfPhotos(FontPalette.mediumTextStyler.attributedString(String(viewModel.annotation.photoCount), forSize: 16))
        setCompletionBlock(completion)
        prepareFrame(fromVC: fromVC)
    }
    
    func prepareFrame(fromVC: UIViewController) {
        let bounds = fromVC.view.window?.bounds ?? UIScreen.main.bounds
        let deviceWidth = min(bounds.width, bounds.height)
        let widthFactor: CGFloat = (fromVC.view.window?.traitCollection.horizontalSizeClass == .compact) ? 0.85 : 0.5
        let width = deviceWidth * widthFactor
        let height: CGFloat = 80
        self.frame = CGRect(x: 0, y: bounds.height - height, width: width, height: height)
        self.center.x = bounds.width/2
    }
    
    // MARK: - Setup
    
    private func setupLayer() {
        layer.cornerRadius = 12
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    private func setupSubviews() {
        
        let photosTitleLabel: UILabel = {
            let label = UILabel()
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.textColor = ColorPalette.picsiteTitleColor
            return label
        }()
        
        photosTitleLabel.attributedText = FontPalette.mediumTextStyler.attributedString("map-annotation-photos-titel".localized, forSize: 16)
        
        let titleAndSubtitleStackView = UIStackView(arrangedSubviews: [UIView(),titleLabel, subtitleLabel, UIView()])
        titleAndSubtitleStackView.axis = .vertical
        titleAndSubtitleStackView.spacing = 0
        titleAndSubtitleStackView.alignment = .center
        titleAndSubtitleStackView.distribution = .equalCentering
        
        let photoStackView = UIStackView(arrangedSubviews: [photosTitleLabel, photoCountLabel, UIView()])
        photoStackView.axis = .vertical
        photoStackView.spacing = 0
        photoStackView.alignment = .center
        photoStackView.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
        photoStackView.isLayoutMarginsRelativeArrangement = true

        let annotationSeparator = AnnotationSeparatorView()
        
        let contentStackView = UIStackView(arrangedSubviews: [imageView, titleAndSubtitleStackView, annotationSeparator, photoStackView])
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.layoutMargins = .init(uniform: 10)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.distribution = .fillProportionally

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            photoStackView.widthAnchor.constraint(equalToConstant: 68),
            annotationSeparator.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        addAutolayoutSubview(contentStackView)
        contentStackView.pinToSuperview()
    }
    
    private func setupTargets() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(_dismissPicsiteView))
        swipeRecognizer.direction = .down
        addGestureRecognizer(swipeRecognizer)
    }
    
    func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
    
    func setTitle(title: NSAttributedString?) {
        titleLabel.attributedText = title
        titleLabel.isHidden = (title == nil)
    }
    
    func setSubtitle(subtitle: NSAttributedString?) {
        subtitleLabel.attributedText = subtitle
        subtitleLabel.isHidden = (subtitle == nil)
    }
    
    func setNumberOfPhotos(_ count: NSAttributedString?) {
        photoCountLabel.attributedText = count
        photoCountLabel.isHidden = (count == nil)
    }
    
    func setImage(photo: Photo) {
        imageView.setPhoto(photo)
    }
    
    func setCompletionBlock(_ completion: @escaping () -> ()) {
        self.completion = completion
    }
    
    func showPicsiteView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.1, options: UIView.AnimationOptions(), animations: {
            let newValue : CGFloat = {
                return UIScreen.main.isSmallTabBar ? 80 : 150
            }()
            self.frame.origin.y += self.safeAreaInsets.bottom - newValue
        })
    }
    
    @objc private func _dismissPicsiteView() {
        dismissPicsiteView(animated: true)
    }
    
    func dismissPicsiteView(animated: Bool) {
        guard animated else {
            removeFromSuperview()
            return
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.frame.origin.y = self.frame.origin.y - 5
        }, completion: {
            (complete: Bool) in
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y -= -self.frame.height - 180
            }, completion: { [weak self] (complete) in
                self?.completion()
                self?.removeFromSuperview()
            })
        })
    }
}

public extension UIScreen {
    var isSmallTabBar: Bool {
        return self.bounds.width <= 380
    }
}

extension AnnotationCalloutView {
    
    public class AnnotationSeparatorView: UIView {
        public init() {
            super.init(frame: .zero)
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor.opaqueSeparator
            addAutolayoutSubview(separatorView)
            NSLayoutConstraint.activate([
                separatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
                separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
                separatorView.heightAnchor.constraint(equalTo: heightAnchor),
                separatorView.widthAnchor.constraint(equalToConstant: 1)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
