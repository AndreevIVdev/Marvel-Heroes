//
//  MHDataLoadingViewController.swift
//
//
//  Created by Илья Андреев on 02.12.2021.
//

import UIKit

class MHDataLoadingViewController: UIViewController {
    
    private let containerView: UIView = .init()
    private let activityIndicator: UIActivityIndicatorView = .init(style: .large)
    
    func showLoadingView() {
        DispatchQueue.main.async {
            self.view.addSubViews(self.containerView)
            self.containerView.frame = self.view.bounds
            self.containerView.backgroundColor = Colors.mhwhite
            
            UIView.animate(withDuration: 0.75) {
                self.containerView.alpha = 0.8
            }
            
            self.containerView.addSubViews(self.activityIndicator)
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.activityIndicator.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
                self.activityIndicator.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor)
            ])
            
            self.activityIndicator.startAnimating()
        }
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.containerView.removeFromSuperview()
        }
    }
}
