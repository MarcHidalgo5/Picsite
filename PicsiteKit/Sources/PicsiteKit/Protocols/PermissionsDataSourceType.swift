//
//  Created by Marc Hidalgo on 7/11/22.
//

import Foundation

public enum Permission {
    case camera
}

public protocol PermissionsDataSourceType: AnyObject {
    func permissionIsAvailable(permission: Permission) async -> Bool
    func requestPermission(permission: Permission) async throws
}

public extension PermissionsDataSourceType {
    func permissionsAreAvailable(permissions: [Permission]) async -> Bool {
        for permission in permissions {
            guard await self.permissionIsAvailable(permission: permission) else {
                return false
            }
        }
        return true
    }
}
