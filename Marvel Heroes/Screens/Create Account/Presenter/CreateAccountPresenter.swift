//
//  CreateAccountPresenter.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 17.11.2021.
//

protocol CreateAccountPresentable {
    func createAccountButtonTapped()
    func termsAgreeButtonTapped()
    func alreadyHaveAnAccountButtonTapped()
    func textDidEndEditing(inTextField textField: CreateAccountTextField)
}

protocol CreateAccountCoordinatable {
    var createAccount: (() -> Void)! { get set }
    var termsAgreed: (() -> Void)! { get set }
    var alreadyHaveAnAccount: (() -> Void)! { get set }
}

final class CreateAccountPresenter: CreateAccountPresentable, CreateAccountCoordinatable {
    
    private weak var view: CreateAccountViewable!
    private weak var firebaser: Firebaserable!
    var createAccount: (() -> Void)!
    var termsAgreed: (() -> Void)!
    var alreadyHaveAnAccount: (() -> Void)!
    
    init(view: CreateAccountViewable, firebaser: Firebaserable) {
        self.view = view
        self.firebaser = firebaser
    }
    
    func createAccountButtonTapped() {
        guard let name = view.getInputedText(fromTextField: .name),
              let email = view.getInputedText(fromTextField: .email),
              let password = view.getInputedText(fromTextField: .password),
              let confirmedPassword = view.getInputedText(fromTextField: .confirmPassword) else {
                  view.showAllert(
                    title: "Empty fields!",
                    message: "Please fill all textfields and try again!",
                    buttonTitle: "Ок"
                  )
                  return
              }
        
        guard name.isValid(.name),
              email.isValid(.email),
              password.isValid(.password),
              confirmedPassword.isValid(.password) else {
                  view.showAllert(title: "Incorrect input!", message: "Please check text fields", buttonTitle: "OK")
                  return
              }
        
        guard password == confirmedPassword else {
            view.showAllert(
                title: "Passwords!", message: "Please check your passwords again", buttonTitle: "OK")
            return
        }
        
        firebaser.createUser(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                self.view.showAllert(
                    title: "Firebase error",
                    message: error.localizedDescription,
                    buttonTitle: "Ok"
                )
            } else {
                self.createAccount()
            }
        }
    }
    
    func termsAgreeButtonTapped() {
        termsAgreed()
    }
    
    func alreadyHaveAnAccountButtonTapped() {
        alreadyHaveAnAccount()
    }
    
    func textDidEndEditing(inTextField textField: CreateAccountTextField) {
        guard let text = view.getInputedText(fromTextField: textField),
              !text.isEmpty else {
            return
        }
        switch textField {
        case .name:
            if !text.isValid(.name) {
                view.shakeTextField(.name)
            }
        case .email:
            if !text.isValid(.email) {
                view.shakeTextField(.email)
            }
        case .password:
            if !text.isValid(.password) {
                view.shakeTextField(.password)
            }
        case .confirmPassword:
            if !text.isValid(.password) {
                view.shakeTextField(.confirmPassword)
            }
        }
    }
}
