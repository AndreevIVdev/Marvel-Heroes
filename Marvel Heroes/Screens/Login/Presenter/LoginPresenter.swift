//
//  LoginPresenter.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 16.11.2021.
//

protocol LoginPresentable: AnyObject {
    func signInButtonTapped()
    func dontHaveAnAccountButtonTapped()
    func forgotPasswordButtonTapped()
    func textDidEndEditing(inTextField textField: LoginViewTextField)
}

protocol LoginCoordinatable: AnyObject {
    var signIn: (() -> Void)! { get set }
    var noAccount: (() -> Void)! { get set }
    var forgotPassword: (() -> Void)! { get set }
}

final class LoginPresenter: LoginCoordinatable {
    
    var signIn: (() -> Void)!
    var noAccount: (() -> Void)!
    var forgotPassword: (() -> Void)!
    
    private weak var view: LoginViewable!
    private weak var firebaser: Firebaserable!
    
    init(view: LoginViewable, firebaser: Firebaserable) {
        self.view = view
        self.firebaser = firebaser
    }
}

extension LoginPresenter: LoginPresentable {
    func signInButtonTapped() {
        guard let email = view.getInputedText(fromTextField: .email),
              let password = view.getInputedText(fromTextField: .password) else {
                  view.showAllert(
                    title: "Empty fields!",
                    message: "Please fill all textfields and try again!",
                    buttonTitle: "Ок"
                  )
                  return
              }
        guard email.isValid(.email), password.isValid(.password) else {
            view.showAllert(
                title: "Incorrect enter!",
                message: "Please check all textfields and try again!",
                buttonTitle: "Ок"
            )
            return
        }
        
        firebaser.signIn(withEmail: email, password: password) { [weak self] _, _ in
            guard let self = self else {
                return
            }
            self.signIn()
        }
    }
    
    func dontHaveAnAccountButtonTapped() {
        noAccount()
    }
    
    func forgotPasswordButtonTapped() {
        forgotPassword()
    }
    
    func textDidEndEditing(inTextField textField: LoginViewTextField) {
        guard let text = view.getInputedText(fromTextField: textField),
              !text.isEmpty else {
            return
        }
        switch textField {
        case .email:
            if !text.isValid(.email) {
                view.shakeTextField(.email)
            }
        case .password:
            if !text.isValid(.password) {
                view.shakeTextField(.password)
            }
        }
    }
}
