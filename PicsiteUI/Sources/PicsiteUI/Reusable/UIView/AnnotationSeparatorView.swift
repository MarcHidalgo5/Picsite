//
//  Created by Marc Hidalgo on 12/5/23.
//

import UIKit

public class AnnotationSeparatorView: UIView {
    public init(height: CGFloat, color: UIColor) {
        super.init(frame: .zero)
        let separatorView = UIView()
        separatorView.backgroundColor = color
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
