//
//  Created by Marc Hidalgo on 8/11/22.
//

import UIKit
import PicsiteUI

public protocol MapDataSourceType {
    func fetchAnnotations() async throws -> BaseMapViewController.VM
    func picsiteProfileViewController(picsiteID: String) -> UIViewController 
}
