//
//  Created by Marc Hidalgo on 14/5/23.
//

import UIKit
import BSWInterfaceKit

public class GridLoadingCell: UICollectionViewListCell {

    let picsiteLoadingView: LoadingIndicator = UIView.picsiteLoadingView()

    public let Margins: UIEdgeInsets = .init(uniform: 8)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundConfiguration = .clear()
        contentView.addAutolayoutSubview(picsiteLoadingView)
        let heightAnchor = picsiteLoadingView.heightAnchor.constraint(equalToConstant: 30)
        heightAnchor.priority = .init(999)
        NSLayoutConstraint.activate([
            heightAnchor,
            picsiteLoadingView.widthAnchor.constraint(equalTo: picsiteLoadingView.heightAnchor),
            contentView.centerXAnchor.constraint(equalTo: picsiteLoadingView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: picsiteLoadingView.centerYAnchor)
        ])
    }

    public required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    public func startAnimating() {
        picsiteLoadingView.startAnimating()
    }
}
