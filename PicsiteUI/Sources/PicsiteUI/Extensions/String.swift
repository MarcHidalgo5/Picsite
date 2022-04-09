
import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: .main, comment: "")
    }
    
    func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, locale: nil, arguments: arguments)
    }
}
