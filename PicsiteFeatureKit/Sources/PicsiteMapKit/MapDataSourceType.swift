//
//  Created by Marc Hidalgo on 8/11/22.
//

import UIKit
import PicsiteUI; import PicsiteKit

public protocol MapDataSourceType {
    func fetchAnnotations() async throws -> BaseMapViewController.VM
    func picsiteProfileViewController(picsite: Picsite) -> UIViewController
}
