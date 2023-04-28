//
//  Created by Marc Hidalgo on 3/5/22.
//

import PicsiteKit
import PicsiteUI
import UIKit

public struct ModuleDependencies {
    
    let dataSource: AuthenticationDataSourceType
    let socialManager: AuthenticationManagerSocialManagerType
    let mode: AuthenticationPerformerViewController.Mode
    let observer: AuthenticationObserver
    
    public init(
        dataSource: AuthenticationDataSourceType,
        socialManager: AuthenticationManagerSocialManagerType,
        mode: AuthenticationPerformerViewController.Mode,
        observer: AuthenticationObserver
    ) {
        self.dataSource = dataSource
        self.socialManager = socialManager
        self.mode = mode
        self.observer = observer
    }
}

public enum SocialButtonKind {
   case apple, instagram, google
   
   public var image: UIImage {
       switch self {
       case .apple:
           return UIImage(systemName: "applelogo")!.withRenderingMode(.alwaysTemplate)
       case .instagram:
           return UIImage(named: "instagram-icon")!
       case .google:
           return UIImage(named: "google-icon")!
       }
   }
   
   public var tintColor: UIColor? {
       switch self {
       case .apple: return .black
       default: return nil
       }
   }
   
   public var backgroundColor: UIColor {
       return .white
   }
   
   public var imageEdgeInsets: UIEdgeInsets {
       switch self {
       case .apple:
           return UIEdgeInsets(top: 6, left: 6, bottom: 12, right: 12)
       case .google:
           return UIEdgeInsets(uniform: 8)
       case .instagram:
           return UIEdgeInsets(uniform: 11)
       }
   }
    
    public static func createSocialButton(kind: SocialButtonKind) -> UIButton {
       let button = RoundButton(color: .white)
       button.setImage(kind.image, for: .normal)
       button.imageEdgeInsets = kind.imageEdgeInsets
       if let tintColor = kind.tintColor {
           button.tintColor = tintColor
       }
       button.backgroundColor = kind.backgroundColor
       button.imageView?.contentMode = .scaleAspectFit
       button.contentVerticalAlignment = .fill
       button.contentHorizontalAlignment = .fill
       
       return button
   }
}
