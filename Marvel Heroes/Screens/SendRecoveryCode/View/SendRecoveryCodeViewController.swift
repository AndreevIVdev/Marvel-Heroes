//
//  SendPasswordRecoveryViewController.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 18.10.2021.
//

import UIKit

protocol SendRecoveryCodeViewable: AnyObject {
    func getInputedText(fromTextField textField: SendRecoveryCodeTextField) -> String?
    func showAllert(
        title: String?,
        message: String?,
        buttonTitle: String?,
        completion: (() -> Void)?
    )
    func shakeTextField(_ textField: SendRecoveryCodeTextField)
}

enum SendRecoveryCodeTextField {
    case email
}


final class SendRecoveryCodeViewController: UIViewController {
    var presenter: SendRecoveryPresentable!
    private let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let emailTextField: MHTextField = .init()
    private let sendCodeButton: MHActionButton = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureContentView()
        configureEmailTextField()
        configureSendCodeButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    private func configureViewController() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        title = "Password recovery"
        view.backgroundColor = Colors.mhwhite
        registerKeyboardNotifications()
        view.addSubViews(scrollView)
        view.backgroundColor = Colors.mhwhite
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: view,
                action: #selector(UIView.endEditing))
        )
    }

    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.addSubViews(contentView)
    }

    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        contentView.addSubViews(
            emailTextField,
            sendCodeButton
        )
    }

    private func configureEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .go
        emailTextField.delegate = self

        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 250),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27)
        ])
    }

    private func configureSendCodeButton() {
        sendCodeButton.addTarget(
            self,
            action: #selector(sendCodeButtonTapped),
            for: .touchUpInside
        )
        sendCodeButton.setTitle("SEND CODE", for: .normal)

        NSLayoutConstraint.activate([
            sendCodeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            sendCodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
            sendCodeButton.heightAnchor.constraint(equalToConstant: 50),
            sendCodeButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 33)
        ])
    }

    @objc private func sendCodeButtonTapped() {
        presenter.sendCodeButtonTapped()
    }
}

extension SendRecoveryCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            sendCodeButtonTapped()
        default:
            fatalError("Check text fields")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.textDidEndEditing(
            inTextField: enumerateTextField(
                textField
            )
        )
    }
}

extension SendRecoveryCodeViewController {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func deEnumerateTextField(_ textField: SendRecoveryCodeTextField) -> UITextField {
        switch textField {
        case .email:
            return emailTextField
        }
    }
    
    private func enumerateTextField(_ textField: UITextField) -> SendRecoveryCodeTextField {
        switch textField {
        case emailTextField:
            return .email
        default:
            fatalError("Check text fields")
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardFrameSize = (
            userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else {
            return
        }
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrameSize.height / 2)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension SendRecoveryCodeViewController: SendRecoveryCodeViewable {
    
    func getInputedText(fromTextField textField: SendRecoveryCodeTextField) -> String? {
        deEnumerateTextField(textField).text
    }
    
    func showAllert(title: String?, message: String?, buttonTitle: String?, completion: (() -> Void)? = nil) {
        presentAlertControllerOnMainTread(
            title: title ?? "",
            message: message ?? "",
            buttonTitle: buttonTitle ?? "",
            completion: completion
        )
    }
    
    func shakeTextField(_ textField: SendRecoveryCodeTextField) {
        let textField = deEnumerateTextField(textField)
        textField.shake(
            horizantaly: 5,
            duration: 0.05
        )
        textField.animateColor(
            toColor: UIColor.red.cgColor,
            duration: 0.05
        )
    }
}
