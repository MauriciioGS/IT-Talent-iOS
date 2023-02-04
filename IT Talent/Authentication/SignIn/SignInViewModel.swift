//
//  SignInViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 04/02/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class SignInViewModel{
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    private var pass = String()
    
    var signInUiState : (() -> ()) = { }
    
    var userType: Int? {
        didSet {
            signInUiState()
        }
    }
    
    func signInUser(userEmail: String, userPass: String, context: NSManagedObjectContext) {
        mObjectContext = context
        pass = userPass
        Auth.auth().signIn(withEmail: userEmail, password: userPass) { (result, error) in
            if let result = result, error == nil {
                self.getUserType(result.user.email!)
            } else {
                print("Error al iniciar sesión")
                self.userType = 0
            }
        }
    }
    
    private func getUserType(_ email: String) {
        db.collection("users").document(email).getDocument(as: UserProfile.self) { result in
            switch result {
            case .success(let user):
                self.getLocale(user)
            case .failure(let error):
                self.userType = -1
                print("Error decoding user: \(error)")
            }
        }
    }
    
    private func getLocale(_ user: UserProfile) {
        do {
            if let _ = try mObjectContext!.fetch(User.fetchRequest()).first {
                self.userType = user.userType
            } else {
                let userLocal = User(context: mObjectContext!)
                userLocal.fullName = user.fullName
                userLocal.email = user.email
                userLocal.userType = Int16(user.userType)
                userLocal.pass = pass
                try mObjectContext!.save()
                print("Guardado localmente")
                self.userType = user.userType
            }
            
        } catch {
            print("Error al guardar localmente: \(error)")
            self.userType = -2
        }
    }
}
