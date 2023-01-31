//
//  SignUpViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class SignUpViewModel {
    
    var userProfile: UserProfile?
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    
    var signUpUiState : (() -> ()) = { }
    
    var isSaved: Bool? {
        didSet {
            signUpUiState()
        }
    }
    
    func saveUserProfile(user: UserProfile, userPass: String, context: NSManagedObjectContext) {
        self.mObjectContext = context
        self.userProfile = user
        guard let newUser = userProfile else { return }
        print(userProfile!)
        do {
            try db.collection("users").document(userProfile!.email).setData(from: newUser) { err in
                if let err = err {
                    self.isSaved = false
                    print("Error guardando los datos en el servidor: \(err.localizedDescription)")
                } else {
                    self.saveLocal(userPass: userPass)
                }
            }
        } catch let error {
            print("Error guardando los datos en el servidor: \(error.localizedDescription)")
        }
    }
    
    func saveLocal(userPass: String) {
        if let context = self.mObjectContext {
            let user = User(context: context)
            user.fullName = userProfile?.fullName
            user.email = userProfile?.email
            user.userType = Int16(userProfile!.userType)
            user.pass = userPass
            do {
                try context.save()
                let getUser = try context.fetch(User.fetchRequest())
                if let _ = getUser.first {
                    self.isSaved = true
                } else {
                    self.isSaved = false
                }
            } catch {
                print("Error al guardar localmente: \(error)")
                self.isSaved = false
            }
        }
    }
    
}
