
import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: .main, comment: "")
    }
    
    func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, locale: nil, arguments: arguments)
    }
    
    var toURL: URL? {
        return URL(string: self)
    }
}

extension Optional where Wrapped == String {
    var toURL: URL? {
        guard let thumbnailURLString = self else { return nil }
        return URL(string: thumbnailURLString)
    }
}
