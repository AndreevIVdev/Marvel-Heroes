////
////  SaveNewPasswordPresenter.swift
////  65AppsEducation-Andreev
////
////  Created by Илья Андреев on 17.11.2021.
////
//
// import Foundation
//
// protocol SaveNewPasswordPresentable: AnyObject {
//    func saveNewPasswordButtonTapped()
// }
//
// class SaveNewPasswordPresenter: SaveNewPasswordPresentable {
//
//    private weak var view: SaveNewPasswordViewable!
//    private weak var router: mhCoordinatable!
//
//    init(view: SaveNewPasswordViewable, router: mhCoordinatable) {
//        self.view = view
//        self.router = router
//    }
//
//    func saveNewPasswordButtonTapped() {
//        let (password, confirmedPassword) = view.getPasswordAndConfirmedPassword()
//
//        guard let password = password,
//              let confirmedPassword = confirmedPassword else {
//                  view.showAllert(
//                    title: "Empty fields!",
//                    message: "Please fill all fields",
//                    buttonTitle: "OK"
//                  )
//                  return
//              }
//
//        guard password.isValid(.password),
//              confirmedPassword.isValid(.password) else {
//                  view.showAllert(
//                    title: "Incorrect input!",
//                    message: "Please check text fields",
//                    buttonTitle: "OK"
//                  )
//                  return
//              }
//        guard password == confirmedPassword else {
//            view.showAllert(
//                title: "Passwords!",
//                message: "Please check your passwords again",
//                buttonTitle: "OK"
//            )
//            return
//        }
//        view.showAllert(
//            title: "LETS Go!",
//            message: "Button tapped",
//            buttonTitle: "GO!"
//        )
//    }
// }
