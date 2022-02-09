//
//  UIViewController+Ext.swift
//  GHProfile
//
//  Created by Ilya Andreev on 09.09.2021.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentAlertControllerOnMainTread(title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertViewController = MHAlertViewController(
                alertTitle: title,
                message: message,
                buttonTitle: buttonTitle,
                completion: completion
            )
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true)
        }
    }

    func areTextFieldsEntered(_ textFields: UITextField...) -> Bool {
        textFields.allSatisfy { $0.isEntered }
    }
//
//    func presentSafariViewController(with url: URL) {
//        let safariViewController = SFSafariViewController(url: url)
//        safariViewController.preferredControlTintColor = .systemGreen
//        present(safariViewController, animated: true)
//    }
//
    func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubViews(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.pinToEdges(of: containerView)
        childViewController.didMove(toParent: self)
    }
}
