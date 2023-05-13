//
//  Created by Marc Hidalgo on 8/11/22.
//

import UIKit

public protocol MapDataSourceType {
    func fetchAnnotations() async throws -> MapViewController.VM
    func picsiteProfileViewController(picsiteID: String) -> UIViewController 
}
