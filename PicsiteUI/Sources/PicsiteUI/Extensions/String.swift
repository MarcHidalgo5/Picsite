
import Foundation

public extension String {
    var localize: String {
        return NSLocalizedString(self, bundle: .main, comment: "")
    }
    
    func localize(with arguments: [CVarArg]) -> String {
        return String(format: self.localize, locale: nil, arguments: arguments)
    }
}
