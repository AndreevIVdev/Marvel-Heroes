//
//  LoginViewController.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 14.10.2021.
//

import UIKit

protocol LoginViewable: AnyObject {
    func getInputedText(fromTextField textField: LoginViewTextField) -> String?
    func showAllert(title: String?, message: String?, buttonTitle: String?)
    func shakeTextField(_ textField: LoginViewTextField)
}

enum LoginViewTextField {
    case email
    case password
}

final class LoginViewController: UIViewController {
    var presenter: LoginPresentable!
    private let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let appLabel: MHLabel = .init()
    private let emailTextField: MHTextField = .init()
    private let passwordTextField: MHTextField = .init()
    private let textFieldsStackView: UIStackView = .init()
    private let singInButton: MHActionButton = .init()
    private let forgotPasswordButton: MHSecondaryTitleButton = .init()
    private let dontHaveAnAccountButton: MHTitleButton = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureScrollView()
        configureContentView()
        configureAppLabel()
        configureEmailTextField()
        configurePasswordTextField()
        configureTextFieldsStackView()
        configureSingInButton()
        configureForgotPasswordButton()
        configureDontHaveAnAccountButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        emailTextField.text = nil
        passwordTextField.text = nil
        view.endEditing(true)
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    private func configureViewController() {
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
            appLabel,
            textFieldsStackView,
            singInButton,
            forgotPasswordButton,
            dontHaveAnAccountButton
        )
    }
    
    private func configureAppLabel() {
        appLabel.text = "App"
        appLabel.textColor = Colors.mhRed
        appLabel.font = UIFont(name: Fonts.openSansRomanExtraBold, size: 48)
        NSLayoutConstraint.activate([
            appLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 89),
            appLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func configureEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.delegate = self
        
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurePasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.returnKeyType = .go
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureTextFieldsStackView() {
        textFieldsStackView.addArrangedSubviews(emailTextField, passwordTextField)
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.spacing = 10
        textFieldsStackView.distribution = .equalSpacing
        textFieldsStackView.axis = .vertical
        NSLayoutConstraint.activate([
            textFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            textFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
            textFieldsStackView.heightAnchor.constraint(equalToConstant: 110),
            textFieldsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 221)
        ])
    }
    
    private func configureSingInButton() {
        singInButton.setTitle("SING IN", for: .normal)
        singInButton.addTarget(
            self,
            action: #selector(singInButtonTapped),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([
            singInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            singInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
            singInButton.heightAnchor.constraint(equalToConstant: 50),
            singInButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 20)
        ])
    }
    
    private func configureForgotPasswordButton() {
        forgotPasswordButton.addTarget(
            self,
            action: #selector(forgotPasswordButtonTapped),
            for: .touchUpInside
        )
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.sizeToFit()
        
        NSLayoutConstraint.activate([
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: singInButton.bottomAnchor, constant: 25),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: forgotPasswordButton.height),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: forgotPasswordButton.width)
        ])
    }
    
    private func configureDontHaveAnAccountButton() {
        dontHaveAnAccountButton.addTarget(
            self,
            action: #selector(dontHaveAnAccountButtonTapped),
            for: .touchUpInside
        )
        dontHaveAnAccountButton.setTitle("Don't have an account?", for: .normal)
        dontHaveAnAccountButton.sizeToFit()
        
        NSLayoutConstraint.activate([
            dontHaveAnAccountButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dontHaveAnAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
            dontHaveAnAccountButton.heightAnchor.constraint(equalToConstant: forgotPasswordButton.height)
        ])
    }
    
    private func enumerateTextField(_ textField: UITextField) -> LoginViewTextField {
        switch textField {
        case emailTextField:
            return .email
        case passwordTextField:
            return .password
        default:
            fatalError("Check text fields")
        }
    }
    
    private func deEnumerateTextField(_ textField: LoginViewTextField) -> UITextField {
        switch textField {
        case .email:
            return emailTextField
        case .password:
            return passwordTextField
        }
    }
    
    @objc private func dontHaveAnAccountButtonTapped() {
        presenter.dontHaveAnAccountButtonTapped()
    }
    
    @objc private func singInButtonTapped() {
        presenter.signInButtonTapped()
    }
    
    @objc private func forgotPasswordButtonTapped() {
        presenter.forgotPasswordButtonTapped()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            singInButtonTapped()
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

extension LoginViewController {
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        scrollView.contentOffset = CGPoint(x: 0, y: appLabel.top)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension LoginViewController: LoginViewable {
    
    func getInputedText(fromTextField textField: LoginViewTextField) -> String? {
        deEnumerateTextField(textField).text
    }
    
    func shakeTextField(_ textField: LoginViewTextField) {
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
    
    func showAllert(title: String?, message: String?, buttonTitle: String?) {
        presentAlertControllerOnMainTread(
            title: title ?? "",
            message: message ?? "",
            buttonTitle: buttonTitle ?? ""
        )
    }
}
