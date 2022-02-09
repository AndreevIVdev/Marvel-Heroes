//
//  MHItemInfoViewController.swift
//  
//
//  Created by Илья Андреев on 02.01.2022.
//

import UIKit

class MHItemInfoViewController: UIViewController {
    
    let stackView: UIStackView = .init()
    let itemInfoViewOne: MHItemInfoView = .init()
    let itemInfoViewTwo: MHItemInfoView = .init()
    let actionButton: MHActionButton = .init()
    let actionButtonTap: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        configureStackView()
        configureActionButton()
    }
    
    init(actionButtonTap: @escaping () -> Void) {
        self.actionButtonTap = actionButtonTap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewController() {
        view.layer.cornerRadius = 18
        view.backgroundColor = Colors.mhwhite
    }
    
    private func layoutUI() {
        view.addSubViews(stackView, actionButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc private func actionButtonTapped() {
        actionButtonTap()
    }
}
