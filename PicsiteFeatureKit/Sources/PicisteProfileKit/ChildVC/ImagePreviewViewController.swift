//
//  Created by Marc Hidalgo on 20/8/23.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI

class ImagePreviewViewController: UIViewController, TransparentNavigationBarPreferenceProvider {

    init() {
        super.init(nibName: nil, bundle: nil)
        addCloseButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    public var barStyle: TransparentNavigationBar.TintColorStyle {
        .transparent
    }

    private func setupUI() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurredEffectView)

        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }
}
