//
//  Created by Marc Hidalgo on 12/5/23.
//

import UIKit

public extension NSCollectionLayoutSection {
    
    func addHeaderElement(estimatedHeight: CGFloat) {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        boundarySupplementaryItems.append(header)
    }
}
