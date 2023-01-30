//
//  SignUpViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SignUpViewModel {
    
    var userProfile: UserProfile?
    private let db = Firestore.firestore()
    
    var signUpUiState : (() -> ()) = { }
    
    var isSaved: Bool? {
        didSet {
            signUpUiState()
        }
    }
    
    func saveUserProfile(user: UserProfile) {
        userProfile = user
        guard let newUser = userProfile else { return }
        print(userProfile!)
        do {
            try db.collection("users").document(userProfile!.email).setData(from: newUser) { err in
                if let err = err {
                    self.isSaved = false
                    print("Error guardando los datos en el servidor: \(err.localizedDescription)")
                } else {
                    self.isSaved = true
                }
            }
        } catch let error {
            print("Error guardando los datos en el servidor: \(error.localizedDescription)")
        }
    }
    
}
