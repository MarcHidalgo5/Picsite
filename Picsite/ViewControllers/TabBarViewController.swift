//
//  Created by Marc Hidalgo on 6/11/22.
//

import UIKit
import PicsiteKit; import PicsiteUI
import PicsiteMapKit
import PicsiteUploadContentKit

class TabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        let map: (UIViewController, UITabBarItem) = (
            MapViewController(),
            UITabBarItem(title: "tabbar-controller-map-title".localized, image: UIImage(systemName: "mappin.and.ellipse"), selectedImage: UIImage(systemName: "mappin.and.ellipse"))
        )
        
        let uploadContent: (UIViewController, UITabBarItem) = (
            UploadContentViewController(),
            UITabBarItem(title: "tabbar-controller-add-title".localized, image: UIImage(systemName: "plus"), selectedImage: UIImage(systemName: "plus"))
        )

        let profile: (UIViewController, UITabBarItem) = (
            HomeViewController(),
            UITabBarItem(title: "tabbar-controller-profile-title".localized, image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle"))
        )
        
        let viewControllers: [UIViewController] = [
            navigationController(with: map),
            navigationController(with: uploadContent),
            navigationController(with: profile),
        ]
        self.setViewControllers(viewControllers, animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .picsiteBackgroundColor
        
        //Lines:
        let topline = CALayer()
        topline.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 1)
        topline.backgroundColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        self.tabBar.layer.addSublayer(topline)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var selectedIndex: Int {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        viewControllers?[selectedIndex]
    }
            
    // MARK: Private

    private func navigationController(with tuple:(UIViewController, UITabBarItem)) -> UIViewController {
        let navVC = MinimalNavigationController(rootViewController: tuple.0)
        navVC.tabBarItem = tuple.1
        return navVC
    }
    
    private func viewController(with tuple:(UIViewController, UITabBarItem)) -> UIViewController {
        let vc = tuple.0
        vc.tabBarItem = tuple.1
        return vc
    }
}
