////
////  SaveNewPasswordViewController.swift
////  65AppsEducation-Andreev
////
////  Created by Илья Андреев on 18.10.2021.
////
//
// import UIKit
//
// protocol SaveNewPasswordViewable: AnyObject {
//    func showAllert(title: String?, message: String?, buttonTitle: String?)
//    func getPasswordAndConfirmedPassword() -> (String?, String?)
// } 
//
// class SaveNewPasswordView: UIViewController {
//    var presenter: SaveNewPasswordPresentable!
//    private let scrollView: UIScrollView = .init()
//    private let contentView: UIView = .init()
//    private let passwordTextField: mhTextField = .init()
//    private let confirmPasswordTextField: mhTextField = .init()
//    private let textFieldsStackView: UIStackView = .init()
//    private let saveNewPasswordButton: mhActionButton = .init()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureViewController()
//        configureScrollView()
//        configureContentView()
//        configurePasswordTextField()
//        configureConfirmPasswordTextField()
//        configureTextFieldsStackView()
//        configureSaveNewPasswordButton()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.isNavigationBarHidden = false
//    }
//
//    private func configureViewController() {
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = .white
//        view.addSubview(backgroundView)
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
//        ])
//        title = "Password recovery"
//        view.backgroundColor = Colors.mhwhite
//        registerKeyboardNotifications()
//        view.addSubViews(scrollView)
//        view.backgroundColor = Colors.mhwhite
//        view.addGestureRecognizer(
//            UITapGestureRecognizer(
//                target: view,
//                action: #selector(UIView.endEditing))
//        )
//    }
//
//    private func configureScrollView() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        scrollView.addSubViews(contentView)
//    }
//
//    private func configureContentView() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
//            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
//        ])
//        contentView.addSubViews(
//            textFieldsStackView,
//            saveNewPasswordButton
//        )
//    }
//
//    private func configurePasswordTextField() {
//        passwordTextField.placeholder = "Password"
//        passwordTextField.returnKeyType = .next
//        passwordTextField.isSecureTextEntry = true
//        passwordTextField.delegate = self
//
//        NSLayoutConstraint.activate([
//            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//
//    private func configureConfirmPasswordTextField() {
//        confirmPasswordTextField.placeholder = "Confirm Password"
//        confirmPasswordTextField.returnKeyType = .go
//        confirmPasswordTextField.isSecureTextEntry = true
//        confirmPasswordTextField.delegate = self
//
//        NSLayoutConstraint.activate([
//            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//
//    private func configureTextFieldsStackView() {
//        textFieldsStackView.addArrangedSubview(passwordTextField)
//        textFieldsStackView.addArrangedSubview(confirmPasswordTextField)
//
//        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
//        textFieldsStackView.spacing = 10
//        textFieldsStackView.distribution = .equalSpacing
//        textFieldsStackView.axis = .vertical
//        NSLayoutConstraint.activate([
//            textFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
//            textFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
//            textFieldsStackView.heightAnchor.constraint(equalToConstant: 110),
//            textFieldsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 243)
//        ])
//    }
//
//    private func configureSaveNewPasswordButton() {
//        saveNewPasswordButton.addTarget(
//            self,
//            action: #selector(saveNewPasswordButtonTapped),
//            for: .touchUpInside
//        )
//        saveNewPasswordButton.setTitle("SAVE NEW PASSWORD", for: .normal)
//
//        NSLayoutConstraint.activate([
//            saveNewPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
//            saveNewPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
//            saveNewPasswordButton.heightAnchor.constraint(equalToConstant: 50),
//            saveNewPasswordButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 20)
//        ])
//    }
//
//    @objc private func saveNewPasswordButtonTapped() {
//        presenter.saveNewPasswordButtonTapped()
//    }
// }
//
// extension SaveNewPasswordView: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case passwordTextField: confirmPasswordTextField.becomeFirstResponder()
//        case confirmPasswordTextField: saveNewPasswordButtonTapped()
//        default:
//            fatalError("Check yor text fields")
//        }
//        return true
//    }
// }
//
// extension SaveNewPasswordView {
//    private func registerKeyboardNotifications() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
//    }
//
//    private func removeKeyboardNotification() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc private func keyboardWillShow(_ notification: Notification) {
//        let userInfo = notification.userInfo
//        let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrameSize.height / 2)
//    }
//
//    @objc private func keyboardWillHide(_ notification: Notification) {
//        scrollView.contentOffset = CGPoint.zero
//    }
// }
//
// extension SaveNewPasswordView: SaveNewPasswordViewable {
//    func getPasswordAndConfirmedPassword() -> (String?, String?) {
//        (passwordTextField.text, confirmPasswordTextField.text)
//    }
//    
//    func showAllert(title: String?, message: String?, buttonTitle: String?) {
//        presentAlertControllerOnMainTread(
//            title: title ?? "",
//            message: message ?? "",
//            buttonTitle: buttonTitle ?? ""
//        )
//    }
// }
