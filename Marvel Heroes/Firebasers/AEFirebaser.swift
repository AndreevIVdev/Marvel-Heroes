//
//  mhFirebaser.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 30.12.2021.
//

import Firebase

protocol Firebaserable: FirebaserReadable, AnyObject {
    func start()
    
    func signIn(
        withEmail email: String,
        password: String,
        completion: ((AuthDataResult?, Error?) -> Void)?
    )
    
    func createUser(
        withEmail email: String,
        password: String,
        completion: ((AuthDataResult?, Error?) -> Void)?
    )
    
    func sendPasswordReset(
        withEmail email: String,
        completion: ((Error?) -> Void)?
    )
    
    func isLoggedIn() -> Bool
    
    func logOut() throws
}

protocol FirebaserReadable {
    func getEmail() -> String?
}

final class mhFirebaser: Firebaserable {
    
    func start() {
        FirebaseApp.configure()
    }
    
    func signIn(
        withEmail email: String,
        password: String,
        completion: ((AuthDataResult?, Error?) -> Void)? = nil
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(
        withEmail email: String,
        password: String,
        completion: ((AuthDataResult?, Error?) -> Void)? = nil
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func sendPasswordReset(withEmail email: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    func isLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    func getEmail() -> String? {
        Auth.auth().currentUser?.email
    }
}
