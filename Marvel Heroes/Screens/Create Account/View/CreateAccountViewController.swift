//
//  CreateAccountViewController.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 15.10.2021.
//

import UIKit

protocol CreateAccountViewable: AnyObject {
    func getInputedText(fromTextField textField: CreateAccountTextField) -> String?
    func shakeTextField(_ textField: CreateAccountTextField)
    func showAllert(title: String?, message: String?, buttonTitle: String?)
}

enum CreateAccountTextField {
    case name
    case email
    case password
    case confirmPassword
}

final class CreateAccountViewController: UIViewController {
    var presenter: CreateAccountPresentable!
    private let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let nameTextField: MHTextField = .init()
    private let emailTextField: MHTextField = .init()
    private let passwordTextField: MHTextField = .init()
    private let confirmPasswordTextField: MHTextField = .init()
    private let textFieldsStackView: UIStackView = .init()
    private let createAccountButton: MHActionButton = .init()
    private let termsAgreeButton: MHSecondaryTitleButton = .init()
    private let alreadyHaveAnAccountButton: MHTitleButton = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureContentView()
        configureNameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureConfirmPasswordTextField()
        configureTextFieldsStackView()
        configureCreateAccountButton()
        configureTermsAgreeButton()
        configureAlreadyHaveAnAccountButton()
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
        title = "Create account"
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
            textFieldsStackView,
            createAccountButton,
            termsAgreeButton,
            alreadyHaveAnAccountButton
        )
    }

    private func configureNameTextField() {
        nameTextField.placeholder = "Name"
        nameTextField.returnKeyType = .next
        nameTextField.delegate = self

        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
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
        passwordTextField.returnKeyType = .next
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self

        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureConfirmPasswordTextField() {
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.returnKeyType = .go
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.delegate = self

        NSLayoutConstraint.activate([
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureTextFieldsStackView() {
        textFieldsStackView.addArrangedSubview(nameTextField)
        textFieldsStackView.addArrangedSubview(emailTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        textFieldsStackView.addArrangedSubview(confirmPasswordTextField)

        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.spacing = 10
        textFieldsStackView.distribution = .equalSpacing
        textFieldsStackView.axis = .vertical
        NSLayoutConstraint.activate([
            textFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            textFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
            textFieldsStackView.heightAnchor.constraint(equalToConstant: 230),
            textFieldsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 152)
        ])
    }

    private func configureCreateAccountButton() {
        createAccountButton.addTarget(
            self,
            action: #selector(createAccountButtonTapped),
            for: .touchUpInside
        )
        createAccountButton.setTitle("CREATE ACCOUNT", for: .normal)

        NSLayoutConstraint.activate([
            createAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            createAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            createAccountButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 20)
        ])
    }

    private func configureTermsAgreeButton() {
        termsAgreeButton.addTarget(
            self,
            action: #selector(termsAgreeButtonTapped),
            for: .touchUpInside
        )
        let normalText = "By creating an account you agree\n to the "
        let boldText = "Terms of use"
        let attributedString = NSMutableAttributedString(
            string: normalText,
            attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.openSansRegular, size: 14)!]
        )
        let boldString = NSMutableAttributedString(
            string: boldText,
            attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.openSansBold, size: 14)!])
        attributedString.append(boldString)
        termsAgreeButton.titleLabel?.numberOfLines = 2
        termsAgreeButton.titleLabel?.textAlignment = .center
        termsAgreeButton.setAttributedTitle(attributedString, for: .normal)
        termsAgreeButton.sizeToFit()

        NSLayoutConstraint.activate([
            termsAgreeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            termsAgreeButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 25),
            termsAgreeButton.heightAnchor.constraint(equalToConstant: termsAgreeButton.height),
            termsAgreeButton.widthAnchor.constraint(equalToConstant: termsAgreeButton.width)
        ])
    }

    private func configureAlreadyHaveAnAccountButton() {
        alreadyHaveAnAccountButton.addTarget(
            self,
            action: #selector(configureAlreadyHaveAnAccountButtonTapped),
            for: .touchUpInside
        )
        alreadyHaveAnAccountButton.setTitle("Already have an account?", for: .normal)
        alreadyHaveAnAccountButton.sizeToFit()

        NSLayoutConstraint.activate([
            alreadyHaveAnAccountButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            alreadyHaveAnAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
            alreadyHaveAnAccountButton.heightAnchor.constraint(equalToConstant: alreadyHaveAnAccountButton.height)
        ])
    }
    
    private func enumerateTextField(_ textField: UITextField) -> CreateAccountTextField {
        switch textField {
        case nameTextField:
            return .name
        case emailTextField:
            return .email
        case passwordTextField:
            return .password
        case confirmPasswordTextField:
            return .confirmPassword
        default:
            fatalError("Check text fields")
        }
    }
    
    private func deEnumerateTextField(_ textField: CreateAccountTextField) -> UITextField {
        switch textField {
        case .name:
            return nameTextField
        case .email:
            return emailTextField
        case .password:
            return passwordTextField
        case .confirmPassword:
            return confirmPasswordTextField
        }
    }

    @objc private func configureAlreadyHaveAnAccountButtonTapped() {
        presenter.alreadyHaveAnAccountButtonTapped()
    }

    @objc private func createAccountButtonTapped() {
        presenter.createAccountButtonTapped()
    }
    
    @objc private func termsAgreeButtonTapped() {
        presenter.termsAgreeButtonTapped()
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField: emailTextField.becomeFirstResponder()
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField: print("lets go!")
        default:
            fatalError("Check your text fields")
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

extension CreateAccountViewController {
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
        scrollView.contentOffset = CGPoint(x: 0, y: textFieldsStackView.top - 50)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension CreateAccountViewController: CreateAccountViewable {
    
    func getInputedText(fromTextField textField: CreateAccountTextField) -> String? {
        deEnumerateTextField(textField).text
    }
    
    func shakeTextField(_ textField: CreateAccountTextField) {
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
        presentAlertControllerOnMainTread(title: title ?? "", message: message ?? "", buttonTitle: buttonTitle ?? "")
    }
}
