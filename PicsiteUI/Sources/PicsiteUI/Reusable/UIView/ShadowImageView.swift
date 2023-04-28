//
//  Created by Marc Hidalgo on 28/4/23.
//

import UIKit

public class ShadowImageView: UIView {
    public var imageView = UIImageView()

    public init(width: CGFloat, height: CGFloat) {
        super.init(frame: .zero)
        setupImageView(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(width: CGFloat, height: CGFloat) {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layoutMargins = .init(uniform: 10)

        dontMakeBiggerOrSmaller()
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        
        self.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: imageView.layer.cornerRadius).cgPath
        
        imageView.pinToSuperview()

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalToConstant: height),
        ])
    }
}
