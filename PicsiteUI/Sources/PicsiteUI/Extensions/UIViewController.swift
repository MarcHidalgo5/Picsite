import UIKit
import BSWInterfaceKit
import JGProgressHUD

public extension UIViewController {
    
    func addPlainBackButton(tintColorWhite: Bool = true) {
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        let barButtonItem: UIBarButtonItem = {
            if tintColorWhite {
                return WhiteBarButtonItem(image: image, style: .plain, target: self, action: #selector(picsite_popController))
            } else {
                return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(picsite_popController))
            }
        }()
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func addCloseButton(tintColorWhite: Bool = true, prefersButtonOnTheLeft: Bool = true) {
        let barButtonItem: UIBarButtonItem = {
            if tintColorWhite {
                return WhiteBarButtonItem(image: UIImage(systemName: "xmark")!, style: .plain, target: self, action: #selector(picsite_closeViewController))
            } else {
                return UIBarButtonItem(image: UIImage(systemName: "xmark")!, style: .plain, target: self, action: #selector(picsite_closeViewController))
            }
        }()
        if prefersButtonOnTheLeft {
            navigationItem.leftBarButtonItem = barButtonItem
        } else {
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }
    
    @objc private func picsite_closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func picsite_popController() {
        self.navigationController?.popViewController(animated: true)
    }
}

public extension UIViewController {
    
    @discardableResult
    func performBlockingTask<T>(
        loadingMessage: String = "loading".localized,
        successMessage: String? = nil,
        errorMessage: String = "error-perform-blocking-task".localized,
        _ task: @escaping UIViewController.SwiftConcurrencyGenerator<T>)  -> Task<T, Error> {
        let blockingTask = Task {
            try await task()
        }
        self.showIndeterminateLoadingView(message: loadingMessage)
        Task {
            let result = await blockingTask.result
            await MainActor.run {
                switch result {
                case .success:
                    if let successMessage = successMessage {
                        self.showSuccessView(message: successMessage)
                    }
                case .failure(let error):
                    self.showErrorAlert(errorMessage, error: error)
                }
                self.hideIndeterminateLoadingView()
            }
        }
        return blockingTask
    }
}


public extension UIViewController {
    @objc(showSuccessViewWithMessage:)
    func showSuccessView(message: String) {
        let hud = ProgressHUD(userInterfaceStyle: self.traitCollection.userInterfaceStyle)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.textLabel.attributedText = FontPalette.mediumTextStyler.attributedString(message)
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1.5)
    }
    
    @objc(showIndeterminateLoadingViewWithMessage:)
    func showIndeterminateLoadingView(message: String) {
        let hud = ProgressHUD(userInterfaceStyle: self.traitCollection.userInterfaceStyle)
        hud.indicatorView = HUDLoadingView(color: {
            return ColorPalette.picsiteTintColor.resolvedColor(with: .init(userInterfaceStyle: self.traitCollection.userInterfaceStyle == .light ? .dark : .light))
        }())
        hud.textLabel.attributedText = FontPalette.mediumTextStyler.attributedString(message, color: {
            return ColorPalette.picsiteTintColor.resolvedColor(with: .init(userInterfaceStyle: self.traitCollection.userInterfaceStyle == .light ? .dark : .light))
        }())
        hud.show(in: self.view)
        hud.tag = UIViewController.ProgressTag
    }
    
    @objc(hideIndeterminateLoadingView)
    func hideIndeterminateLoadingView() {
        let hud = self.view.findSubviewWithTag(UIViewController.ProgressTag) as? JGProgressHUD
        hud?.dismiss()
    }
    
    private static let ProgressTag = Int(666)
}

private class ProgressHUD: JGProgressHUD {
    
    init(userInterfaceStyle: UIUserInterfaceStyle) {
        super.init(style: userInterfaceStyle == .light ? .dark : .extraLight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class HUDLoadingView: JGProgressHUDIndicatorView {
    init(color: UIColor) {
        let loadingView = UIView.picsiteLoadingView(color: color)
        loadingView.frame = CGRect(x: 0, y: 0, width: loadingView.intrinsicContentSize.width, height: loadingView.intrinsicContentSize.height)
        super.init(contentView: loadingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class WhiteBarButtonItem: UIBarButtonItem {
    override public var tintColor: UIColor? {
        get {
            return UIColor.white
        } set { }
    }
}
