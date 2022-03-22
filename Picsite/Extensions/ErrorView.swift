//
//  Created by Marc Hidalgo on 19/3/22.
//

import BSWInterfaceKit; import BSWFoundation
import UIKit; import Foundation
import PicsiteUI

//extension ErrorView {
//    static func videoAskError(message: String, error: Error, buttonTitle: String? = "retry".localize, retryHandler: @escaping VoidHandler) -> ErrorView {
//        
//        if let formMediaError = error as? FormMediaProvider.Error, formMediaError == .noResponseForThisContact {
//            return ErrorView(
//                title: mediumTextStyler.attributedString("form-media-no-answers-title".localized, color: .videoaskTitleColor, forStyle: .title3),
//                message: regularTextStyler.attributedString("form-media-no-answers-message".localized, color: .videoaskTitleColor, forStyle: .body).settingParagraphStyle {
//                    $0.lineHeightMultiple = 1.3
//                    $0.alignment = .center
//                },
//                image: nil,
//                button: nil
//            )
//        }
//        
//        if let formDetailsError = error as? FormDetailsProvider.Error, formDetailsError == .unsupportedQuestionType {
//            return ErrorView(
//                title: mediumTextStyler.attributedString("question-error-unsupported-kind-title".localized, color: .videoaskTitleColor, forStyle: .title3),
//                message: regularTextStyler.attributedString(formDetailsError.errorDescription!.localized, color: .videoaskTitleColor, forStyle: .body).settingParagraphStyle {
//                    $0.lineHeightMultiple = 1.3
//                    $0.alignment = .center
//                },
//                image: nil,
//                button: nil
//            )
//        }
//        
//        if let formDetailsError = error as? LogicProvider.Error, formDetailsError == .unsupportedLogicForThisQuestion {
//            return ErrorView(
//                title: mediumTextStyler.attributedString("question-error-unsupported-kind-title".localized, color: .videoaskTitleColor, forStyle: .title3),
//                message: regularTextStyler.attributedString(formDetailsError.errorDescription!.localized, color: .videoaskTitleColor, forStyle: .body).settingParagraphStyle {
//                    $0.lineHeightMultiple = 1.3
//                    $0.alignment = .center
//                },
//                image: nil,
//                button: nil
//            )
//        }
//        
//        let errorMessage: String = {
//            if Current.enhancedErrorLogs {
//                return "\(message). \(error.localizedDescription)"
//            } else {
//                return message
//            }
//        }()
//        let title = mediumTextStyler
//            .attributedString(errorMessage, color: UIColor.videoaskTitleColor, forStyle: .body)
//            .settingParagraphStyle {
//                $0.lineHeightMultiple = 1.3
//                $0.alignment = .center
//            }
//        let retryButton = PillButton(style: .solidColor(.graspDeepPurple, titleColor: .white))
//        retryButton.setTitle(buttonTitle, for: .normal)
//        retryButton.setHandler(retryHandler)
//        return ErrorView(title: title, message: nil, image: nil, button: retryButton)
//    }
//}
//
