//
//  SendRecoveryPresenter.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 17.11.2021.
//

protocol SendRecoveryPresentable: AnyObject {
    func sendCodeButtonTapped()
    func textDidEndEditing(inTextField textField: SendRecoveryCodeTextField)
}

protocol SendRecoveryCoordinatable {
    var sendCode: (() -> Void)! { get set }
}

final class SendRecoveryPresenter: SendRecoveryPresentable, SendRecoveryCoordinatable {
    
    var sendCode: (() -> Void)!
    private weak var view: SendRecoveryCodeViewable!
    private weak var firebaser: Firebaserable!
    
    init(view: SendRecoveryCodeViewable, firebaser: Firebaserable) {
        self.view = view
        self.firebaser = firebaser
    }
    
    func sendCodeButtonTapped() {
        guard let email = view.getInputedText(fromTextField: .email) else {
                  view.showAllert(
                    title: "Empty fields!",
                    message: "Please fill all textfields and try again!",
                    buttonTitle: "Ок",
                    completion: nil
                  )
                  return
              }
        
        guard email.isValid(.email)  else {
                  view.showAllert(
                    title: "Incorrect input!",
                    message: "Please check text fields",
                    buttonTitle: "OK",
                    completion: nil
                  )
                  return
              }
        
        firebaser.sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                self.view.showAllert(
                    title: "Firebase error",
                    message: error.localizedDescription,
                    buttonTitle: "Ok",
                    completion: nil
                )
            } else {
                self.view.showAllert(
                    title: "Done!",
                    message: "Please check your email and reset your password",
                    buttonTitle: "Ok",
                    completion: self.sendCode)
            }
        }
    }
    
    func textDidEndEditing(inTextField textField: SendRecoveryCodeTextField) {
        guard let text = view.getInputedText(fromTextField: textField),
              !text.isEmpty else {
            return
        }
        switch textField {
        case .email:
            if !text.isValid(.email) {
                view.shakeTextField(.email)
            }
        }
    }
}
