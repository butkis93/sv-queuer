//
//  Extensions+Utility.swift
//  SV Queuer
//
//  Created by Nicholas LoBue on 1/31/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import UIKit

typealias Void = () -> ()

extension UIAlertController {
    static func errorAlert(with error: Error, completion: Void?) -> UIAlertController {
        let errorAlert = UIAlertController(title: StringConstants.loginErrorTitle, message: StringConstants.loginErrorDescription(error: error), preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: StringConstants.loginErrorCancelTitle, style: .cancel, handler: { action in
            errorAlert.dismiss(animated: true, completion: nil)
        }))
        
        return errorAlert
    }
}
